import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/auth/presentation/providers/auth_provider.dart';

/// Card de Painel Administrativo
/// Mostra opções de gestão baseadas na role do usuário:
/// - PlatformAdmin: Gerenciar Clientes, Todas as Lojas, Todos os Usuários
/// - ClientAdmin: Gerenciar Lojas, Gerenciar Usuários
/// - StoreManager: Gerenciar Usuários da Loja
class AdminPanelCard extends ConsumerWidget {
  final VoidCallback onGerenciarClientes;
  final VoidCallback onGerenciarLojas;
  final VoidCallback onGerenciarUsuarios;
  final VoidCallback onVerConfiguracoes;

  const AdminPanelCard({
    super.key,
    required this.onGerenciarClientes,
    required this.onGerenciarLojas,
    required this.onGerenciarUsuarios,
    required this.onVerConfiguracoes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();
    
    final isPlatformAdmin = user.isPlatformAdmin;
    final isClientAdmin = user.isClientAdmin;
    final isStoreManager = user.isStoreManager;
    
    // Operador não vê este card
    if (!isPlatformAdmin && !isClientAdmin && !isStoreManager) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPlatformAdmin 
              ? [ThemeColors.of(context).moduleDashboard, ThemeColors.of(context).moduleDashboardDark]
              : isClientAdmin
                  ? [ThemeColors.of(context).adminPanelBackground1, ThemeColors.of(context).adminPanelBackground2]
                  : [ThemeColors.of(context).adminPanelBackground1, ThemeColors.of(context).adminPanelBackground2],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: (isPlatformAdmin ? ThemeColors.of(context).moduleDashboard : ThemeColors.of(context).blueCyan).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).surfaceOverlay20,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isPlatformAdmin 
                        ? Icons.admin_panel_settings_rounded
                        : Icons.manage_accounts_rounded,
                    color: ThemeColors.of(context).surface,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPlatformAdmin 
                            ? 'Painel Master TagBean'
                            : isClientAdmin 
                                ? 'Painel Administrativo'
                                : 'Gestão da Loja',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 18,
                            mobileFontSize: 16,
                            tabletFontSize: 17,
                          ),
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).surface,
                        ),
                      ),
                      Text(
                        isPlatformAdmin 
                            ? 'Controle total da plataforma'
                            : isClientAdmin 
                                ? 'Gerencie sua empresa'
                                : 'Gerencie sua equipe',
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeColors.of(context).surfaceOverlay80,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge de role
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).surfaceOverlay20,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isPlatformAdmin 
                        ? 'MASTER'
                        : isClientAdmin 
                            ? 'ADMIN'
                            : 'GERENTE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.of(context).surface,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
            
            // Ações administrativas
            if (isMobile)
              _buildMobileActions(context, isPlatformAdmin, isClientAdmin)
            else
              _buildDesktopActions(context, isPlatformAdmin, isClientAdmin, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileActions(BuildContext context, bool isPlatformAdmin, bool isClientAdmin) {
    return Column(
      children: [
        // Linha 1
        Row(
          children: [
            if (isPlatformAdmin)
              Expanded(
                child: _buildActionButton(
                  context: context,
                  icon: Icons.business_rounded,
                  label: 'Clientes',
                  onTap: onGerenciarClientes,
                ),
              ),
            if (isPlatformAdmin) const SizedBox(width: 10),
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: Icons.storefront_rounded,
                label: isPlatformAdmin ? 'Lojas' : 'Minhas Lojas',
                onTap: onGerenciarLojas,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Linha 2
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: Icons.people_rounded,
                label: 'Usuários',
                onTap: onGerenciarUsuarios,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: Icons.settings_rounded,
                label: 'Configurações',
                onTap: onVerConfiguracoes,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopActions(BuildContext context, bool isPlatformAdmin, bool isClientAdmin, bool isTablet) {
    final actions = <Widget>[];
    
    if (isPlatformAdmin) {
      actions.add(
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: Icons.business_rounded,
            label: 'Gerenciar Clientes',
            subtitle: 'Empresas cadastradas',
            onTap: onGerenciarClientes,
          ),
        ),
      );
      actions.add(const SizedBox(width: 12));
    }
    
    actions.add(
      Expanded(
        child: _buildActionButton(
          context: context,
          icon: Icons.storefront_rounded,
          label: isPlatformAdmin ? 'Todas as Lojas' : 'Gerenciar Lojas',
          subtitle: isPlatformAdmin ? 'Visão global' : 'Lojas da empresa',
          onTap: onGerenciarLojas,
        ),
      ),
    );
    actions.add(const SizedBox(width: 12));
    
    actions.add(
      Expanded(
        child: _buildActionButton(
          context: context,
          icon: Icons.people_rounded,
          label: 'Gerenciar Usuários',
          subtitle: 'Acessos e permissões',
          onTap: onGerenciarUsuarios,
        ),
      ),
    );
    actions.add(const SizedBox(width: 12));
    
    actions.add(
      Expanded(
        child: _buildActionButton(
          context: context,
          icon: Icons.settings_rounded,
          label: 'Configurações',
          subtitle: 'Sistema e integrações',
          onTap: onVerConfiguracoes,
        ),
      ),
    );

    return Row(children: actions);
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return Material(
      color: ThemeColors.of(context).transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 16,
            vertical: isMobile ? 12 : 14,
          ),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).surfaceOverlay15,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ThemeColors.of(context).surfaceOverlay20,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: ThemeColors.of(context).surface,
                size: isMobile ? 20 : 24,
              ),
              SizedBox(width: isMobile ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.of(context).surface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && !isMobile)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: ThemeColors.of(context).surfaceOverlay70,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: ThemeColors.of(context).surfaceOverlay60,
                size: isMobile ? 14 : 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

