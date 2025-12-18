import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/settings/presentation/providers/backup_provider.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tagbean/core/utils/web_utils.dart';

class ConfiguracoesBackupScreen extends ConsumerStatefulWidget {
  const ConfiguracoesBackupScreen({super.key});

  @override
  ConsumerState<ConfiguracoesBackupScreen> createState() => _ConfiguracoesBackupScreenState();
}

class _ConfiguracoesBackupScreenState extends ConsumerState<ConfiguracoesBackupScreen> {
  bool _includeProducts = true;
  bool _includeCategories = true;
  bool _includeTags = true;
  bool _includeSettings = true;
  bool _includeStrategies = true;
  final bool _isImporting = false;

  @override
  void initState() {
    super.initState();
    _loadBackups();
  }

  Future<void> _loadBackups() async {
    await ref.read(backupNotifierProvider.notifier).loadBackups();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final backupState = ref.watch(backupNotifierProvider);

    // Mostrar mensagens de erro/sucesso
    ref.listen<BackupState>(backupNotifierProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: ThemeColors.of(context).error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(backupNotifierProvider.notifier).clearMessages();
      }
      if (next.successMessage != null && next.successMessage != previous?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface),
                const SizedBox(width: 12),
                Expanded(child: Text(next.successMessage!)),
              ],
            ),
            backgroundColor: ThemeColors.of(context).greenMain,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(backupNotifierProvider.notifier).clearMessages();
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).backgroundLight,
      ),
      child: Scaffold(
        backgroundColor: ThemeColors.of(context).transparent,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildModernAppBar(backupState),
              Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(backupState),
                    const SizedBox(height: 24),
                    _buildBackupSection(isMobile, backupState),
                    const SizedBox(height: 24),
                    _buildRestoreSection(isMobile),
                    const SizedBox(height: 24),
                    _buildAutoBackupSection(isMobile, backupState),
                    const SizedBox(height: 24),
                    _buildHistorySection(isMobile, backupState),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar(BackupState backupState) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(
        isMobile ? 16 : 24,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 12 : 16,
      ),
      decoration: BoxDecoration(
        gradient: AppGradients.darkBackground(context),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : 20,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.4),
            blurRadius: isMobile ? 15 : 20,
            offset: Offset(0, isMobile ? 6 : 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Boto de voltar
          Material(
            color: ThemeColors.of(context).transparent,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
              child: Container(
                padding: EdgeInsets.all(
                  isMobile ? 8 : 12,
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay15,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: ThemeColors.of(context).surface,
                  size: isMobile ? 20 : 24,
                ),
              ),
            ),
          ),
          SizedBox(width: isMobile ? 8 : 12),
          Container(
            padding: EdgeInsets.all(
              isMobile ? 8 : 12,
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay20,
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.backup_rounded,
              color: ThemeColors.of(context).surface,
              size: isMobile ? 20 : 24,
            ),
          ),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Backup e Restaurao',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Gerencie seus backups de dados',
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).surfaceOverlay70,
                  ),
                ),
              ],
            ),
          ),
          if (backupState.isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ThemeColors.of(context).surface,
              ),
            )
          else
            IconButton(
              icon: Icon(
                Icons.refresh_rounded,
                color: ThemeColors.of(context).surface,
              ),
              onPressed: _loadBackups,
              tooltip: 'Atualizar',
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BackupState state) {
    final lastBackup = state.lastBackup;
    final lastBackupText = lastBackup != null
        ? 'Último backup: ${DateFormat('dd/MM/yyyy HH:mm').format(lastBackup.createdAt)}'
        : 'Nenhum backup realizado';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeColors.of(context).blueMain,
            ThemeColors.of(context).blueMain.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay20,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.backup_rounded,
              color: ThemeColors.of(context).surface,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Backup de Dados',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lastBackupText,
                  style: TextStyle(
                    fontSize: 13,
                    color: ThemeColors.of(context).white70,
                  ),
                ),
                if (state.totalBackups > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${state.totalBackups} backup(s)  ${state.totalSizeFormatted}',
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeColors.of(context).white60,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupSection(bool isMobile, BackupState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).greenMain.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.cloud_upload_rounded,
                  color: ThemeColors.of(context).greenMain,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Criar Backup',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Exporte todos os dados da sua loja para um arquivo seguro.',
            style: TextStyle(
              fontSize: 13,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          _buildDataCheckboxes(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: state.isCreating ? null : _createBackup,
              icon: state.isCreating
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ThemeColors.of(context).surface,
                      ),
                    )
                  : const Icon(Icons.download_rounded, size: 18),
              label: Text(state.isCreating ? 'Criando backup...' : 'Criar Backup'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.of(context).greenMain,
                foregroundColor: ThemeColors.of(context).surface,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCheckboxes() {
    return Column(
      children: [
        _buildCheckboxTile('Produtos', Icons.inventory_2_rounded, _includeProducts, (v) => setState(() => _includeProducts = v ?? true)),
        _buildCheckboxTile('Categorias', Icons.category_rounded, _includeCategories, (v) => setState(() => _includeCategories = v ?? true)),
        _buildCheckboxTile('Etiquetas', Icons.label_rounded, _includeTags, (v) => setState(() => _includeTags = v ?? true)),
        _buildCheckboxTile('Configurações', Icons.settings_rounded, _includeSettings, (v) => setState(() => _includeSettings = v ?? true)),
        _buildCheckboxTile('Estratgias', Icons.auto_awesome_rounded, _includeStrategies, (v) => setState(() => _includeStrategies = v ?? true)),
      ],
    );
  }

  Widget _buildCheckboxTile(String title, IconData icon, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: ThemeColors.of(context).textSecondary),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 13))),
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: ThemeColors.of(context).greenMain,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildRestoreSection(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).orangeMain.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.cloud_download_rounded,
                  color: ThemeColors.of(context).orangeMain,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Restaurar Backup',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Restaure dados de um backup anteriormente criado.',
            style: TextStyle(
              fontSize: 13,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).warningPastel,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_rounded, color: ThemeColors.of(context).orangeMain, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'A restaurao substituir os dados atuais. Faa um backup antes.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isImporting ? null : _selectBackupFile,
              icon: _isImporting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file_rounded, size: 18),
              label: Text(_isImporting ? 'Importando...' : 'Selecionar Arquivo'),
              style: OutlinedButton.styleFrom(
                foregroundColor: ThemeColors.of(context).orangeMain,
                side: BorderSide(color: ThemeColors.of(context).orangeMain),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoBackupSection(bool isMobile, BackupState state) {
    final config = state.config;
    final frequencyLabel = _getFrequencyLabel(config.backupFrequency);
    final hourLabel = '${config.backupHour.toString().padLeft(2, '0')}:00';
    final retentionLabel = '${config.maxBackupsToKeep} backups';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.schedule_rounded,
                      color: ThemeColors.of(context).success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Backup Automtico',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Switch(
                value: config.autoBackupEnabled,
                onChanged: (value) {
                  ref.read(backupNotifierProvider.notifier).updateConfig(
                    autoBackupEnabled: value,
                  );
                },
                activeThumbColor: ThemeColors.of(context).success,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAutoBackupOption('Frequncia', frequencyLabel, Icons.calendar_today_rounded),
          _buildAutoBackupOption('Horrio', hourLabel, Icons.access_time_rounded),
          _buildAutoBackupOption('Reteno', retentionLabel, Icons.history_rounded),
        ],
      ),
    );
  }

  String _getFrequencyLabel(String frequency) {
    switch (frequency) {
      case 'daily':
        return 'Dirio';
      case 'weekly':
        return 'Semanal';
      case 'monthly':
        return 'Mensal';
      default:
        return frequency;
    }
  }

  Widget _buildAutoBackupOption(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: ThemeColors.of(context).textSecondary),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 13)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).backgroundLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(bool isMobile, BackupState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).blueMain.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      color: ThemeColors.of(context).blueMain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Histórico de Backups',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (state.backups.isNotEmpty)
                TextButton.icon(
                  onPressed: () async {
                    final deleted = await ref.read(backupNotifierProvider.notifier).cleanupOldBackups();
                    if (deleted > 0) {
                      // Mensagem exibida automaticamente pelo listener
                    }
                  },
                  icon: const Icon(Icons.cleaning_services_rounded, size: 16),
                  label: const Text('Limpar antigos'),
                  style: TextButton.styleFrom(
                    foregroundColor: ThemeColors.of(context).textSecondary,
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (state.backups.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_off_rounded,
                      size: 48,
                      color: ThemeColors.of(context).textSecondaryOverlay50,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nenhum backup encontrado',
                      style: TextStyle(
                        color: ThemeColors.of(context).textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...(state.backups.map((backup) => _buildBackupHistoryItem(backup, state))),
        ],
      ),
    );
  }

  Widget _buildBackupHistoryItem(BackupModel backup, BackupState state) {
    final dateFormatted = DateFormat('dd/MM/yyyy HH:mm').format(backup.createdAt);
    final isAutomatic = backup.type == 'automatic';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).backgroundLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            isAutomatic ? Icons.schedule_rounded : Icons.person_rounded,
            color: ThemeColors.of(context).textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  backup.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Text(
                  dateFormatted,
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            backup.sizeFormatted,
            style: TextStyle(
              fontSize: 12,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          // Boto de download
          IconButton(
            icon: const Icon(Icons.download_rounded, size: 18),
            onPressed: () {
              final url = ref.read(backupNotifierProvider.notifier).getDownloadUrl(backup.id);
              if (kIsWeb) {
                openUrl(url);
              }
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Baixar backup',
          ),
          // Boto de restaurar
          IconButton(
            icon: Icon(
              Icons.restore_rounded, 
              size: 18,
              color: state.isRestoring ? ThemeColors.of(context).textSecondary : ThemeColors.of(context).orangeMain,
            ),
            onPressed: state.isRestoring ? null : () => _confirmRestore(backup),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Restaurar backup',
          ),
          // Boto de excluir
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, size: 18, color: ThemeColors.of(context).error),
            onPressed: () => _confirmDelete(backup),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Excluir backup',
          ),
        ],
      ),
    );
  }

  Future<void> _confirmRestore(BackupModel backup) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurar Backup'),
        content: Text(
          'Deseja restaurar o backup "${backup.name}"?\n\n'
          'Isso ir adicionar os dados do backup ao sistema. '
          'Dados existentes no sero sobrescritos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).orangeMain,
            ),
            child: const Text('Restaurar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(backupNotifierProvider.notifier).restoreBackup(backup.id);
    }
  }

  Future<void> _confirmDelete(BackupModel backup) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Backup'),
        content: Text(
          'Deseja excluir o backup "${backup.name}"?\n\n'
          'Esta ao no pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).error,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(backupNotifierProvider.notifier).deleteBackup(backup.id);
    }
  }

  Future<void> _createBackup() async {
    // Usar o provider para criar backup no backend
    await ref.read(backupNotifierProvider.notifier).createBackup(
      includeImages: _includeProducts,
      includeLogs: _includeSettings,
    );
  }

  Future<void> _selectBackupFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', 'json'],
        withData: kIsWeb,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final fileName = file.name;
        
        // Confirmar restaurao
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            icon: Icon(Icons.restore, color: ThemeColors.of(context).orangeMain, size: 48),
            title: const Text('Restaurar Backup'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Arquivo selecionado: $fileName'),
                const SizedBox(height: 16),
                Text(
                  'Esta ao ir substituir os dados atuais pelos dados do backup. Esta ao no pode ser desfeita.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ThemeColors.of(context).textSecondary),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.of(context).orangeMain,
                ),
                child: const Text('Restaurar'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          // Notifica que estamos processando o backup
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 16),
                  Text('Processando backup...'),
                ],
              ),
              duration: Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Para web, usamos bytes diretamente
          if (kIsWeb && file.bytes != null) {
            // TODO: Enviar bytes para API de restore
            // await ref.read(backupNotifierProvider.notifier).restoreFromBytes(file.bytes!);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Upload de backup para restaurao em implementao'),
                backgroundColor: ThemeColors.of(context).orangeMain,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (file.path != null) {
            // Para desktop/mobile, usamos o caminho do arquivo
            // TODO: Enviar arquivo para API de restore
            // await ref.read(backupNotifierProvider.notifier).restoreFromFile(file.path!);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Restaurao de arquivo local em implementao'),
                backgroundColor: ThemeColors.of(context).orangeMain,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao selecionar arquivo: $e'),
          backgroundColor: ThemeColors.of(context).error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}








