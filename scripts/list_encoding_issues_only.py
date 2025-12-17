# -*- coding: utf-8 -*-
"""
Script para APENAS LISTAR problemas de encoding sem fazer alterações
"""

import os
import re
from pathlib import Path

SEARCH_PATH = r"D:\tagbean\frontend\lib"

# Padrões que indicam problemas de encoding
PADROES_PROBLEMAS = [
    # Acentos corrompidos tipo 1
    r'Ã¡',  # á
    r'Ã©',  # é
    r'Ã­',  # í
    r'Ã³',  # ó
    r'Ãº',  # ú
    r'Ã£',  # ã
    r'Ãµ',  # õ
    r'Ã§',  # ç
    r'Â',   # caracteres especiais
    
    # Palavras sem acento (tipo 2) - APENAS em strings literais
    r'"[^"]*\b(Usuarios|Configuraes|Importao|Mdulo|Histrico|Aes)\b[^"]*"',
    r"'[^']*\b(Usuarios|Configuraes|Importao|Mdulo|Histrico|Aes)\b[^']*'",
]

def scan_file(file_path):
    """Escaneia um arquivo em busca de problemas de encoding"""
    problemas = []
    
    try:
        # Tentar ler com diferentes encodings
        content = None
        encoding_usado = None
        for enc in ['utf-8', 'utf-8-sig', 'latin-1', 'cp1252']:
            try:
                with open(file_path, 'r', encoding=enc) as f:
                    content = f.read()
                encoding_usado = enc
                break
            except:
                continue
        
        if content is None:
            return [f"ERRO: Não foi possível ler o arquivo"]
        
        linhas = content.split('\n')
        
        for i, linha in enumerate(linhas, 1):
            for padrao in PADROES_PROBLEMAS:
                matches = re.finditer(padrao, linha)
                for match in matches:
                    problemas.append({
                        'linha': i,
                        'coluna': match.start(),
                        'texto': match.group(),
                        'contexto': linha.strip()[:100]
                    })
    
    except Exception as e:
        return [f"ERRO: {e}"]
    
    return problemas

def main():
    print("="*80)
    print("    RELATÓRIO DE PROBLEMAS DE ENCODING - SOMENTE LEITURA")
    print("="*80)
    print()
    
    path = Path(SEARCH_PATH)
    dart_files = list(path.rglob("*.dart"))
    
    print(f"Analisando {len(dart_files)} arquivos .dart...")
    print()
    
    total_problemas = 0
    arquivos_com_problemas = 0
    
    for file_path in dart_files:
        relative = str(file_path).replace(SEARCH_PATH, "").lstrip("\\")
        problemas = scan_file(file_path)
        
        if problemas:
            print(f"\n📁 {relative}")
            print("-" * len(relative))
            
            for problema in problemas:
                if isinstance(problema, dict):
                    print(f"  Linha {problema['linha']}: {problema['texto']}")
                    if len(problema['contexto']) < 100:
                        print(f"    → {problema['contexto']}")
                    else:
                        print(f"    → {problema['contexto']}...")
                else:
                    print(f"  {problema}")
            
            total_problemas += len([p for p in problemas if isinstance(p, dict)])
            arquivos_com_problemas += 1
    
    print("\n" + "="*80)
    print(f"RESUMO:")
    print(f"  Arquivos analisados: {len(dart_files)}")
    print(f"  Arquivos com problemas: {arquivos_com_problemas}")
    print(f"  Total de problemas encontrados: {total_problemas}")
    print("="*80)

if __name__ == "__main__":
    main()