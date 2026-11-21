@echo off
title FORA DE CAMPO - teste Web local
echo Abra http://127.0.0.1:8765/ no navegador.
echo Mantenha esta janela aberta enquanto joga. Ctrl+C para encerrar.
node "%~dp0servir-web.cjs"
pause
