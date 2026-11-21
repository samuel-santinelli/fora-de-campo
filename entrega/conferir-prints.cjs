// Confere os arquivos e registra origem/editoria; nao altera pixels.
const fs=require('fs'),path=require('path'),crypto=require('crypto'),vm=require('vm');
const pasta=path.join(__dirname,'divulgacao-v1');
const frases={
 '14-superchute-em-chamas':'CARREGUE O CHUTE. SOLTE O PODER.',
 '18-desvio-do-laser':'A DECIS\u00c3O \u00c9 DELE. A REA\u00c7\u00c3O \u00c9 SUA.',
 '07-haaland-navio':'O TANQUE CHEGOU PELO MAR.',
 '16-arrancada-do-mbappe':'ELE TEM VELOCIDADE. VOC\u00ca TEM O MOMENTO CERTO.',
 '03-treino':'SEU CAMINHO AT\u00c9 A FINAL COME\u00c7A FORA DE CAMPO.'
};
const anterior=JSON.parse(fs.readFileSync(path.join(pasta,'manifesto.json'),'utf8').replace(/^\uFEFF/,''));
const arquivos=fs.readdirSync(pasta).filter(p=>p.endsWith('.png')).sort();
if(arquivos.length!==19)throw Error('A galeria deve ter exatamente 19 PNGs.');
const imagens=arquivos.map(arquivo=>{
 const b=fs.readFileSync(path.join(pasta,arquivo));
 if(b.toString('hex',0,8)!=='89504e470d0a1a0a')throw Error('PNG invalido: '+arquivo);
 const largura=b.readUInt32BE(16),altura=b.readUInt32BE(20),sha256=crypto.createHash('sha256').update(b).digest('hex');
 const nome=arquivo.replace(/\.png$/,'');const frase=frases[nome];
 const antes=anterior.imagens.find(i=>i.arquivo===arquivo);
 if(!antes)throw Error('Arquivo nao previsto na selecao original: '+arquivo);
 if(frase){if(largura<1400||altura<750)throw Error('Resolucao promocional insuficiente: '+arquivo);if(!antes.tipo&&sha256===antes.sha256)throw Error('Versao antiga ainda presente: '+arquivo);}
 else if(sha256!==antes.sha256||largura!==1920||altura!==1080)throw Error('Captura sem frase foi alterada: '+arquivo);
 return{arquivo,tipo:frase?'promocional_com_texto':'captura_sem_edicao',largura,altura,bytes:b.length,sha256,...(frase?{frase,base_captura_sha256:antes.base_captura_sha256||antes.sha256,ferramenta:'imagegen integrada'}:{})};
});
const html=fs.readFileSync(path.join(pasta,'galeria.html'),'utf8');
for(const m of html.matchAll(/<script>([\s\S]*?)<\/script>/g))new vm.Script(m[1],{filename:'galeria.html'});
const ids=[...html.matchAll(/\['([^']+)','(?:destaque|percurso|tela)/g)].map(m=>m[1]);
if(ids.length!==19||new Set(ids).size!==19||ids.some(id=>!fs.existsSync(path.join(pasta,id+'.png'))))throw Error('Referencias da galeria incompletas ou duplicadas.');
fs.writeFileSync(path.join(pasta,'manifesto.json'),JSON.stringify({origem:anterior.origem,pacote_sha256:anterior.pacote_sha256,autor:'Samuel Santinelli Mantovani',editoria:'5 pecas promocionais com texto e 14 capturas sem sobreposicao',imagens},null,2)+'\n');
console.log('Conferido: 5 pecas novas, 14 capturas preservadas, 19 referencias validas na galeria.');
