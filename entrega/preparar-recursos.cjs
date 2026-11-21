// Fecha explicitamente as dependencias de cenas e scripts usadas em runtime.
// Nao inclui previas, testes, documentos ou versoes antigas sem referencia.
const fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'..');
const roots=['cena_inicio.tscn','cena_fase.tscn','cena_game_over.tscn','cena_final.tscn','cena_configuracoes.tscn','script_global.gd','script_preferencias.gd'];
const pending=roots.map(p=>'res://'+p),found=new Set(),missing=new Set();
while(pending.length){
 const resource=pending.shift();if(found.has(resource))continue;
 const file=path.resolve(root,resource.slice(6));
 if(!file.startsWith(root+path.sep))throw Error('Recurso fora do projeto: '+resource);
 if(!fs.existsSync(file)){missing.add(resource);continue;}
 if(!fs.statSync(file).isFile())continue;
 found.add(resource);
 if(/\.(gd|tscn|tres|gdshader)$/i.test(file)){
  const text=fs.readFileSync(file,'utf8');
  for(const match of text.matchAll(/["'](res:\/\/[^"'\r\n]+)["']/g))pending.push(match[1]);
 }
}
if(missing.size)throw Error('Dependencias ausentes: '+[...missing].join(', '));
const resources=[...found].sort(),cfg=path.join(root,'export_presets.cfg');
let text=fs.readFileSync(cfg,'utf8');
text=text.replace(/^export_filter="(?:scenes|resources)"/gm,'export_filter="resources"');
text=text.replace(/^export_files=PackedStringArray\([^\r\n]*\)/gm,'export_files=PackedStringArray('+resources.map(p=>JSON.stringify(p)).join(', ')+')');
fs.writeFileSync(cfg,text);
fs.writeFileSync(path.join(__dirname,'recursos-exportados.json'),JSON.stringify({entradas:roots,quantidade:resources.length,recursos:resources},null,2)+'\n');
console.log('Recursos de jogo explicitamente selecionados: '+resources.length);
