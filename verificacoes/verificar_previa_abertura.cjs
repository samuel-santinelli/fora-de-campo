const fs=require('fs'),path=require('path'),vm=require('vm'),assert=require('assert');
const dir=path.resolve(__dirname,'../arte/telas');
function element(){return {disabled:false,handlers:{},textContent:'',focus(){this.focused=true;},classList:{values:new Set(),add(n){this.values.add(n)},remove(n){this.values.delete(n)},toggle(n,v){v?this.add(n):this.remove(n)}},addEventListener(n,f){this.handlers[n]=f;}};}
async function test(reduced){
 const draws=[],ctx=new Proxy({},{get:(o,k)=>o[k]||((...a)=>draws.push([k,...a]))});
 const nodes=Object.fromEntries(['.stage','.menu','#status','.animation','.skip','.end','#show-menu','#compact'].map(n=>[n,element()]));
 const replay=element(),buttons=[element(),element(),element()];nodes['.end'].querySelector=()=>replay;nodes['.animation'].getContext=()=>ctx;
 let callback=null,queued=0;const keys={};
 class Image {set src(file){assert(fs.existsSync(path.join(dir,file)));this.onload();}}
 const box=vm.createContext({window:{matchMedia:()=>({matches:reduced})},Image,Promise,performance:{now:()=>0},requestAnimationFrame:f=>{callback=f;queued++;return queued},cancelAnimationFrame:()=>{callback=null},document:{querySelector:s=>nodes[s],querySelectorAll:()=>buttons,addEventListener:(n,f)=>keys[n]=f}});
 vm.runInContext(fs.readFileSync(path.join(dir,'abertura-dados.js'),'utf8'),box);
 const data=box.window.ABERTURA_DADOS;assert.equal(data.frames.length,6);
 for(const f of data.frames){assert(f.w>0&&f.h>0&&f.x>=0&&f.y>=0&&f.x+f.w<=data.width&&f.y+f.h<=data.height);}
 vm.runInContext(fs.readFileSync(path.join(dir,'previa-abertura.js'),'utf8'),box);
 await new Promise(r=>setImmediate(r));assert(!buttons[0].disabled);
 buttons[0].handlers.click();const count=queued;buttons[0].handlers.click();assert.equal(queued,count);
 if(!reduced){for(let t=100;t<=3300&&callback;t+=100){const f=callback;callback=null;f(t);}assert(draws.some(d=>d[0]==='fillText'&&d[1]==='SIUUU!'));}
 assert(!nodes['.end'].classList.values.has('hidden'));replay.handlers.click();assert(!buttons[0].disabled);
 if(!reduced){buttons[0].handlers.click();keys.keydown({key:'Escape',preventDefault(){}});assert(nodes['#status'].textContent.includes('concluída'));replay.handlers.click();buttons[0].handlers.click();nodes['.skip'].handlers.click();assert(nodes['#status'].textContent.includes('concluída'));}
}
(async()=>{await test(false);await test(true);console.log('Prévia: seis recortes, sequência completa, clique repetido, repetir, pular, Esc e movimento reduzido verificados. DOM/canvas simulados.');})().catch(e=>{console.error(e);process.exit(1)});
