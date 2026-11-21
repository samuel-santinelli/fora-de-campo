// Síntese original determinística, sem gravações, vozes ou dependências externas.
const fs=require('fs'),path=require('path');
const dir=path.resolve(__dirname,'../Sons/Identidade');fs.mkdirSync(dir,{recursive:true});
const rate=22050,TAU=Math.PI*2;let seed=7127;
const noise=()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return seed/2147483648-1};
function wav(name,duration,sound){const n=Math.ceil(rate*duration),out=Buffer.alloc(44+n*2);out.write('RIFF');out.writeUInt32LE(out.length-8,4);out.write('WAVEfmt ',8);out.writeUInt32LE(16,16);out.writeUInt16LE(1,20);out.writeUInt16LE(1,22);out.writeUInt32LE(rate,24);out.writeUInt32LE(rate*2,28);out.writeUInt16LE(2,32);out.writeUInt16LE(16,34);out.write('data',36);out.writeUInt32LE(n*2,40);let peak=0;for(let i=0;i<n;i++){const t=i/rate,u=t/duration,edge=Math.min(1,t/.008,(duration-t)/.025),v=Math.max(-.75,Math.min(.75,sound(t,u)*Math.max(0,edge)));peak=Math.max(peak,Math.abs(v));out.writeInt16LE(Math.round(v*32767),44+i*2);}fs.writeFileSync(path.join(dir,name+'.wav'),out);console.log(`${name}: ${duration}s, pico ${peak.toFixed(3)}`);}
wav('var-carga',.85,(t,u)=>(.12+.1*u)*Math.sin(TAU*(180*t+650*t*t))*(.8+.2*Math.sin(TAU*16*t)));
wav('var-laser',.28,(t,u)=>.24*(1-u)*Math.sin(TAU*(1250*t-1300*t*t))+.07*noise()*(1-u));
wav('var-impacto',.42,(t,u)=>.35*Math.sin(TAU*(85*t-45*t*t))*Math.exp(-8*u)+.18*noise()*Math.exp(-12*u));
wav('var-pane',.42,(t,u)=>.2*Math.sin(TAU*(700*t-620*t*t))*(Math.sin(TAU*17*t)>0?1:.1)*(1-u));
wav('arrancada',.23,(t,u)=>.25*noise()*Math.sin(Math.PI*u)**2+.08*Math.sin(TAU*(160*t+900*t*t))*(1-u));
wav('passo-tanque',.16,(t,u)=>.3*Math.sin(TAU*65*t)*Math.exp(-12*u)+.1*noise()*Math.exp(-17*u));
wav('salto-goleiro',.20,(t,u)=>.18*Math.sin(TAU*(250*t+900*t*t))*(1-u)+.07*noise()*(1-u));
wav('apito-cartao',.20,(t,u)=>.17*(Math.sin(TAU*2100*t)+.3*Math.sin(TAU*2650*t))*(.8+.2*Math.sin(TAU*40*t))*(1-u*.5));
