# Configurações — adaptação visual

Atualização: composição refeita com arte do vestiário, painel menor à esquerda e interruptor próprio; detalhes e prompt em `CONFIGURACOES-VESTIARIO-v1.md`. As dimensões/descrições abaixo registram a primeira adaptação.

`script_configuracoes.gd` reaproveita a cena, controles, conexões, música e bus Master existentes. Fundo do estádio já aprovado (`inicio-fundo-v2.png`), escurecimento e painel central dourado. Sem nova arte raster ou sistemas de áudio. Layout e estilos novos são montados em execução.

CheckButton agora diz Silenciar todo o áudio; descrição explica músicas e efeitos. Estado inicial vem do AudioServer, com texto Áudio ligado / Áudio silenciado atualizado ao clicar. A preferência continua apenas na sessão, como no original: não foi adicionada gravação de configuração entre execuções. Não anuncia controle independente de música ou efeitos.

Foco inicial no CheckButton, contorno de foco visível e botão Voltar ao início com estilo do menu. Retorno diferido e protegido contra acionamento repetido. Configurações não redefine vidas ou pontos. Painel e controles são posicionados proporcionalmente ao viewport lógico; antiga escala 3 do CheckButton é substituída pelo layout atual.

## Verificação

Três verificações Godot 4.7.2 headless com zero falhas: configurações, auditoria das telas e menu inicial. Teste específico confere foco, mute/unmute real do Master, rótulo de estado, persistência ao retornar e reabrir, preservação de vidas/pontos e controles contidos em janelas 1152×648, 640×480 e 1920×1080. Auditoria confirma conexões e áudio configurado; menu mantém abertura e acesso às configurações.

Logs `verificacoes/configuracoes-*.log`. Persistem mensagens ambientais de certificado e recursos em uso ao encerrar. Não houve audição nem inspeção em janela real nesta etapa. Conferir pela opção Configurações no menu ou abrir `cena_configuracoes.tscn` com F6.

As telas principais já receberam a adaptação visual. Próxima etapa é auditar e implementar o que faltar em limite de munição e itens de recuperação de vida/bolas, antes da revisão final de áudio e exportação.
