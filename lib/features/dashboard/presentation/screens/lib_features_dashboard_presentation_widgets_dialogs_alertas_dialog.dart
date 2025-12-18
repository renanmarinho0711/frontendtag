import 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';

class AlertasDialog extends StatelessWidget {
  final List<Map<String, dynamic>> alertas;
  final void Function(Map<String, dynamic>) onVerDetalhes;

  const AlertasDialog({
    super.key,
    required this.alertas,
    required this.onVerDetalhes,
  });

  static Future<void> show(
    BuildContext context, {
    required List<Map<String, dynamic>> alertas,
    required void Function(Map<String, dynamic>) onVerDetalhes,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertasDialog(
        alertas: alertas,
        onVerDetalhes: onVerDetalhes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
      ),
      child: Container(
        width: isMobile ? double.infinity : (isTablet ? 400 : 450),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * (isMobile ? 0.85 : 0.8),
        ),
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsivePadding(context, mobile:  12, tablet: 22, desktop: 26),
        ),
        child: Column(
          mainAxisSize:  MainAxisSize.min,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child:  Column(
                  children: alertas.map((a) => _AlertaItem(
                    alerta: a,
                    onVerDetalhes: () => onVerDetalhes(a),
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:  [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).redMain,
                borderRadius: BorderRadius.circular(8),
              ),
              child:  Icon(Icons.warning_rounded, color: ThemeColors.of(context).surface),
            ),
            const SizedBox(width: 12),
            const Text('Alertas Pendentes', style: TextStyle(fontWeight:  FontWeight.bold, fontSize: 16)),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _AlertaItem extends StatelessWidget {
  final Map<String, dynamic> alerta;
  final VoidCallback onVerDetalhes;

  const _AlertaItem({required this.alerta, required this.onVerDetalhes});

  @override
  Widget build(BuildContext context) {
    // ...  implementação do item de alerta
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (alerta['cor'] as Color).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: (alerta['cor'] as Color).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(alerta['icone'] as IconData, color: alerta['cor'] as Color),
              const SizedBox(width: 8),
              Expanded(child: Text(alerta['tipo'] as String, style: const TextStyle(fontWeight: FontWeight. bold))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical:  4),
                decoration: BoxDecoration(
                  color:  alerta['cor'] as Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:  Text('${alerta['qtd']}', style: TextStyle(color: ThemeColors.of(context).surface)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(alerta['descricao'] as String),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onVerDetalhes,
              style: ElevatedButton.styleFrom(backgroundColor: alerta['cor'] as Color),
              child: const Text('Ver Detalhes'),
            ),
          ),
        ],
      ),
    );
  }
}