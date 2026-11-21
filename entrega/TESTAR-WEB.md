# Testar a versão Web localmente

Não abrir `builds/Web/index.html` diretamente pelo explorador: a URL file:// pode bloquear o fetch de WASM/PCK, mostrando **Failed to fetch**.

Com Node.js instalado, abrir `entrega/testar-web.cmd` e manter a janela aberta. Acessar:

**http://127.0.0.1:8765/**

Alternativa pelo terminal, na pasta do projeto:

```powershell
node entrega/servir-web.cjs
```

Se a porta estiver ocupada por outro programa, usar `node entrega/servir-web.cjs 8766` e acessar http://127.0.0.1:8766/. Para encerrar o servidor, pressionar Ctrl+C no terminal.

O servidor só escuta em 127.0.0.1 e disponibiliza os nove arquivos da build Web. Não publica o jogo na internet nem disponibiliza o código-fonte. WASM é enviado com o tipo application/wasm. Não é preciso reexportar o jogo para usá-lo.

Conferência nesta etapa: HTML, JS, WASM, PCK e os dois worklets responderam HTTP 200; caminho para o projeto-fonte respondeu 404. Isso confirma a entrega dos arquivos por HTTP; a partida no navegador ainda deve ser testada.
