// Servidor apenas local para testar a build Web, sem expor o projeto-fonte.
const http=require('http'),fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'../builds/Web');
const port=Number(process.argv[2]||8765);
const allowed=new Set(['index.html','index.js','index.wasm','index.pck','index.audio.worklet.js','index.audio.position.worklet.js','index.png','index.icon.png','index.apple-touch-icon.png']);
const mime={'.html':'text/html; charset=utf-8','.js':'text/javascript; charset=utf-8','.wasm':'application/wasm','.pck':'application/octet-stream','.png':'image/png'};
if(!Number.isInteger(port)||port<1024||port>65535)throw Error('Porta invalida.');
for(const name of ['index.html','index.js','index.wasm','index.pck'])if(!fs.existsSync(path.join(root,name)))throw Error('Build Web ausente ou incompleta. Execute entrega/exportar.ps1.');
const server=http.createServer((req,res)=>{
 if(!['GET','HEAD'].includes(req.method)){res.writeHead(405,{'Allow':'GET, HEAD'});res.end();return;}
 let name;try{name=decodeURIComponent(new URL(req.url,'http://localhost').pathname).slice(1)||'index.html';}catch{res.writeHead(400);res.end();return;}
 if(!allowed.has(name)){res.writeHead(404);res.end('Arquivo nao encontrado.');return;}
 const file=path.join(root,name);
 fs.stat(file,(err,stat)=>{
  if(err||!stat.isFile()){res.writeHead(404);res.end();return;}
  res.writeHead(200,{'Content-Type':mime[path.extname(name)]||'application/octet-stream','Content-Length':stat.size,'Cache-Control':'no-store','X-Content-Type-Options':'nosniff'});
  if(req.method==='HEAD'){res.end();return;}
  const stream=fs.createReadStream(file);stream.on('error',()=>res.destroy());res.on('close',()=>stream.destroy());stream.pipe(res);
 });
});
server.on('error',err=>{console.error(err.code==='EADDRINUSE'?`Porta ${port} ocupada. Use: node entrega/servir-web.cjs 8766`:err.message);process.exitCode=1;});
server.listen(port,'127.0.0.1',()=>{console.log(`FORA DE CAMPO: http://127.0.0.1:${port}/`);console.log('Abra esse endereco no navegador. Mantenha este processo aberto. Ctrl+C para encerrar.');});
