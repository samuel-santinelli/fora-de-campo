// Seleciona o projeto editavel, incluindo as dependencias de todas as cenas da raiz.
const fs=require('fs'), path=require('path');
const raiz=path.resolve(__dirname,'..'), encontrados=new Set(), pendentes=[];
for(const nome of fs.readdirSync(raiz)) if(/\.(gd|tscn|tres|gdshader)$/.test(nome))pendentes.push(nome);
while(pendentes.length){
 const relativo=pendentes.pop();if(encontrados.has(relativo))continue;
 const absoluto=path.resolve(raiz,relativo);
 if(!absoluto.startsWith(raiz+path.sep)||!fs.existsSync(absoluto))throw Error('Dependencia invalida: '+relativo);
 encontrados.add(relativo);
 if(/\.(gd|tscn|tres|gdshader)$/.test(relativo))for(const m of fs.readFileSync(absoluto,'utf8').matchAll(/["']res:\/\/([^"'\r\n]+)["']/g))pendentes.push(m[1]);
}
function incluir(rel){if(fs.existsSync(path.join(raiz,rel)))encontrados.add(rel);}
for(const rel of [...encontrados])for(const sufixo of ['.uid','.import'])incluir(rel+sufixo);
for(const rel of ['project.godot','export_presets.cfg','README.md','.gitignore','.gitattributes','.editorconfig'])incluir(rel);
function extras(pasta,filtro){for(const item of fs.readdirSync(path.join(raiz,pasta),{withFileTypes:true})){const rel=pasta+'/'+item.name;if(item.isDirectory())extras(rel,filtro);else if(filtro(rel))incluir(rel);}}
extras('arte',p=>p.endsWith('.md'));
extras('verificacoes',p=>/\.(gd|uid|cjs|ps1)$/.test(p));
extras('entrega',p=>/\.(md|cjs|ps1|cmd)$/.test(p));
const arquivos=[...encontrados].sort();
const bytes=arquivos.reduce((n,p)=>n+fs.statSync(path.join(raiz,p)).size,0);
fs.writeFileSync(path.join(__dirname,'fonte-manifesto.json'),JSON.stringify({arquivos,quantidade:arquivos.length,bytes},null,2)+'\n');
console.log('Codigo-fonte: '+arquivos.length+' arquivos, '+(bytes/1e6).toFixed(1)+' MB antes de compactar.');
