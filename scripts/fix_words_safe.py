# -*- coding: utf-8 -*-
"""
Script seguro para corrigir palavras com encoding corrompido
Substitui APENAS palavras que estão dentro de:
- Aspas simples: 'texto'
- Aspas duplas: "texto"
- Comentários //
- Comentários /* */
- Comentários ///

NÃO altera nomes de variáveis, classes, métodos ou identificadores de código.
"""

import os
import re
from pathlib import Path

SEARCH_PATH = r"D:\tagbean\frontend\lib"

# Dicionário de palavras corrompidas -> palavras corretas
PALAVRAS = {
    # ============================================
    # PALAVRAS COM ACENTOS REMOVIDOS (tipo 2)
    # ============================================
    
    # Palavras básicas
    'Usuarios': 'Usuários',
    'usuarios': 'usuários',
    'Usurio': 'Usuário',
    'usurio': 'usuário',
    'Configuraes': 'Configurações',
    'configuraes': 'configurações',
    'Configurao': 'Configuração',
    'configurao': 'configuração',
    'Importao': 'Importação',
    'importao': 'importação',
    'Importaes': 'Importações',
    'importaes': 'importações',
    'Exportao': 'Exportação',
    'exportao': 'exportação',
    'Exportaes': 'Exportações',
    'exportaes': 'exportações',
    'Sincronizao': 'Sincronização',
    'sincronizao': 'sincronização',
    'Operao': 'Operação',
    'operao': 'operação',
    'Operaes': 'Operações',
    'operaes': 'operações',
    'Aes': 'Ações',
    'aes': 'ações',
    'Ao': 'Ação',
    'Informao': 'Informação',
    'informao': 'informação',
    'Informaes': 'Informações',
    'informaes': 'informações',
    'Histrico': 'Histórico',
    'histrico': 'histórico',
    'Histria': 'História',
    'histria': 'história',
    'Mdulo': 'Módulo',
    'mdulo': 'módulo',
    'Mdulos': 'Módulos',
    'mdulos': 'módulos',
    'ltima': 'Última',
    'ltimo': 'Último',
    'Rpidas': 'Rápidas',
    'rpidas': 'rápidas',
    'Rpido': 'Rápido',
    'rpido': 'rápido',
    'Preo': 'Preço',
    'preo': 'preço',
    'Preos': 'Preços',
    'preos': 'preços',
    'Descrio': 'Descrição',
    'descrio': 'descrição',
    'Codigo': 'Código',
    'codigo': 'código',
    'Codigos': 'Códigos',
    'codigos': 'códigos',
    'Numero': 'Número',
    'numero': 'número',
    'Numeros': 'Números',
    'numeros': 'números',
    
    # ============================================
    # CARACTERES CORROMPIDOS (tipo 1)
    # ============================================
    
    # ã -> Ã£
    'ConstruÃ§Ã£o': 'Construção',
    'construÃ§Ã£o': 'construção',
    'NotificaÃ§Ã£o': 'Notificação',
    'notificaÃ§Ã£o': 'notificação',
    'InformaÃ§Ã£o': 'Informação',
    'informaÃ§Ã£o': 'informação',
    'ConfiguraÃ§Ã£o': 'Configuração',
    'configuraÃ§Ã£o': 'configuração',
    'AplicaÃ§Ã£o': 'Aplicação',
    'aplicaÃ§Ã£o': 'aplicação',
    'LocalizaÃ§Ã£o': 'Localização',
    'localizaÃ§Ã£o': 'localização',
    'TransaÃ§Ã£o': 'Transação',
    'transaÃ§Ã£o': 'transação',
    'PromoÃ§Ã£o': 'Promoção',
    'promoÃ§Ã£o': 'promoção',
    'PromoÃ§Ãµes': 'Promoções',
    'promoÃ§Ãµes': 'promoções',
    'Ã³': 'ó',
    'Ã¡': 'á',
    'Ã©': 'é',
    'Ã­': 'í',
    'Ãº': 'ú',
    'Ã£': 'ã',
    'Ã§': 'ç',
    'Ãµ': 'õ',
    'Ã¢': 'â',
    'Ãª': 'ê',
    'Ã´': 'ô',
}

def fix_content_safe(content):
    """
    Corrige o conteúdo de forma segura, alterando apenas:
    - Texto dentro de aspas simples: 'texto'
    - Texto dentro de aspas duplas: "texto"  
    - Comentários de linha: // comentário
    - Comentários de bloco: /* comentário */
    - Comentários de documentação: /// comentário
    """
    original_content = content
    total_corrections = 0
    
    for palavra_errada, palavra_correta in PALAVRAS.items():
        if palavra_errada not in content:
            continue
            
        # ============================================
        # 1. STRINGS COM ASPAS SIMPLES: 'texto'
        # ============================================
        def replace_in_single_quotes(match):
            string_content = match.group(1)  # conteúdo entre as aspas
            if palavra_errada in string_content:
                # Substitui apenas palavras inteiras
                new_content = re.sub(r'\b' + re.escape(palavra_errada) + r'\b', 
                                   palavra_correta, string_content)
                return f"'{new_content}'"
            return match.group(0)
        
        content = re.sub(r"'([^']*)'", replace_in_single_quotes, content)
        
        # ============================================
        # 2. STRINGS COM ASPAS DUPLAS: "texto"
        # ============================================
        def replace_in_double_quotes(match):
            string_content = match.group(1)  # conteúdo entre as aspas
            if palavra_errada in string_content:
                # Substitui apenas palavras inteiras
                new_content = re.sub(r'\b' + re.escape(palavra_errada) + r'\b', 
                                   palavra_correta, string_content)
                return f'"{new_content}"'
            return match.group(0)
        
        content = re.sub(r'"([^"]*)"', replace_in_double_quotes, content)
        
        # ============================================
        # 3. COMENTÁRIOS DE LINHA: // comentário
        # ============================================
        def replace_in_line_comment(match):
            comment_content = match.group(1)  # conteúdo do comentário
            if palavra_errada in comment_content:
                new_content = re.sub(r'\b' + re.escape(palavra_errada) + r'\b', 
                                   palavra_correta, comment_content)
                return f'//{new_content}'
            return match.group(0)
        
        content = re.sub(r'//(.*)$', replace_in_line_comment, content, flags=re.MULTILINE)
        
        # ============================================
        # 4. COMENTÁRIOS DE DOCUMENTAÇÃO: /// comentário
        # ============================================
        def replace_in_doc_comment(match):
            comment_content = match.group(1)  # conteúdo do comentário
            if palavra_errada in comment_content:
                new_content = re.sub(r'\b' + re.escape(palavra_errada) + r'\b', 
                                   palavra_correta, comment_content)
                return f'///{new_content}'
            return match.group(0)
        
        content = re.sub(r'///(.*)$', replace_in_doc_comment, content, flags=re.MULTILINE)
        
        # ============================================
        # 5. COMENTÁRIOS DE BLOCO: /* comentário */
        # ============================================
        def replace_in_block_comment(match):
            comment_content = match.group(1)  # conteúdo do comentário
            if palavra_errada in comment_content:
                new_content = re.sub(r'\b' + re.escape(palavra_errada) + r'\b', 
                                   palavra_correta, comment_content)
                return f'/*{new_content}*/'
            return match.group(0)
        
        content = re.sub(r'/\*(.*?)\*/', replace_in_block_comment, content, flags=re.DOTALL)
    
    # Contar correções feitas
    corrections_made = len(original_content) - len(content) if original_content != content else 0
    if original_content != content:
        corrections_made = sum(1 for old, new in PALAVRAS.items() if old in original_content and new in content)
    
    return content, corrections_made

def fix_files():
    print("="*60)
    print("  CORRETOR SEGURO DE PALAVRAS COM ENCODING CORROMPIDO")
    print("  (Apenas strings e comentários)")
    print("="*60)
    print()
    
    print("[INFO] Iniciando busca de arquivos...")
    path = Path(SEARCH_PATH)
    dart_files = list(path.rglob("*.dart"))
    
    print(f"[INFO] Encontrados {len(dart_files)} arquivos .dart")
    print(f"[INFO] Total de palavras no dicionário: {len(PALAVRAS)}")
    print()
    
    total_correcoes = 0
    arquivos_modificados = 0
    
    for i, file_path in enumerate(dart_files, 1):
        relative = str(file_path).replace(SEARCH_PATH, "").lstrip("\\")
        
        # Log de progresso a cada 50 arquivos
        if i % 50 == 0:
            print(f"[PROGRESSO] {i}/{len(dart_files)} arquivos processados...")
        
        try:
            # Tentar ler com diferentes encodings
            content = None
            for enc in ['utf-8', 'utf-8-sig', 'latin-1', 'cp1252']:
                try:
                    with open(file_path, 'r', encoding=enc) as f:
                        content = f.read()
                    break
                except:
                    continue
            
            if content is None:
                print(f"[AVISO] Não foi possível ler: {relative}")
                continue
            
            original = content
            
            # Aplicar correções seguras
            content, correcoes_arquivo = fix_content_safe(content)
            
            if content != original:
                print(f"[INFO] Salvando {relative} com {correcoes_arquivo} correções...")
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                
                total_correcoes += correcoes_arquivo
                arquivos_modificados += 1
                
        except Exception as e:
            print(f"  [ERRO] {file_path}: {e}")
    
    print()
    print("="*60)
    print(f"  CONCLUÍDO!")
    print(f"  Arquivos modificados: {arquivos_modificados}")
    print(f"  Total de correções: {total_correcoes}")
    print("="*60)

if __name__ == "__main__":
    fix_files()