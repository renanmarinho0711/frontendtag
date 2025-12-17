# -*- coding: utf-8 -*-
"""
Script aprimorado para LISTAR problemas de encoding sem fazer alterações
Identifica problemas apenas em:
- Strings literais entre aspas
- Comentários
- Texto visível ao usuário

NÃO reporta problemas em identificadores de código (variáveis, classes, métodos).
"""

import os
import re
from pathlib import Path

SEARCH_PATH = r"D:\tagbean\frontend\lib"

# Dicionário de palavras corrompidas para detectar
PALAVRAS_CORROMPIDAS = {
    # Tipo 1: Caracteres corrompidos
    'Ã¡': 'á', 'Ã©': 'é', 'Ã­': 'í', 'Ã³': 'ó', 'Ãº': 'ú',
    'Ã£': 'ã', 'Ã§': 'ç', 'Ãµ': 'õ', 'Ã¢': 'â', 'Ãª': 'ê', 'Ã´': 'ô',
    'ConstruÃ§Ã£o': 'Construção', 'NotificaÃ§Ã£o': 'Notificação',
    'InformaÃ§Ã£o': 'Informação', 'ConfiguraÃ§Ã£o': 'Configuração',
    'AplicaÃ§Ã£o': 'Aplicação', 'LocalizaÃ§Ã£o': 'Localização',
    'TransaÃ§Ã£o': 'Transação', 'PromoÃ§Ã£o': 'Promoção',
    'PromoÃ§Ãµes': 'Promoções',
    
    # Tipo 2: Acentos removidos
    'Usuarios': 'Usuários', 'usuarios': 'usuários',
    'Configuraes': 'Configurações', 'configuraes': 'configurações',
    'Configurao': 'Configuração', 'configurao': 'configuração',
    'Importao': 'Importação', 'importao': 'importação',
    'Exportao': 'Exportação', 'exportao': 'exportação',
    'Aes': 'Ações', 'aes': 'ações', 'Ao': 'Ação',
    'Histrico': 'Histórico', 'histrico': 'histórico',
    'Mdulo': 'Módulo', 'mdulo': 'módulo', 'Mdulos': 'Módulos',
    'Preo': 'Preço', 'preo': 'preço', 'Preos': 'Preços', 'preos': 'preços',
    'Descrio': 'Descrição', 'descrio': 'descrição',
    'Codigo': 'Código', 'codigo': 'código', 'Codigos': 'Códigos', 'codigos': 'códigos',
    'Numero': 'Número', 'numero': 'número'
}

def scan_content_safe(content, file_path):
    """
    Escaneia conteúdo em busca de problemas apenas em:
    - Strings entre aspas
    - Comentários
    Ignora identificadores de código.
    """
    problemas = []
    linhas = content.split('\n')
    
    for i, linha in enumerate(linhas, 1):
        # ============================================
        # 1. PROBLEMAS EM STRINGS COM ASPAS SIMPLES
        # ============================================
        for match in re.finditer(r"'([^']*)'", linha):
            string_content = match.group(1)
            start_pos = match.start()
            
            for palavra_errada, palavra_correta in PALAVRAS_CORROMPIDAS.items():
                if re.search(r'\b' + re.escape(palavra_errada) + r'\b', string_content):
                    problemas.append({
                        'linha': i,
                        'coluna': start_pos,
                        'tipo': 'string-aspas-simples',
                        'problema': palavra_errada,
                        'correcao': palavra_correta,
                        'contexto': linha.strip()[:80] + ('...' if len(linha.strip()) > 80 else ''),
                        'string_completa': match.group(0)
                    })
        
        # ============================================
        # 2. PROBLEMAS EM STRINGS COM ASPAS DUPLAS
        # ============================================
        for match in re.finditer(r'"([^"]*)"', linha):
            string_content = match.group(1)
            start_pos = match.start()
            
            for palavra_errada, palavra_correta in PALAVRAS_CORROMPIDAS.items():
                if re.search(r'\b' + re.escape(palavra_errada) + r'\b', string_content):
                    problemas.append({
                        'linha': i,
                        'coluna': start_pos,
                        'tipo': 'string-aspas-duplas',
                        'problema': palavra_errada,
                        'correcao': palavra_correta,
                        'contexto': linha.strip()[:80] + ('...' if len(linha.strip()) > 80 else ''),
                        'string_completa': match.group(0)
                    })
        
        # ============================================
        # 3. PROBLEMAS EM COMENTÁRIOS DE LINHA //
        # ============================================
        for match in re.finditer(r'//(.*)$', linha):
            comment_content = match.group(1)
            start_pos = match.start()
            
            for palavra_errada, palavra_correta in PALAVRAS_CORROMPIDAS.items():
                if re.search(r'\b' + re.escape(palavra_errada) + r'\b', comment_content):
                    problemas.append({
                        'linha': i,
                        'coluna': start_pos,
                        'tipo': 'comentario-linha',
                        'problema': palavra_errada,
                        'correcao': palavra_correta,
                        'contexto': linha.strip()[:80] + ('...' if len(linha.strip()) > 80 else ''),
                        'string_completa': match.group(0)
                    })
        
        # ============================================
        # 4. PROBLEMAS EM COMENTÁRIOS DE DOCUMENTAÇÃO ///
        # ============================================
        for match in re.finditer(r'///(.*)$', linha):
            comment_content = match.group(1)
            start_pos = match.start()
            
            for palavra_errada, palavra_correta in PALAVRAS_CORROMPIDAS.items():
                if re.search(r'\b' + re.escape(palavra_errada) + r'\b', comment_content):
                    problemas.append({
                        'linha': i,
                        'coluna': start_pos,
                        'tipo': 'comentario-doc',
                        'problema': palavra_errada,
                        'correcao': palavra_correta,
                        'contexto': linha.strip()[:80] + ('...' if len(linha.strip()) > 80 else ''),
                        'string_completa': match.group(0)
                    })
    
    # ============================================
    # 5. PROBLEMAS EM COMENTÁRIOS DE BLOCO /* */
    # ============================================
    for match in re.finditer(r'/\*(.*?)\*/', content, re.DOTALL):
        comment_content = match.group(1)
        
        for palavra_errada, palavra_correta in PALAVRAS_CORROMPIDAS.items():
            if re.search(r'\b' + re.escape(palavra_errada) + r'\b', comment_content):
                # Calcular linha do problema
                texto_antes = content[:match.start()]
                linha_numero = texto_antes.count('\n') + 1
                
                problemas.append({
                    'linha': linha_numero,
                    'coluna': match.start(),
                    'tipo': 'comentario-bloco',
                    'problema': palavra_errada,
                    'correcao': palavra_correta,
                    'contexto': comment_content.replace('\n', ' ')[:80] + ('...' if len(comment_content) > 80 else ''),
                    'string_completa': match.group(0)[:100] + ('...' if len(match.group(0)) > 100 else '')
                })
    
    return problemas

def scan_file_safe(file_path):
    """Escaneia um arquivo de forma segura em busca de problemas de encoding"""
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
            return [{'erro': 'Não foi possível ler o arquivo'}], 'erro'
        
        problemas = scan_content_safe(content, file_path)
        return problemas, encoding_usado
    
    except Exception as e:
        return [{'erro': str(e)}], 'erro'

def main():
    print("="*80)
    print("    RELATÓRIO SEGURO DE PROBLEMAS DE ENCODING - SOMENTE STRINGS E COMENTÁRIOS")
    print("="*80)
    print()
    
    path = Path(SEARCH_PATH)
    dart_files = list(path.rglob("*.dart"))
    
    print(f"Analisando {len(dart_files)} arquivos .dart...")
    print()
    
    total_problemas = 0
    arquivos_com_problemas = 0
    
    estatisticas = {
        'string-aspas-simples': 0,
        'string-aspas-duplas': 0, 
        'comentario-linha': 0,
        'comentario-doc': 0,
        'comentario-bloco': 0,
        'erro': 0
    }
    
    for file_path in dart_files:
        relative = str(file_path).replace(SEARCH_PATH, "").lstrip("\\")
        problemas, encoding = scan_file_safe(file_path)
        
        if problemas and not any('erro' in p for p in problemas):
            print(f"\n📁 {relative}")
            print("-" * min(len(relative), 60))
            
            for problema in problemas:
                if 'erro' in problema:
                    print(f"  ❌ ERRO: {problema['erro']}")
                    estatisticas['erro'] += 1
                else:
                    emoji = {
                        'string-aspas-simples': '📝',
                        'string-aspas-duplas': '📝',
                        'comentario-linha': '💬',
                        'comentario-doc': '📚',
                        'comentario-bloco': '📝'
                    }.get(problema['tipo'], '❓')
                    
                    print(f"  {emoji} Linha {problema['linha']}: {problema['problema']} → {problema['correcao']}")
                    print(f"      Tipo: {problema['tipo']}")
                    print(f"      Contexto: {problema['contexto']}")
                    
                    estatisticas[problema['tipo']] += 1
            
            total_problemas += len([p for p in problemas if 'erro' not in p])
            arquivos_com_problemas += 1
        elif any('erro' in p for p in problemas):
            print(f"\n❌ {relative}: Erro ao processar")
    
    print("\n" + "="*80)
    print(f"RESUMO DETALHADO:")
    print(f"  Arquivos analisados: {len(dart_files)}")
    print(f"  Arquivos com problemas: {arquivos_com_problemas}")
    print(f"  Total de problemas encontrados: {total_problemas}")
    print()
    print("ESTATÍSTICAS POR TIPO:")
    for tipo, count in estatisticas.items():
        if count > 0:
            emoji = {
                'string-aspas-simples': '📝',
                'string-aspas-duplas': '📝', 
                'comentario-linha': '💬',
                'comentario-doc': '📚',
                'comentario-bloco': '📝',
                'erro': '❌'
            }.get(tipo, '❓')
            tipo_nome = {
                'string-aspas-simples': 'Strings com aspas simples',
                'string-aspas-duplas': 'Strings com aspas duplas',
                'comentario-linha': 'Comentários de linha (//)',
                'comentario-doc': 'Comentários de documentação (///)',
                'comentario-bloco': 'Comentários de bloco (/* */)',
                'erro': 'Erros de leitura'
            }.get(tipo, tipo)
            print(f"  {emoji} {tipo_nome}: {count}")
    print("="*80)

if __name__ == "__main__":
    main()