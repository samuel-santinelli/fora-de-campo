# Modelos de exportação locais

Os perfis usam os modelos oficiais do Godot **4.7.2.stable**, guardados dentro do cache do projeto:

`.godot/modelos-exportacao/4.7.2.stable/`

Isso evita depender da instalação global do editor. A pasta `.godot` é ignorada pelo Git e não faz parte do jogo exportado. Se o projeto for movido para outra máquina, os modelos precisam ser preparados novamente.

Fonte: [download oficial do Godot 4.7.2](https://godotengine.org/download/archive/4.7.2-stable/), opção **Export templates / Standard**. O pacote se chama `Godot_v4.7.2-stable_export_templates.tpz` e é um arquivo ZIP. Extrair de `templates/`:

- `web_nothreads_debug.zip`
- `web_nothreads_release.zip`
- `windows_debug_x86_64.exe`
- `windows_release_x86_64.exe`

Copiar também `version.txt` e `icudt_godot.dat`, se presentes. Não usar modelos .NET ou de outra versão.

Após o download completo, `entrega/instalar-modelos.ps1` valida a versão interna do TPZ e extrai apenas os modelos necessários no cache local. Depois executar `entrega/exportar.ps1`. O script confere a versão, exporta as duas plataformas, valida os arquivos essenciais e gera os ZIPs. O manifesto `entrega/pacotes.json` registra o conteúdo e SHA-256 dos pacotes. Os logs ficam em `verificacoes/exportacao-web-atual.log` e `verificacoes/exportacao-windows-atual.log`.

Os ZIPs devem conter os arquivos exportados diretamente na raiz, sem a pasta Web/Windows envolvendo o conteúdo. Isso já é feito pelo script. Arquivos .import do editor são excluídos.

No Windows com execução de scripts bloqueada, o comando usado nesta sessão foi `powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File .\entrega\instalar-modelos.ps1`. Isso vale apenas para o processo e não altera a política permanente. A exportação exige Node.js para preparar a lista explícita de recursos; não é uma dependência do jogo final.
