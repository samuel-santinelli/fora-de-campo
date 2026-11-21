# Etapa 1 concluída — 12/11/2026

Atualização de 20/11/2026: regenerados os pacotes com [sete animações de derrota e efeitos de combate originais](../arte/animacoes/derrotas/INTEGRACAO-E-PROMPTS.md). Web: 55,3 MB; Windows: 83,1 MB. O teste das derrotas passou também dentro do PCK Web. Consulte `pacotes.json` para hashes e tamanhos exatos.

Atualização: os pacotes foram regenerados após as correções de [estabilidade Web e interface](../arte/audio/ESTABILIDADE-WEB-v2.md). Consulte `pacotes.json` para os tamanhos e hashes atuais; a tabela abaixo registra a exportação inicial desta etapa.

Exportações release geradas com Godot 4.7.2.stable.official.ed1daf0bf e modelos oficiais da mesma versão.

| Pacote | Tamanho | Conteúdo |
|---|---:|---|
| ForaDeCampo-Web.zip | 44.574.597 bytes, aproximadamente 44,6 MB | index.html na raiz, JavaScript, WASM, PCK, worklets de áudio e ícones |
| ForaDeCampo-Windows.zip | 72.405.266 bytes, aproximadamente 72,4 MB | ForaDeCampo.exe e ForaDeCampo.pck na raiz |

Arquivos em `entrega/`. Versões descompactadas em `builds/Web/` e `builds/Windows/`. Não mover o EXE separado do PCK. Para Windows, extrair o ZIP e abrir `ForaDeCampo.exe`. Para Web, o conteúdo precisa ser servido por HTTP ou publicado no itch.io; abrir index.html diretamente pelo explorador não substitui esse teste.

## Validações realizadas

- Modelos oficiais baixados, versão interna do TPZ conferida e arquivos necessários extraídos no cache local.
- Duas exportações concluídas com sucesso.
- Corrigido o perfil inicial, que omitia dependências carregadas por scripts. Agora 147 recursos são selecionados explicitamente a partir das cinco cenas e dos autoloads. O preparo é reproduzível por `preparar-recursos.cjs` e ocorre antes de cada exportação.
- Build Windows iniciada em modo headless, com diretório de trabalho da própria build, sem carregar o projeto-fonte.
- Cinco cenas do pacote carregadas e instanciadas pelo teste externo `verificar_cenas_pacote.gd`, sem depender das artes do workspace. Resultado: 0 falhas e nenhuma mensagem de erro de script/recurso nesse teste final.
- Cabeçalhos EXE, WASM e PCK válidos; HTML referencia index.js e o título do projeto.
- PCKs Web e Windows são idênticos byte a byte, incluindo recursos novos.
- Estrutura dos ZIPs e SHA-256 conferidos. Manifesto em `pacotes.json`. Arquivos .import do editor não entram nos ZIPs.

Logs finais: `verificacoes/exportacao-web-atual.log`, `exportacao-windows-atual.log`, `boot-windows-atual.log`, `cenas-pacote-atual.log`.

## Repetir a exportação

Com Node.js e os modelos locais já disponíveis:

```powershell
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File .\entrega\exportar.ps1
```

A política RemoteSigned vale apenas para esse processo; não foi alterada a política permanente do Windows. Detalhes dos modelos em `MODELOS-EXPORTACAO.md`. Os modelos ficam em `.godot/modelos-exportacao/` e não fazem parte dos pacotes.

## Próxima etapa

Teste interativo das versões exportadas: navegador via HTTP e Windows extraído do ZIP. Conferir imagem, comandos, áudio, pausa, combate, coletas, derrota e chegada ao estádio. A validação headless acima não substitui uma partida completa nem demonstra execução do WASM no navegador. A publicação no itch.io, prints e URLs continuam pendentes.
