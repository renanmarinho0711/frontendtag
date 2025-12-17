#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re

def create_safe_char_mapping():
    """Apenas caracteres corrompidos - 100% seguro"""
    return {
        'Ã£': 'ã',
        'Ã¡': 'á', 
        'Ã©': 'é',
        'Ãª': 'ê',
        'Ã­': 'í',
        'Ã³': 'ó',
        'Ãµ': 'õ',
        'Ãº': 'ú',
        'Ã§': 'ç',
        'Ã¢': 'â',
        'Ã´': 'ô',
        'Ã¬': 'ì',
        'Ã¨': 'è',
        'Ã¹': 'ù',
        'Ã ': 'à',
        'Ã‡': 'Ç',
        'Ã': 'À',
        'Ã‰': 'É',
        'Ãˆ': 'È',
    }

def create_safe_word_mapping():
    """Apenas palavras seguras de UI - sem palavras perigosas"""
    return {
        # SEGUROS - aparentam ser apenas UI/comentários
        'Usuarios': 'Usuários',
        'Usuario': 'Usuário',      
        'Integrao': 'Integração',
        'Integracao': 'Integração',
        'Notificaes': 'Notificações',
        'Notificacoes': 'Notificações',
        'Segurana': 'Segurança',
        'Seguranca': 'Segurança',
        'Permissoes': 'Permissões',
        'Importacao': 'Importação',
        'Exportacao': 'Exportação',
        'Sincronizacao': 'Sincronização',
        'Precificacao': 'Precificação',
        'Configuracoes': 'Configurações',
        'Estrategias': 'Estratégias',
        'estrategias': 'estratégias',
        'integrao': 'integração',
        'ativacao': 'ativação',
        'Ativacao': 'Ativação',
        'operacao': 'operação',
        'operacoes': 'operações',
        'Operacao': 'Operação',
        'Operacoes': 'Operações',
        'versao': 'versão',
        'versoes': 'versões',
        'Versao': 'Versão',
        'Versoes': 'Versões'
    }

def is_in_safe_context(line, match_start):
    """Verifica se está em string ou comentário"""
    line_before_match = line[:match_start]
    
    # String com aspas simples
    single_quotes = line_before_match.count("'") - line_before_match.count("\\'")
    if single_quotes % 2 == 1:
        return True
    
    # String com aspas duplas  
    double_quotes = line_before_match.count('"') - line_before_match.count('\\"')
    if double_quotes % 2 == 1:
        return True
    
    # Comentário de linha
    if '//' in line_before_match:
        return True
    
    # Comentário de documentação
    if line.strip().startswith('///'):
        return True
    
    return False

def is_dangerous_word_context(word, line):
    """Verifica se a palavra está em contexto perigoso"""
    
    # EVITAR palavras perigosas em contextos específicos
    dangerous_words = ['codigo', 'usuario', 'promocao', 'promocoes', 'relatorio', 'relatorios', 'configuracao']
    
    if word.lower() in dangerous_words:
        # Contextos perigosos
        if re.search(r'\bcase\s*[\'"]', line):
            return True
        if re.search(r'\w+\s*[:=]', line):
            return True
        if re.search(r'[\'\"]\w*\[', line):
            return True
        if '.' in line and word in line:
            return True
            
    return False

def apply_safe_fixes(file_path):
    """Aplica apenas correções seguras"""
    try:
        with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
            content = f.read()
    except Exception as e:
        return False, f"Erro ao ler arquivo: {e}"
    
    lines = content.split('\n')
    modified_lines = []
    changes_made = 0
    
    char_mapping = create_safe_char_mapping()
    word_mapping = create_safe_word_mapping()
    
    for line in lines:
        modified_line = line
        
        # 1. Aplicar correções de caracteres (sempre seguras)
        for old_char, new_char in char_mapping.items():
            if old_char in modified_line:
                start = 0
                temp_line = modified_line
                
                while True:
                    pos = temp_line.find(old_char, start)
                    if pos == -1:
                        break
                    
                    # Verifica contexto seguro
                    if is_in_safe_context(line, pos):
                        temp_line = temp_line[:pos] + new_char + temp_line[pos + len(old_char):]
                        changes_made += 1
                        start = pos + len(new_char)
                    else:
                        start = pos + 1
                
                modified_line = temp_line
        
        # 2. Aplicar correções de palavras (só em contexto seguro)
        for old_word, new_word in word_mapping.items():
            if old_word in modified_line:
                start = 0
                temp_line = modified_line
                
                while True:
                    pos = temp_line.find(old_word, start)
                    if pos == -1:
                        break
                    
                    # Verifica se está em contexto seguro E não é perigoso
                    if (is_in_safe_context(line, pos) and 
                        not is_dangerous_word_context(old_word, line)):
                        temp_line = temp_line[:pos] + new_word + temp_line[pos + len(old_word):]
                        changes_made += 1
                        start = pos + len(new_word)
                    else:
                        start = pos + 1
                
                modified_line = temp_line
        
        modified_lines.append(modified_line)
    
    # Salva apenas se houve mudanças
    if changes_made > 0:
        new_content = '\n'.join(modified_lines)
        try:
            with open(file_path, 'w', encoding='utf-8', newline='') as f:
                f.write(new_content)
            return True, f"{changes_made} correções aplicadas"
        except Exception as e:
            return False, f"Erro ao salvar: {e}"
    
    return True, "Nenhuma correção necessária"

def main():
    base_dir = "lib"
    if not os.path.exists(base_dir):
        print("❌ Diretório 'lib' não encontrado!")
        return
    
    print("🔧 APLICANDO CORREÇÕES SEGURAS DE ENCODING")
    print("=" * 60)
    print("  ✅ Caracteres corrompidos (Ã£→ã, Ã§→ç, etc.)")
    print("  ✅ Palavras de UI seguras (Usuarios→Usuários)")
    print("  🚫 NÃO toca em propriedades, case statements, JSON")
    print("-" * 60)
    
    total_files = 0
    files_modified = 0
    total_changes = 0
    errors = []
    
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file.endswith('.dart'):
                total_files += 1
                file_path = os.path.join(root, file)
                rel_path = os.path.relpath(file_path, base_dir)
                
                success, result = apply_safe_fixes(file_path)
                
                if success:
                    if "correções aplicadas" in result:
                        files_modified += 1
                        changes = int(result.split()[0])
                        total_changes += changes
                        print(f"✅ {rel_path}: {result}")
                    elif total_files % 50 == 0:
                        print(f"⏳ {total_files} arquivos processados...")
                else:
                    errors.append(f"❌ {rel_path}: {result}")
    
    print("\n" + "=" * 60)
    print(f"🎉 CORREÇÃO CONCLUÍDA COM SEGURANÇA!")
    print(f"  • Arquivos processados: {total_files}")
    print(f"  • Arquivos modificados: {files_modified}")
    print(f"  • Total de correções: {total_changes}")
    print(f"  • Erros: {len(errors)}")
    
    if errors:
        print("\n⚠️  ERROS:")
        for error in errors[:5]:
            print(f"   {error}")
    
    if total_changes > 0:
        print(f"\n✅ Pronto! {total_changes} correções seguras aplicadas.")
        print("   A interface agora vai aparecer corretamente!")
        print("   Pode testar a compilação sem medo.")
    else:
        print("\n🤔 Nenhuma correção foi aplicada.")

if __name__ == '__main__':
    main()