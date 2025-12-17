#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re

def analyze_key_files():
    """Analisa apenas alguns arquivos chave para entender os padrões reais"""
    
    key_files = [
        'lib/design_system/theme/module_theme.dart',
        'lib/features/pricing/data/models/pricing_models.dart',
        'lib/features/products/data/models/product_model.dart',
        'lib/modules/dashboard/presentation/screens/dashboard_screen.dart'
    ]
    
    print("🔍 ANÁLISE FOCADA DOS PROBLEMAS REAIS")
    print("=" * 60)
    
    for file_path in key_files:
        if not os.path.exists(file_path):
            print(f"❌ Arquivo não encontrado: {file_path}")
            continue
            
        print(f"\n📁 ANALISANDO: {file_path}")
        print("-" * 40)
        
        try:
            with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
                lines = f.readlines()
        except Exception as e:
            print(f"❌ Erro: {e}")
            continue
        
        # Procura por problemas específicos
        for line_num, line in enumerate(lines, 1):
            line_clean = line.strip()
            
            # 1. Caracteres corrompidos (sempre seguros de corrigir)
            corrupted_chars = ['Ã£', 'Ã§', 'Ã©', 'Ã­', 'Ã³', 'Ãµ', 'Ãº', 'Ã¡', 'Ã¢', 'Ã´']
            for char in corrupted_chars:
                if char in line_clean:
                    print(f"  ✅ LINHA {line_num}: Carácter corrompido '{char}' em:")
                    print(f"      {line_clean}")
                    break
            
            # 2. Palavras problemáticas em contexto perigoso
            dangerous_patterns = [
                ('usuario', r'\busuario\s*[:=]'),
                ('codigo', r'\bcodigo\s*[:=]'),
                ('promocao', r'\.promocao\b'),
                ('relatorio', r"case\s*['\"]relatorio"),
            ]
            
            for word, pattern in dangerous_patterns:
                if re.search(pattern, line_clean, re.IGNORECASE):
                    print(f"  🚨 LINHA {line_num}: PERIGOSO - '{word}' em código:")
                    print(f"      {line_clean}")
            
            # 3. Palavras que aparecem ser seguras (em strings de UI)
            safe_ui_patterns = [
                ('Usuarios', r"['\"].*Usuarios.*['\"]"),
                ('Estrategias', r"['\"].*Estrategias.*['\"]"),
                ('Configuracoes', r"['\"].*Configuracoes.*['\"]"),
            ]
            
            for word, pattern in safe_ui_patterns:
                if re.search(pattern, line_clean, re.IGNORECASE):
                    print(f"  ✅ LINHA {line_num}: SEGURO - '{word}' em UI:")
                    print(f"      {line_clean}")

def main():
    os.chdir('D:/tagbean/frontend')
    analyze_key_files()
    
    print("\n" + "=" * 60)
    print("💡 RECOMENDAÇÕES FINAIS:")
    print("  ✅ SEGUROS para aplicar:")
    print("     - Correções de caracteres corrompidos (Ã£→ã, Ã§→ç, etc.)")
    print("     - Palavras em strings de UI (títulos, mensagens)")
    print("  🚨 PERIGOSOS - corrigir manualmente:")
    print("     - Palavras em 'case' statements")
    print("     - Propriedades de objetos (usuario:, codigo:)")
    print("     - Referências em JSON")

if __name__ == '__main__':
    main()