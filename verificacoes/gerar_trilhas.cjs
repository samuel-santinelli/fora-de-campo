// Composicoes instrumentais originais por sintese. Sem amostras ou melodias externas.
const fs=require('fs'),path=require('path');
const dir=path.resolve(__dirname,'../Sons/Trilhas');fs.mkdirSync(dir,{recursive:true});
const rate=22050,TAU=2*Math.PI;
const tracks=[
 {file:'musica-inicio',title:'O Sete Entra em Campo',bpm:112,bars:16,chords:[[52,55,59],[48,52,55],[55,59,62],[50,54,57]],lead:[76,79,78,74,76,71,74,76],kind:'hero'},
 {file:'musica-fase',title:'Da Orla a Final',bpm:128,bars:32,chords:[[52,55,59],[48,52,55],[55,59,62],[50,54,57]],lead:[76,79,83,81,79,78,74,76],kind:'run'},
 {file:'musica-configuracoes',title:'Antes do Apito',bpm:92,bars:16,chords:[[52,55,59],[48,52,55],[57,60,64],[50,54,57]],lead:[71,76,79,78,74,76,71,67],kind:'room'},
 {file:'musica-game-over',title:'Ainda Ha Revanche',bpm:72,bars:8,chords:[[52,55,59],[48,52,55],[45,48,52],[47,51,54]],lead:[76,74,71,67,69,67,66,63],kind:'loss'},
 {file:'musica-vitoria',title:'Portoes da Final',bpm:124,bars:16,chords:[[55,59,62],[50,54,57],[52,55,59],[48,52,55]],lead:[79,83,86,83,81,79,78,79],kind:'win'}
];
const stats=[];
for(const cfg of tracks){
 const beat=60/cfg.bpm,duration=cfg.bars*4*beat,n=Math.round(rate*duration);
 const left=new Float32Array(n),right=new Float32Array(n);let seed=712700+cfg.bpm;
 const rnd=()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return seed/2147483648-1;};
 function event(time,len,amp,pan,fn){const start=Math.round(time*rate),count=Math.ceil(len*rate),l=Math.sqrt((1-pan)*.5),r=Math.sqrt((1+pan)*.5);for(let i=0;i<count;i++){const t=i/rate,u=t/len;const value=fn(t,u)*amp;const j=(start+i)%n;left[j]+=value*l;right[j]+=value*r;}}
 function note(time,midi,len,amp,timbre='pluck',pan=0){const f=440*2**((midi-69)/12);event(time,len,amp,pan,(t,u)=>{
   if(timbre==='pad'){const env=Math.min(1,t/.18)*Math.min(1,(len-t)/.5);return env*(Math.sin(TAU*f*t)+.28*Math.sin(TAU*f*1.003*t)+.15*Math.sin(TAU*f*2*t))*.65;}
   if(timbre==='bass')return Math.min(1,t/.008)*Math.exp(-3.2*u)*(Math.sin(TAU*f*t)+.25*Math.sin(TAU*f*2*t))*.8;
   if(timbre==='brass'){const env=Math.min(1,t/.035)*Math.min(1,(len-t)/.09);return env*(Math.sin(TAU*f*t)+.34*Math.sin(TAU*f*2*t)+.16*Math.sin(TAU*f*3*t))*.65;}
   return Math.min(1,t/.003)*Math.exp(-5*u)*(Math.sin(TAU*f*t)+.30*Math.sin(TAU*f*2.002*t)*Math.exp(-6*u)+.14*Math.sin(TAU*f*3*t)*Math.exp(-9*u));
 });}
 function drum(time,type,amp=1){if(type==='kick')event(time,.3,.32*amp,0,(t)=>Math.sin(TAU*(48*t+2.8*(1-Math.exp(-t*40))))*Math.exp(-t*19));
  if(type==='clap')event(time,.18,.11*amp,.05,(t)=>rnd()*Math.exp(-t*29)*(.65+.35*Math.cos(TAU*76*t)));
  if(type==='hat')event(time,.075,.037*amp,-.25,(t)=>rnd()*Math.exp(-t*65));
  if(type==='tom')event(time,.2,.13*amp,.25,(t)=>Math.sin(TAU*(135*t+.6*(1-Math.exp(-t*40))))*Math.exp(-t*24));}
 for(let bar=0;bar<cfg.bars;bar++){
  const chord=cfg.chords[bar%4],at=bar*4*beat,soft=cfg.kind==='loss'||cfg.kind==='room',bridge=cfg.kind==='run'&&bar>=16&&bar<24;
  chord.forEach((m,i)=>note(at,m+12,beat*4.8,soft?.052:.043,'pad',(i-1)*.5));
  for(let b=0;b<4;b++){
   note(at+b*beat,chord[0]-12,beat*(soft?.9:.7),soft?.15:.20,'bass');
   if(!soft){drum(at+b*beat,'kick',bridge?.65:1);if(b%2===1){drum(at+b*beat,'clap');drum(at+b*beat+.035,'clap',.4);}drum(at+b*beat,'hat');drum(at+(b+.5)*beat,'hat',.55);}
   else if(cfg.kind==='room'&&b%2===0)drum(at+b*beat,'hat',.4);
  }
  if(!soft&&!bridge){for(const off of [2.75,3.5])drum(at+off*beat,'tom',.7);}
  const arp=soft?[0,1,2,1]:[0,2,1,2,0,1,2,1];
  arp.forEach((idx,k)=>note(at+k*(4/arp.length)*beat,chord[idx]+12,beat*1.1,soft?.075:.065,'pluck',k%2?.35:-.35));
  if(cfg.kind==='loss'){
   note(at+.25*beat,cfg.lead[bar],beat*2.9,.17,'pluck',.05);
   note(at+2.5*beat,chord[1]+12,beat*1.6,.065,'pluck',-.2);
  }else if(cfg.kind==='room'){
   if(bar%2===0)note(at+beat,cfg.lead[bar%8],beat*2.1,.07,'pluck',.2);
  }else{
   const offsets=[.0,.75,1.5,2.5,3.25];
   if(bar%4<3&&!bridge)offsets.forEach((off,k)=>note(at+off*beat,cfg.lead[(bar*2+k)%8],beat*(k===4?.65:.48),cfg.kind==='win'?.14:.115,'brass',.08));
   else if(bar%2===0)note(at+beat,cfg.lead[(bar+2)%8]-12,beat*1.8,.095,'brass',-.15);
  }
  if(!soft&&(bar%8===7))for(let k=0;k<4;k++)drum(at+(3+k*.25)*beat,'tom',.7+k*.08);
 }
 // Reverberacao/delay circular para preservar caudas na emenda do loop.
 const dryL=left.slice(),dryR=right.slice(),d1=Math.round(beat*.75*rate),d2=Math.round(.071*rate);
 let peak=0,square=0;for(let i=0;i<n;i++){const a=(i-d1+n)%n,b=(i-d2+n)%n;left[i]+=dryR[a]*.17+dryL[b]*.08;right[i]+=dryL[a]*.17+dryR[b]*.08;peak=Math.max(peak,Math.abs(left[i]),Math.abs(right[i]));}
 const gain=.78/peak,out=Buffer.alloc(44+n*4);out.write('RIFF');out.writeUInt32LE(out.length-8,4);out.write('WAVEfmt ',8);out.writeUInt32LE(16,16);out.writeUInt16LE(1,20);out.writeUInt16LE(2,22);out.writeUInt32LE(rate,24);out.writeUInt32LE(rate*4,28);out.writeUInt16LE(4,32);out.writeUInt16LE(16,34);out.write('data',36);out.writeUInt32LE(n*4,40);
 for(let i=0;i<n;i++){const l=left[i]*gain,r=right[i]*gain;square+=l*l+r*r;out.writeInt16LE(Math.round(l*32767),44+i*4);out.writeInt16LE(Math.round(r*32767),46+i*4);}
 fs.writeFileSync(path.join(dir,cfg.file+'.wav'),out);
 const row={...cfg,seconds:n/rate,frames:n,rate,peak:.78,rms:Math.sqrt(square/(n*2)),bytes:out.length};stats.push(row);console.log(`${cfg.file}: ${row.seconds.toFixed(2)}s, ${cfg.bpm} BPM, RMS ${row.rms.toFixed(3)}`);
}
fs.writeFileSync(path.join(dir,'composicoes.json'),JSON.stringify(stats,null,2)+'\n');
