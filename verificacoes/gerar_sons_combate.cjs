// Foley sintetizado original de FORA DE CAMPO. PCM mono, sem samples externos.
const fs = require('fs'), path = require('path');
const dir = path.resolve(__dirname, '../Sons/Identidade');
fs.mkdirSync(dir, {recursive:true});
const rate = 22050, tau = 2*Math.PI;
let seed = 7102026;
const noise = () => { seed = (Math.imul(seed,1664525)+1013904223)>>>0; return seed/2147483648-1; };
function wav(name, duration, synth) {
  const n=Math.ceil(rate*duration), out=Buffer.alloc(44+2*n);
  out.write('RIFF'); out.writeUInt32LE(out.length-8,4); out.write('WAVEfmt ',8);
  out.writeUInt32LE(16,16); out.writeUInt16LE(1,20); out.writeUInt16LE(1,22);
  out.writeUInt32LE(rate,24); out.writeUInt32LE(rate*2,28); out.writeUInt16LE(2,32);
  out.writeUInt16LE(16,34); out.write('data',36); out.writeUInt32LE(n*2,40);
  for(let i=0;i<n;i++) {
    const t=i/rate, u=t/duration, edge=Math.max(0,Math.min(1,t/.006,(duration-t)/.025));
    const v=Math.max(-.65,Math.min(.65,synth(t,u)*edge));
    out.writeInt16LE(Math.round(v*32767),44+i*2);
  }
  fs.writeFileSync(path.join(dir,name+'.wav'),out);
  console.log(name+' '+duration+'s');
}
wav('pulo-cr7',.24,(t,u)=>.2*Math.sin(tau*(160*t+720*t*t))*(1-u)+.12*noise()*Math.exp(-20*u));
wav('carrinho-cr7',.36,(t,u)=>.23*noise()*Math.sin(Math.PI*u)**.7+.11*Math.sin(tau*(95*t-30*t*t))*Math.exp(-8*u));
wav('chute-cr7',.23,(t,u)=>.42*Math.sin(tau*(135*t-180*t*t))*Math.exp(-13*u)+.22*noise()*Math.exp(-18*u)+.06*Math.sin(tau*780*t)*Math.exp(-7*u));
wav('dano-cr7',.27,(t,u)=>.3*Math.sin(tau*(130*t-160*t*t))*Math.exp(-10*u)+.16*noise()*Math.exp(-14*u));
wav('dano-rival',.19,(t,u)=>.28*Math.sin(tau*(185*t-260*t*t))*Math.exp(-12*u)+.18*noise()*Math.exp(-17*u));
wav('dano-tanque',.26,(t,u)=>.32*Math.sin(tau*(85*t-75*t*t))*Math.exp(-11*u)+.17*noise()*Math.exp(-14*u));
wav('dano-metal',.29,(t,u)=>.17*(Math.sin(tau*380*t)+.6*Math.sin(tau*991*t)+.3*Math.sin(tau*1670*t))*Math.exp(-8*u)+.08*noise()*Math.exp(-19*u));
wav('coleta-campo',.32,(t,u)=>.17*Math.sin(tau*(t<.1?523.25:t<.2?659.25:783.99)*t)*Math.sin(Math.PI*u)+.05*Math.sin(tau*1568*t)*(1-u));
wav('queda-rival',.50,(t,u)=>.3*Math.sin(tau*(95*t-65*t*t))*Math.exp(-11*u)+.20*noise()*Math.exp(-12*u));
wav('queda-tanque',.7,(t,u)=>.38*Math.sin(tau*(62*t-26*t*t))*Math.exp(-10*u)+.22*noise()*Math.exp(-12*u));
wav('desligamento-robo',1.0,(t,u)=>.17*Math.sin(tau*(620*t-290*t*t))*(Math.sin(tau*23*t)>-.3?1:.1)*(1-u)+.09*noise()*Math.exp(-7*u));
wav('colapso-var',3.2,(t,u)=>.12*Math.sin(tau*(420*t-60*t*t))*(Math.sin(tau*(12*t+5*t*t))>0?1:.1)*(1-u)+.13*noise()*Math.exp(-18*Math.abs(t-1.65))+.25*Math.sin(tau*55*t)*Math.exp(-20*Math.abs(t-2.3)));
