# Apenas analisa alpha; nao altera pixels ou imagens.
Add-Type -AssemblyName System.Drawing
$codigo = @'
using System;
using System.Drawing;
public static class LimitesDerrota {
    public static int[][] Medir(string caminho) {
        using (var im = new Bitmap(caminho)) {
            var dados = new int[6][];
            for (int q=0; q<6; q++) {
                int esquerda=512, topo=512, direita=0, fundo=0;
                for (int y=0; y<512; y++) for(int x=0; x<512; x++) {
                    if (im.GetPixel(x+q%3*512, y+q/3*512).A < 128) continue;
                    esquerda=Math.Min(esquerda,x); direita=Math.Max(direita,x);
                    topo=Math.Min(topo,y); fundo=Math.Max(fundo,y);
                }
                dados[q] = new int[]{esquerda,topo,direita,fundo};
            }
            return dados;
        }
    }
}
'@
Add-Type -TypeDefinition $codigo -ReferencedAssemblies System.Drawing
$pasta = Join-Path (Split-Path $PSScriptRoot -Parent) 'arte/animacoes/derrotas'
$linhas = @('extends RefCounted', '# Medicoes de alpha >= 128; nenhuma imagem foi modificada.', 'const QUADROS = {')
foreach ($imagem in Get-ChildItem -LiteralPath $pasta -Filter '*-v1.png') {
    $nome = $imagem.BaseName -replace '-v1$', ''
    $dados = [LimitesDerrota]::Medir($imagem.FullName)
    $quadros = ($dados | ForEach-Object { '[' + ($_ -join ', ') + ']' }) -join ', '
    $linhas += "`t`"$nome`": [$quadros],"
}
$linhas += '}'
$saida = Join-Path (Split-Path $PSScriptRoot -Parent) 'script_limites_derrotas.gd'
[System.IO.File]::WriteAllText($saida, ($linhas -join "`n") + "`n", [System.Text.UTF8Encoding]::new($false))
Get-Content -LiteralPath $saida
