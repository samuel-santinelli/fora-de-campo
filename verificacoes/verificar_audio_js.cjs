// Exerce o codigo real de canais do template exportado com nos de audio simulados.
const fs=require('fs'),vm=require('vm'),assert=require('assert');
const s=fs.readFileSync('builds/Web/index.js','utf8');
const begin=s.indexOf('var GodotAudio={');assert(begin>=0,'Biblioteca de audio nao encontrada');
const from=s.indexOf('{',begin);let depth=0,quote='',escape=false,end=-1;
for(let i=from;i<s.length;i++){const c=s[i];if(quote){if(escape){escape=false;continue;}if(c==='\\'){escape=true;continue;}if(c===quote)quote='';continue;}if(c==='"'||c==="'"||c==='`'){quote=c;continue;}if(c==='{')depth++;if(c==='}'&&--depth===0){end=i+1;break;}}
assert(end>from,'Objeto de audio incompleto');
const audio=vm.runInNewContext('var GodotAudio='+s.slice(from,end)+';GodotAudio',{console});
function node(){return {gain:{value:1},outputs:new Set(),connect(target){this.outputs.add(target);return target;},disconnect(){this.outputs.clear();}};}
const destination=node();audio.ctx={createGain:node,destination};
audio.buses=[];audio.set_sample_bus_count(1);const master=audio.buses[0];
audio.set_sample_bus_count(2);audio.set_sample_bus_send(1,0);
audio.set_sample_bus_count(3);audio.set_sample_bus_send(2,0);
assert.strictEqual(audio.buses[0],master,'Master mudou de indice');
assert(master.getOutputNode().outputs.has(destination),'Master desconectado da saida');
for(const i of [1,2])assert.strictEqual(audio.buses[i].getSend(),master,'Canal fora do Master');
audio.set_sample_bus_volume_db(1,-6);assert(Math.abs(audio.buses[1].getVolumeDb()+6)<.001);
audio.set_sample_bus_mute(2,true);assert.strictEqual(audio.buses[2]._muteNode.gain.value,0);
audio.set_sample_bus_mute(2,false);assert.strictEqual(audio.buses[2]._muteNode.gain.value,1);
assert(master.getOutputNode().outputs.has(destination),'Controles cortaram a saida');
console.log('Audio JS: canais em ordem, Master conectado, volume e mute funcionais.');
