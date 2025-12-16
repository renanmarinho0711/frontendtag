import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/settings/data/models/user_model.dart';
import 'package:tagbean/features/settings/presentation/providers/users_provider.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

class ConfiguracoesUsuariosScreen extends ConsumerStatefulWidget {
  const ConfiguracoesUsuariosScreen({super.key});

  @override
  ConsumerState<ConfiguracoesUsuariosScreen> createState() => _ConfiguracoesUsuariosScreenState();
}

class _ConfiguracoesUsuariosScreenState extends ConsumerState<ConfiguracoesUsuariosScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  String _searchQuery = '';
  
  // Cache de usurios filtrados
  List<SettingsUserModel>? _cachedUsuariosFiltrados;
  String _lastSearchQuery = '';

  // Obter usurios do provider
  List<SettingsUserModel> get _usuarios => ref.watch(usersListProvider);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Getter com cache para usurios filtrados
  List<SettingsUserModel> get _usuariosFiltrados {
    if (_cachedUsuariosFiltrados != null &&
        _lastSearchQuery == _searchQuery) {
      return _cachedUsuariosFiltrados!;
    }
    
    _lastSearchQuery = _searchQuery;
    
    _cachedUsuariosFiltrados = _usuarios.where((usuario) {
      final nome = (usuario.fullName ?? usuario.username).toLowerCase();
      final email = (usuario.email ?? '').toLowerCase();
      final query = _searchQuery.toLowerCase();
      return nome.contains(query) || email.contains(query);
    }).toList();
    
    return _cachedUsuariosFiltrados!;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final usuariosAtivos = ref.watch(activeUsersCountProvider);
    final usuariosInativos = ref.watch(inactiveUsersCountProvider);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ThemeColors.of(context).surfaceSecondary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModernAppBar(),
              _buildStatsCards(usuariosAtivos, usuariosInativos),
              _buildSearchBar(),
              Expanded(
                child: _usuariosFiltrados.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.all(
                          AppSizes.paddingMd.get(isMobile, isTablet),
                        ),
                        itemCount: _usuariosFiltrados.length,
                        itemBuilder: (context, index) {
                          return _buildUserCard(_usuariosFiltrados[index], index);
                        },
                      ),
              ),
            ],
          ),
        ),
        Positioned(
          right: AppSizes.paddingMd.get(isMobile, isTablet),
          bottom: AppSizes.paddingMd.get(isMobile, isTablet),
          child: FloatingActionButton.extended(
            onPressed: () {
              _showAddUserDialog();
            },
            icon: Icon(
              Icons.person_add_rounded,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
            label: Text(
              isMobile ? 'Novo' : 'Novo Usurio',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
            ),
            backgroundColor: ThemeColors.of(context).success,
          ),
        ),
      ]
    );
  }

  Widget _buildModernAppBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
        vertical: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: AppGradients.darkBackground(context),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Boto de voltar
          Material(
            color: ThemeColors.of(context).transparent,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
              child: Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingBase.get(isMobile, isTablet),
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
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
              ),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay20,
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.people_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Usurios e Permisses',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 18,
                      mobileFontSize: 16,
                      tabletFontSize: 17,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Gerencie acessos ao sistema',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 10,
                      tabletFontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).surfaceOverlay70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(int ativos, int inativos) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(
                AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ThemeColors.of(context).success, ThemeColors.of(context).successEnd],
                ),
                borderRadius: BorderRadius.circular(
                  isMobile ? 12 : (isTablet ? 14 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThemeColors.of(context).successLight,
                    blurRadius: isMobile ? 10 : 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).surface.  withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconMedium.get(isMobile, isTablet),
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$ativos',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 24,
                              mobileFontSize: 20,
                              tabletFontSize: 22,
                            ),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).surface,
                          ),
                        ),
                        Text(
                          'Ativos',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 12,
                              mobileFontSize: 10,
                              tabletFontSize: 11,
                            ),
                          overflow: TextOverflow.ellipsis,
                            color: ThemeColors.of(context).surfaceOverlay70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(
                AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).textSecondaryOverlay15,
                borderRadius: BorderRadius.circular(
                  isMobile ? 12 : (isTablet ? 14 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThemeColors.of(context).textPrimaryOverlay05,
                    blurRadius: isMobile ? 10 : 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).surfaceOverlay20,
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                    child: Icon(
                      Icons.pause_circle_rounded,
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconMedium.get(isMobile, isTablet),
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$inativos',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 24,
                              mobileFontSize: 20,
                              tabletFontSize: 22,
                            ),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).surface,
                          ),
                        ),
                        Text(
                          'Inativos',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 12,
                              mobileFontSize: 10,
                              tabletFontSize: 11,
                            ),
                          overflow: TextOverflow.ellipsis,
                            color: ThemeColors.of(context).surfaceOverlay70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : (isTablet ? 14 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            baseFontSize: 14,
            mobileFontSize: 13,
            tabletFontSize: 13,
          ),
        ),
        decoration: InputDecoration(
          hintText: 'Buscar usurios por nome ou email...',
          hintStyle: TextStyle(
            color: ThemeColors.of(context).textSecondary,
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 12,
              tabletFontSize: 13,
            ),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: ThemeColors.of(context).textSecondary,
            size: AppSizes.iconMedium.get(isMobile, isTablet),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: ThemeColors.of(context).textSecondary,
                    size: AppSizes.iconMedium.get(isMobile, isTablet),
                  ),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
            vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(SettingsUserModel usuario, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isAtivo = usuario.isActive;

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
          border: isAtivo ?  null : Border.all(color: ThemeColors.of(context).textSecondary),
          boxShadow: isAtivo
              ? [
                  BoxShadow(
                    color: usuario.avatarColorLight,
                    blurRadius: isMobile ? 15 : 20,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: ThemeColors.of(context).transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.all(
              AppSizes.cardPadding.get(isMobile, isTablet),
            ),
            childrenPadding: EdgeInsets.fromLTRB(
              AppSizes.cardPadding.get(isMobile, isTablet),
              0,
              AppSizes.cardPadding.get(isMobile, isTablet),
              AppSizes.cardPadding.get(isMobile, isTablet),
            ),
            leading: Hero(
              tag: 'usuario_${usuario.id}',
              child: Container(
                width: ResponsiveHelper.getResponsiveWidth(
                  context,
                  mobile: 50,
                  tablet: 55,
                  desktop: 60,
                ),
                height: ResponsiveHelper.getResponsiveHeight(
                  context,
                  mobile: 50,
                  tablet: 55,
                  desktop: 60,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      usuario.avatarColor,
                      usuario.avatarColor.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 12 : (isTablet ? 14 : 16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: usuario.avatarColorLight,
                      blurRadius: isMobile ? 10 : 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    usuario.avatarInitial,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 24,
                        mobileFontSize: 20,
                        tabletFontSize: 22,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.of(context).surface,
                    ),
                  ),
                ),
              ),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    usuario.displayName,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 16,
                        mobileFontSize: 14,
                        tabletFontSize: 15,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: isAtivo ? ThemeColors.of(context).textPrimary : ThemeColors.of(context).textSecondary,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                    vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    color: isAtivo ? ThemeColors.of(context).successLight : ThemeColors.of(context).textSecondary,
                    borderRadius: BorderRadius.circular(
                      isMobile ? 6 : 8,
                    ),
                    border: Border.all(
                      color: isAtivo ? ThemeColors.of(context).successLight : ThemeColors.of(context).textSecondary,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: ResponsiveHelper.getResponsiveWidth(
                          context,
                          mobile: 5,
                          tablet: 6,
                          desktop: 6,
                        ),
                        height: ResponsiveHelper.getResponsiveHeight(
                          context,
                          mobile: 5,
                          tablet: 6,
                          desktop: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isAtivo ?  ThemeColors.of(context).success : ThemeColors.of(context).textSecondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        width: AppSizes.paddingXxs.get(isMobile, isTablet),
                      ),
                      Text(
                        isAtivo ? 'Ativo' : 'Inativo',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 10,
                            mobileFontSize: 9,
                            tabletFontSize: 9,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600,
                          color: isAtivo ? ThemeColors.of(context).successDark : ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: AppSizes.paddingXxs.get(isMobile, isTablet),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.email_rounded,
                      size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                      color: ThemeColors.of(context).textSecondary,
                    ),
                    SizedBox(
                      width: AppSizes.paddingXxs.get(isMobile, isTablet),
                    ),
                    Flexible(
                      child: Text(
                        usuario.email ?? 'Sem e-mail',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 12,
                            mobileFontSize: 10,
                            tabletFontSize: 11,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSizes.paddingXxs.get(isMobile, isTablet),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
                        vertical: AppSizes.paddingMicro2.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        color: usuario.avatarColorLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        roleDisplayName(usuario.role),
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 10,
                            mobileFontSize: 8,
                            tabletFontSize: 9,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600,
                          color: usuario.avatarColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: AppSizes.paddingXs.get(isMobile, isTablet),
                    ),
                    Icon(
                      Icons.access_time_rounded,
                      size: AppSizes.iconMicro.get(isMobile, isTablet),
                      color: ThemeColors.of(context).textSecondary,
                    ),
                    SizedBox(
                      width: AppSizes.paddingXxs.get(isMobile, isTablet),
                    ),
                    Flexible(
                      child: Text(
                        'ltimo acesso: ${usuario.lastAccessFormatted}',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 10,
                            mobileFontSize: 8,
                            tabletFontSize: 9,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).surfaceSecondary,
                    borderRadius: BorderRadius.circular(
                      isMobile ? 8 : 10,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.edit_rounded,
                      color: ThemeColors.of(context).textSecondary,
                      size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                    ),
                    onPressed: () => _showEditUserDialog(usuario),
                  ),
                ),
                SizedBox(
                  width: AppSizes.paddingXs.get(isMobile, isTablet),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: isAtivo ? ThemeColors.of(context).warningPastel : ThemeColors.of(context).successPastel,
                    borderRadius: BorderRadius.circular(
                      isMobile ? 8 : 10,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isAtivo ? Icons.block_rounded : Icons.check_circle_rounded,
                      color: isAtivo ? ThemeColors.of(context).orangeMaterial : ThemeColors.of(context).success,
                      size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                    ),
                    onPressed: () => _toggleUserStatus(usuario),
                  ),
                ),
              ],
            ),
            children: [
              _buildExpandedContent(usuario),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(SettingsUserModel usuario) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surfaceSecondary,
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : (isTablet ? 14 : 16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_user_rounded,
                size: AppSizes.iconSmall.get(isMobile, isTablet),
                color: ThemeColors.of(context).textSecondary,
              ),
              SizedBox(
                width: AppSizes.paddingXs.get(isMobile, isTablet),
              ),
              Text(
                'Permisses',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 12,
                    tabletFontSize: 13,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Wrap(
            spacing: AppSizes.paddingXs.get(isMobile, isTablet),
            runSpacing: AppSizes.paddingXs.get(isMobile, isTablet),
            children: usuario.permissions.map((permissao) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                  vertical: AppSizes.paddingXs.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surface,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 8 : 10,
                  ),
                  border: Border.all(color: usuario.avatarColorLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                      color: usuario.avatarColor,
                    ),
                    SizedBox(
                      width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                    ),
                    Text(
                      permissao,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 12,
                          mobileFontSize: 10,
                          tabletFontSize: 11,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        color: ThemeColors.of(context).textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showResetPasswordDialog(usuario),
                  icon: Icon(
                    Icons.lock_reset_rounded,
                    size: AppSizes.iconSmall.get(isMobile, isTablet),
                    color: usuario.avatarColor,
                  ),
                  label: Text(
                    'Resetar Senha',
                    style: TextStyle(
                      color: usuario.avatarColor,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 12,
                        tabletFontSize: 13,
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    side: BorderSide(color: usuario.avatarColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showEditUserDialog(usuario),
                  icon: Icon(
                    Icons.edit_rounded,
                    size: AppSizes.iconSmall.get(isMobile, isTablet),
                  ),
                  label: Text(
                    'Editar',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 12,
                        tabletFontSize: 13,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    backgroundColor: usuario.avatarColor,
                    foregroundColor: ThemeColors.of(context).surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(
              ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 28,
                tablet: 30,
                desktop: 32,
              ),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceSecondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_search_rounded,
              size: AppSizes.iconHero3Xl.get(isMobile, isTablet),
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          SizedBox(
            height: AppSizes.paddingXl.get(isMobile, isTablet),
          ),
          Text(
            'Nenhum usurio encontrado',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 20,
                mobileFontSize: 16,
                tabletFontSize: 18,
              ),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          SizedBox(
            height: AppSizes.paddingXs.get(isMobile, isTablet),
          ),
          Text(
            'Tente uma busca diferente',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 12,
                tabletFontSize: 13,
              ),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Controllers para os campos
    final usernameController = TextEditingController();
    final fullNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    UserRole selectedRole = UserRole.operator;
    List<String> selectedStoreIds = []; // Lojas selecionadas

    showDialog(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (context, ref, _) {
          // Carregar roles permitidas do backend
          final allowedRolesAsync = ref.watch(allowedRolesProvider);
          // Carregar lojas disponveis
          final availableStores = ref.watch(availableStoresProvider);
          
          return StatefulBuilder(
            builder: (context, setDialogState) {
              // Obter lista de roles permitidas
              final List<UserRole> allowedRoles = allowedRolesAsync.when(
                data: (roles) => roles.map((r) => roleFromString(r)).toList(),
                loading: () => [UserRole.operator],
                error: (_, __) => [UserRole.operator],
              );
              
              // Garantir que a role selecionada est na lista permitida
              if (!allowedRoles.contains(selectedRole) && allowedRoles.isNotEmpty) {
                selectedRole = allowedRoles.first;
              }
              
              // Determinar se precisa selecionar lojas baseado na role
              final needsStoreSelection = selectedRole != UserRole.platformAdmin &&
                                          selectedRole != UserRole.clientAdmin;
              
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    isMobile ? 16 : (isTablet ? 18 : 20),
                  ),
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                    padding: EdgeInsets.all(
                      AppSizes.paddingXs.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      gradient: AppGradients.greenProduct(context),
                      borderRadius: BorderRadius.circular(
                        isMobile ? 8 : 10,
                      ),
                    ),
                    child: Icon(
                      Icons.person_add_rounded,
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  Text(
                    'Novo Usurio',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 20,
                        mobileFontSize: 18,
                        tabletFontSize: 19,
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Username (obrigatrio)
                    TextField(
                      controller: usernameController,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 13,
                          tabletFontSize: 13,
                        ),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Nome de Usurio *',
                        hintText: 'Login do usurio',
                        labelStyle: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 12,
                            tabletFontSize: 13,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.account_circle_rounded,
                          size: AppSizes.iconMedium.get(isMobile, isTablet),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            isMobile ? 10 : 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    // Nome Completo
                    TextField(
                      controller: fullNameController,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 13,
                          tabletFontSize: 13,
                        ),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Nome Completo',
                        labelStyle: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 12,
                            tabletFontSize: 13,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.person_rounded,
                          size: AppSizes.iconMedium.get(isMobile, isTablet),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            isMobile ? 10 : 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    // E-mail
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 13,
                          tabletFontSize: 13,
                        ),
                      ),
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        labelStyle: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 12,
                            tabletFontSize: 13,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          size: AppSizes.iconMedium.get(isMobile, isTablet),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            isMobile ? 10 : 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    // Senha
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 13,
                          tabletFontSize: 13,
                        ),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Senha *',
                        hintText: 'Mnimo 6 caracteres',
                        labelStyle: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 12,
                            tabletFontSize: 13,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.lock_rounded,
                          size: AppSizes.iconMedium.get(isMobile, isTablet),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            isMobile ? 10 : 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    // Nvel de Acesso (Dropdown dinmico baseado nas roles permitidas)
                    DropdownButtonFormField<UserRole>(
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 13,
                          tabletFontSize: 13,
                        ),
                        color: ThemeColors.of(context).textPrimary,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Nvel de Acesso *',
                        labelStyle: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 12,
                            tabletFontSize: 13,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.admin_panel_settings_rounded,
                          size: AppSizes.iconMedium.get(isMobile, isTablet),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            isMobile ? 10 : 12,
                          ),
                        ),
                      ),
                      items: allowedRoles.map((role) {
                        return DropdownMenuItem<UserRole>(
                          value: role,
                          child: Text(
                            roleDisplayName(role),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 14,
                                mobileFontSize: 13,
                                tabletFontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      value: selectedRole,
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => selectedRole = value);
                        }
                      },
                    ),
                    // Info sobre hierarquia
                    if (allowedRolesAsync.isLoading)
                      Padding(
                        padding: EdgeInsets.only(top: AppSizes.paddingMd.get(isMobile, isTablet)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Carregando permisses...',
                              style: TextStyle(
                                fontSize: 12,
                                color: ThemeColors.of(context).textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Seleo de Lojas (para StoreManager e Operator)
                    if (needsStoreSelection) ...[
                      SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
                      Container(
                        padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
                        decoration: BoxDecoration(
                          border: Border.all(color: ThemeColors.of(context).border),
                          borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.store_rounded,
                                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                                  color: ThemeColors.of(context).success,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Lojas de Acesso *',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      baseFontSize: 14,
                                      mobileFontSize: 12,
                                      tabletFontSize: 13,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            if (availableStores.isEmpty)
                              Text(
                                'Nenhuma loja disponvel',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ThemeColors.of(context).textSecondary,
                                ),
                              )
                            else
                              Column(
                                children: availableStores.map((store) {
                                  final isSelected = selectedStoreIds.contains(store.id);
                                  return CheckboxListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      store.name,
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    subtitle: store.cnpj != null 
                                        ? Text(store.cnpj!, style: TextStyle(fontSize: 11))
                                        : null,
                                    value: isSelected,
                                    onChanged: (checked) {
                                      setDialogState(() {
                                        if (checked == true) {
                                          selectedStoreIds.add(store.id);
                                        } else {
                                          selectedStoreIds.remove(store.id);
                                        }
                                      });
                                    },
                                    activeColor: ThemeColors.of(context).success,
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    usernameController.dispose();
                    fullNameController.dispose();
                    emailController.dispose();
                    passwordController.dispose();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancelar',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                        tabletFontSize: 13,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final username = usernameController.text.trim();
                    final fullName = fullNameController.text.trim();
                    final email = emailController.text.trim();
                    final password = passwordController.text;
                    
                    // Validaes
                    if (username.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Nome de usurio  obrigatrio'),
                          backgroundColor: ThemeColors.of(context).orangeMaterial,
                        ),
                      );
                      return;
                    }
                    
                    if (password.isEmpty || password.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Senha deve ter no mnimo 6 caracteres'),
                          backgroundColor: ThemeColors.of(context).orangeMaterial,
                        ),
                      );
                      return;
                    }
                    
                    // Validar seleo de lojas para roles que precisam
                    if (needsStoreSelection && selectedStoreIds.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selecione pelo menos uma loja de acesso'),
                          backgroundColor: ThemeColors.of(context).orangeMaterial,
                        ),
                      );
                      return;
                    }
                    
                    // Criar novo usurio via provider (ALINHADO COM CreateUserDto)
                    final newUser = SettingsUserModel(
                      id: '', // Backend gera o ID
                      username: username,
                      fullName: fullName.isNotEmpty ? fullName : null,
                      email: email.isNotEmpty ? email : null,
                      role: selectedRole,
                      status: UserStatus.active,
                      createdAt: DateTime.now(),
                      storeIdsList: selectedStoreIds, // IMPORTANTE: IDs das lojas para o backend
                      defaultStoreId: selectedStoreIds.isNotEmpty ? selectedStoreIds.first : null,
                    );
                    
                    final success = await ref.read(usersProvider.notifier).addUser(newUser, password: password);
                    
                    usernameController.dispose();
                    fullNameController.dispose();
                    emailController.dispose();
                    passwordController.dispose();
                    Navigator.pop(dialogContext);
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                success ? Icons.check_circle_rounded : Icons.error_rounded,
                                color: ThemeColors.of(context).surface,
                                size: AppSizes.iconMedium.get(isMobile, isTablet),
                              ),
                              SizedBox(
                                width: AppSizes.paddingBase.get(isMobile, isTablet),
                              ),
                              Expanded(
                                child: Text(
                                  success ? 'Usurio criado com sucesso!' : 'Erro ao criar usurio',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      baseFontSize: 14,
                                      mobileFontSize: 13,
                                      tabletFontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: success ? ThemeColors.of(context).success : ThemeColors.of(context).error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              isMobile ? 10 : 12,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.of(context).success,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingXlAlt2.get(isMobile, isTablet),
                      vertical: AppSizes.paddingBaseAlt.get(isMobile, isTablet),
                    ),
                  ),
                  child: Text(
                    'Criar Usurio',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                        tabletFontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ),
    );
  }

  void _showEditUserDialog(SettingsUserModel usuario) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    final usernameController = TextEditingController(text: usuario.username);
    final fullNameController = TextEditingController(text: usuario.fullName ?? '');
    final emailController = TextEditingController(text: usuario.email ?? '');
    UserRole selectedRole = usuario.role;
    List<String> selectedStoreIds = List.from(usuario.storeIds); // Lojas atuais do usurio

    showDialog(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (context, ref, _) {
          final allowedRolesAsync = ref.watch(allowedRolesProvider);
          final availableStores = ref.watch(availableStoresProvider);
          
          return StatefulBuilder(
            builder: (context, setDialogState) {
              final List<UserRole> allowedRoles = allowedRolesAsync.when(
                data: (roles) => roles.map((r) => roleFromString(r)).toList(),
                loading: () => [usuario.role],
                error: (_, __) => [usuario.role],
              );
              
              // Se a role atual no est permitida para edio, ainda mostra ela
              if (!allowedRoles.contains(selectedRole)) {
                allowedRoles.insert(0, selectedRole);
              }
              
              // Determinar se precisa selecionar lojas baseado na role
              final needsStoreSelection = selectedRole != UserRole.platformAdmin &&
                                          selectedRole != UserRole.clientAdmin;
              
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isMobile ? 16 : (isTablet ? 18 : 20)),
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSizes.paddingXs.get(isMobile, isTablet)),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [usuario.avatarColor, usuario.avatarColor.withValues(alpha: 0.7)]),
                        borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                      ),
                      child: Icon(Icons.edit_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMediumSmall.get(isMobile, isTablet)),
                    ),
                    SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                    Text('Editar Usurio', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 20, mobileFontSize: 18, tabletFontSize: 19))),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Nome de Usurio',
                          prefixIcon: Icon(Icons.account_circle_rounded, size: AppSizes.iconMedium.get(isMobile, isTablet)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
                      TextField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Nome Completo',
                          prefixIcon: Icon(Icons.person_rounded, size: AppSizes.iconMedium.get(isMobile, isTablet)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email_rounded, size: AppSizes.iconMedium.get(isMobile, isTablet)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
                      DropdownButtonFormField<UserRole>(
                        value: selectedRole,
                        decoration: InputDecoration(
                          labelText: 'Nvel de Acesso',
                          prefixIcon: Icon(Icons.admin_panel_settings_rounded, size: AppSizes.iconMedium.get(isMobile, isTablet)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
                        ),
                        items: allowedRoles.map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(roleDisplayName(role)),
                        )).toList(),
                        onChanged: (value) {
                          if (value != null) setDialogState(() => selectedRole = value);
                        },
                      ),
                      // Seleo de Lojas (para StoreManager e Operator)
                      if (needsStoreSelection) ...[
                        SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
                        Container(
                          padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
                          decoration: BoxDecoration(
                            border: Border.all(color: ThemeColors.of(context).border),
                            borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.store_rounded,
                                    size: AppSizes.iconMedium.get(isMobile, isTablet),
                                    color: ThemeColors.of(context).success,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Lojas de Acesso',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                                        context,
                                        baseFontSize: 14,
                                        mobileFontSize: 12,
                                        tabletFontSize: 13,
                                      ),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              if (availableStores.isEmpty)
                                Text(
                                  'Nenhuma loja disponvel',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ThemeColors.of(context).textSecondary,
                                  ),
                                )
                              else
                                Column(
                                  children: availableStores.map((store) {
                                    final isSelected = selectedStoreIds.contains(store.id);
                                    return CheckboxListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        store.name,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      subtitle: store.cnpj != null 
                                          ? Text(store.cnpj!, style: TextStyle(fontSize: 11))
                                          : null,
                                      value: isSelected,
                                      onChanged: (checked) {
                                        setDialogState(() {
                                          if (checked == true) {
                                            selectedStoreIds.add(store.id);
                                          } else {
                                            selectedStoreIds.remove(store.id);
                                          }
                                        });
                                      },
                                      activeColor: ThemeColors.of(context).success,
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      usernameController.dispose();
                      fullNameController.dispose();
                      emailController.dispose();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final username = usernameController.text.trim();
                      final fullName = fullNameController.text.trim();
                      final email = emailController.text.trim();
                      
                      if (username.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Nome de usurio  obrigatrio'), backgroundColor: ThemeColors.of(context).orangeMaterial),
                        );
                        return;
                      }
                      
                      // Validar seleo de lojas para roles que precisam
                      if (needsStoreSelection && selectedStoreIds.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Selecione pelo menos uma loja de acesso'),
                            backgroundColor: ThemeColors.of(context).orangeMaterial,
                          ),
                        );
                        return;
                      }
                      
                      final updatedUser = usuario.copyWith(
                        username: username,
                        fullName: fullName.isNotEmpty ? fullName : null,
                        email: email.isNotEmpty ? email : null,
                        role: selectedRole,
                        storeIdsList: selectedStoreIds,
                        defaultStoreId: selectedStoreIds.isNotEmpty ? selectedStoreIds.first : null,
                      );
                      
                      final success = await ref.read(usersProvider.notifier).updateUser(updatedUser);
                      
                      usernameController.dispose();
                      fullNameController.dispose();
                      emailController.dispose();
                      Navigator.pop(dialogContext);
                      
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(success ? Icons.check_circle_rounded : Icons.error_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMedium.get(isMobile, isTablet)),
                                SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                                Text(success ? 'Usurio atualizado com sucesso!' : 'Erro ao atualizar usurio'),
                              ],
                            ),
                            backgroundColor: success ? ThemeColors.of(context).success : ThemeColors.of(context).error,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: usuario.avatarColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
                    ),
                    child: const Text('Salvar'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _toggleUserStatus(SettingsUserModel usuario) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isAtivo = usuario.isActive;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
        ),
        icon: Icon(
          isAtivo ? Icons.block_rounded : Icons.check_circle_rounded,
          color: isAtivo ? ThemeColors.of(context).orangeMaterial : ThemeColors.of(context).success,
          size: AppSizes.iconHeroSm.get(isMobile, isTablet),
        ),
        title: Text(
          isAtivo ? 'Desativar Usurio?' : 'Ativar Usurio?',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 20,
              mobileFontSize: 18,
              tabletFontSize: 19,
            ),
          ),
        ),
        content: Text(
          isAtivo
              ? 'O usurio ${usuario.displayName} no poder mais acessar o sistema.'
              : 'O usurio ${usuario.displayName} poder acessar o sistema novamente.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
              tabletFontSize: 13,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(usersProvider.notifier).toggleStatus(usuario.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAtivo ? Icons.block_rounded : Icons.check_circle_rounded,
                        color: ThemeColors.of(context).surface,
                        size: AppSizes.iconMedium.get(isMobile, isTablet),
                      ),
                      SizedBox(
                        width: AppSizes.paddingBase.get(isMobile, isTablet),
                      ),
                      Text(
                        'Usurio ${isAtivo ?  'desativado' : 'ativado'} com sucesso',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 13,
                            tabletFontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: isAtivo ? ThemeColors.of(context).orangeMaterial : ThemeColors.of(context).success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      isMobile ? 10 : 12,
                    ),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isAtivo ? ThemeColors.of(context).orangeMaterial : ThemeColors.of(context).success,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXlAlt2.get(isMobile, isTablet),
                vertical: AppSizes.paddingBaseAlt.get(isMobile, isTablet),
              ),
            ),
            child: Text(
              isAtivo ? 'Desativar' : 'Ativar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetPasswordDialog(SettingsUserModel usuario) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
        ),
        icon: Icon(
          Icons.lock_reset_rounded,
          color: ThemeColors.of(context).primaryDark,
          size: AppSizes.iconHeroSm.get(isMobile, isTablet),
        ),
        title: Text(
          'Resetar Senha',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 20,
              mobileFontSize: 18,
              tabletFontSize: 19,
            ),
          ),
        ),
        content: Text(
          usuario.email != null 
            ? 'Um e-mail ser enviado para ${usuario.email} com instrues para redefinir a senha.'
            : 'Uma nova senha temporria ser gerada para o usurio ${usuario.displayName}.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
              tabletFontSize: 13,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              // Chamar backend para solicitar reset de senha
              final success = await ref.read(usersProvider.notifier).requestPasswordReset(usuario.id);
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          success ? Icons.email_rounded : Icons.error_rounded,
                          color: ThemeColors.of(context).surface,
                          size: AppSizes.iconMedium.get(isMobile, isTablet),
                        ),
                        SizedBox(
                          width: AppSizes.paddingBase.get(isMobile, isTablet),
                        ),
                        Text(
                          success ? 'E-mail de redefinio enviado!' : 'Erro ao enviar e-mail',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 14,
                              mobileFontSize: 13,
                              tabletFontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: success ? ThemeColors.of(context).primary : ThemeColors.of(context).error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isMobile ?  10 : 12,
                      ),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXlAlt2.get(isMobile, isTablet),
                vertical: AppSizes.paddingBaseAlt.get(isMobile, isTablet),
              ),
            ),
            child: Text(
              'Enviar E-mail',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}












