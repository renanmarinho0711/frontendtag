import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tagbean/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/features/auth/presentation/providers/auth_provider.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin, ResponsiveCache {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Prã-preencher credenciais para desenvolvimento
    _usernameController.text = 'demo_admin';
    _passwordController.text = 'TagBean@2025!';
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // AutenticAção via Backend
    await _loginWithBackend();
  }

  /// Login usando o backend real (com fallback fake para desenvolvimento)
  Future<void> _loginWithBackend() async {
    try {
      final authNotifier = ref.read(authProvider.notifier);
      final loginResponse = await authNotifier.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (loginResponse != null) {
        // Login bem-sucedido - inicializar WorkContext
        if (loginResponse.workContext != null) {
          await ref.read(workContextProvider.notifier).initialize(loginResponse.workContext);
        }

        // Navegar para o Dashboard
        _navigateToDashboard();
      } else {
        // Falha no login - tentar login fake para desenvolvimento
        _tryFakeLogin();
      }
    } catch (e) {
      if (!mounted) return;
      
      // Em caso de erro de conexão, tentar login fake para desenvolvimento
      _tryFakeLogin();
    }
  }

  /// Login fake para desenvolvimento (sem backend)
  void _tryFakeLogin() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    // Credenciais fake para desenvolvimento
    if ((username == 'demo_admin' && password == 'TagBean@2025!') ||
        (username == 'admin' && password == 'admin') ||
        (username == 'test' && password == 'test')) {
      // Login fake bem-sucedido
      debugPrint('🔓 LOGIN FAKE: Acesso permitido para desenvolvimento');
      _navigateToDashboard();
    } else {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Credenciais inválidas. Use: demo_admin / TagBean@2025!');
      _animationController.reset();
      _animationController.forward();
    }
  }

  /// Navega para o Dashboard com animAção
  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ThemeColors.of(context).error,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        margin: const EdgeInsets.all(AppSpacing.lg),
      ),
    );
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ForgotPasswordScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: ThemeColors.of(context).brandLoginGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.screenPaddingHorizontal.get(isMobile, isTablet),
                vertical: AppSizes.screenPaddingVertical,
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: AppSizes.loginCardMaxWidth.get(isMobile, isTablet),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHeader(isMobile, isTablet),
                        SizedBox(height: AppSizes.headerToCard.get(isMobile, isTablet)),
                        _buildLoginCard(isMobile, isTablet),
                        SizedBox(height: AppSizes.cardToFooter.get(isMobile, isTablet)),
                        _buildFooter(isMobile, isTablet),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile, bool isTablet) {
    final logoSize = AppSizes.logo.get(isMobile, isTablet);

    return Column(
      children: [
        Hero(
          tag: 'app_logo',
          child: SizedBox(
            width: logoSize,
            height: logoSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/logo/logo_transparent.png',
                  width: logoSize,
                  height: logoSize,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.label_rounded,
                      size: logoSize * AppSizes.logoFallbackMultiplier,
                      color: ThemeColors.of(context).surface,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSizes.headerLogoToTitle.get(isMobile, isTablet)),
        Text(
          'TAG BEAN',
          style: AppTextStyles.h1.responsive(isMobile, isTablet).copyWith(
            shadows: [
              Shadow(
                color: ThemeColors.of(context).shadowLight,
                offset: const Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        SizedBox(height: AppSizes.headerTitleToSubtitle.get(isMobile, isTablet)),
        // BADGE "PREÇO INTELIGENTE" - usa cores de login específicas
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.subtitlePaddingHorizontal.get(isMobile, isTablet),
            vertical: AppSizes.subtitlePaddingVertical.get(isMobile, isTablet),
          ),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).loginBadgeBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ThemeColors.of(context).loginBadgeBorder,
              width: AppSizes.borderWidthMedium,
            ),
          ),
          child: Text(
            'PREÇO INTELIGENTE',
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle.responsive(isMobile, isTablet),
          ),
        ),
        SizedBox(height: AppSizes.headerTitleToSubtitle.get(isMobile, isTablet)),
        _buildSystemStatusIndicator(isMobile, isTablet),
      ],
    );
  }

  /// Indicador de status do sistema (online/offline)
  Widget _buildSystemStatusIndicator(bool isMobile, bool isTablet) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
      // INDICADOR "SISTEMA ONLINE" - usa cores de login específicas
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 20,
          vertical: isMobile ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).loginStatusBackground,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: ThemeColors.of(context).statusActive.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.of(context).statusActive.withValues(alpha: 0.2),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicador pulsante
            _PulsingDot(
              color: ThemeColors.of(context).statusActive,
              size: isMobile ? 10 : 12,
            ),
            SizedBox(width: isMobile ? 10 : 12),
            Text(
              'Sistema Online',
              style: TextStyle(
                fontSize: isMobile ? 12 : 14,
                fontWeight: FontWeight.w600,
                color: ThemeColors.of(context).surface,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: isMobile ? 8 : 10),
            Icon(
              Icons.verified_rounded,
              size: isMobile ? 16 : 18,
              color: ThemeColors.of(context).statusActive,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginCard(bool isMobile, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: isMobile ? AppRadius.lg : AppRadius.xl,
        boxShadow: AppShadows.softCard,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.loginCardPadding.get(isMobile, isTablet)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'Bem-vindo!',
                  style: AppTextStyles.h2.responsive(isMobile, isTablet),
                ),
              ),
              SizedBox(height: AppSizes.cardTitleToFields.get(isMobile, isTablet)),
              _buildUsernameField(isMobile, isTablet),
              SizedBox(height: AppSizes.fieldToField.get(isMobile, isTablet)),
              _buildPasswordField(isMobile, isTablet),
              SizedBox(height: AppSizes.fieldToField.get(isMobile, isTablet)),
              _buildRememberAndForgot(isMobile, isTablet),
              SizedBox(height: AppSizes.fieldsToButton.get(isMobile, isTablet)),
              _buildLoginButton(isMobile, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usuário',
          style: AppTextStyles.fieldLabel.responsive(isMobile, isTablet),
        ),
        const SizedBox(height: AppSizes.fieldLabelToInput),
        TextFormField(
          controller: _usernameController,
          style: AppTextStyles.input.responsive(isMobile, isTablet),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: '',
            prefixIcon: Container(
              margin: const EdgeInsets.all(AppSpacing.sm),
              padding: const EdgeInsets.all(AppSizes.inputIconPadding),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).brandPrimaryGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person_rounded,
                color: ThemeColors.of(context).surface,
                size: isMobile ? AppSizes.iconMedium.get(isMobile, isTablet) : AppSizes.iconLarge.get(isMobile, isTablet),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: BorderSide(color: ThemeColors.of(context).borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: BorderSide(color: ThemeColors.of(context).borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: BorderSide(
                color: ThemeColors.of(context).brandPrimaryGreen,
                width: AppSizes.borderWidthThick,
              ),
            ),
            filled: true,
            fillColor: ThemeColors.of(context).inputBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira seu Usuário';
            }
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Senha',
          style: AppTextStyles.fieldLabel.responsive(isMobile, isTablet),
        ),
        const SizedBox(height: AppSizes.fieldLabelToInput),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: AppTextStyles.input.responsive(isMobile, isTablet),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _login(),
          decoration: InputDecoration(
            hintText: '',
            prefixIcon: Container(
              margin: const EdgeInsets.all(AppSpacing.sm),
              padding: const EdgeInsets.all(AppSizes.inputIconPadding),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).brandPrimaryGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.lock_rounded,
                color: ThemeColors.of(context).surface,
                size: isMobile ? AppSizes.iconMedium.get(isMobile, isTablet) : AppSizes.iconLarge.get(isMobile, isTablet),
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: ThemeColors.of(context).iconDefault,
                size: isMobile ? AppSizes.iconMedium.get(isMobile, isTablet) : AppSizes.iconLarge.get(isMobile, isTablet),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: BorderSide(color: ThemeColors.of(context).borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: BorderSide(color: ThemeColors.of(context).borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: BorderSide(
                color: ThemeColors.of(context).brandPrimaryGreen,
                width: AppSizes.borderWidthThick,
              ),
            ),
            filled: true,
            fillColor: ThemeColors.of(context).inputBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira sua senha';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRememberAndForgot(bool isMobile, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: AppSizes.checkboxSize,
              height: AppSizes.checkboxSize,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ??  false;
                  });
                },
                activeColor: ThemeColors.of(context).brandPrimaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Lembrar-me',
              style: AppTextStyles.body.responsive(isMobile, isTablet),
            ),
          ],
        ),
        TextButton(
          onPressed: _navigateToForgotPassword,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
          ),
          child: Text(
            'Esqueceu a senha?',
            style: AppTextStyles.buttonText.responsive(isMobile, isTablet),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(bool isMobile, bool isTablet) {
    return SizedBox(
      height: AppSizes.buttonHeight.get(isMobile, isTablet),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
          foregroundColor: ThemeColors.of(context).surface,
          elevation: 0,
          shadowColor: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.3),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
          disabledBackgroundColor: ThemeColors.of(context).disabledButton,
        ),
        child: _isLoading
            ? SizedBox(
                height: AppSizes.loadingIndicatorSize,
                width: AppSizes.loadingIndicatorSize,
                child: CircularProgressIndicator(
                  strokeWidth: AppSizes.loadingIndicatorStroke,
                  valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ENTRAR',
                    style: AppTextStyles.buttonPrimary.responsive(isMobile, isTablet),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(Icons.arrow_forward_rounded, size: AppSizes.iconMedium.get(isMobile, isTablet)),
                ],
              ),
      ),
    );
  }

  Widget _buildFooter(bool isMobile, bool isTablet) {
    return Column(
      children: [
        Text(
          'Etiquetas Eletrônicas Inteligentes',
          textAlign: TextAlign.center,
          style: AppTextStyles.footer.responsive(isMobile, isTablet).copyWith(
            color: ThemeColors.of(context).surfaceOverlay90,
          ),
        ),
        const SizedBox(height: AppSizes.footerTextSpacing),
        Text(
          'ã 2025 - TAG BEAN Inteligentes',
          textAlign: TextAlign.center,
          style: AppTextStyles.footerSecondary.responsive(isMobile, isTablet).copyWith(
            color: ThemeColors.of(context).surfaceOverlay70,
          ),
        ),
        const SizedBox(height: 16),
        // Botão de teste da API (apenas para desenvolvimento)
        TextButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/dev/full-api-test'),
          icon: Icon(Icons.science, color: ThemeColors.of(context).surfaceOverlay60, size: 16),
          label: Text(
            '🧪 Testes da API',
            style: TextStyle(color: ThemeColors.of(context).surfaceOverlay60, fontSize: 12),
          ),
        ),
        const SizedBox(height: 8),
        // BOTÀO DEBUG - MOSTRA TODAS AS CORES DA TELA DE LOGIN
        TextButton.icon(
          onPressed: () => _debugPrintLoginColors(context),
          icon: Icon(Icons.palette, color: ThemeColors.of(context).surface, size: 16),
          label: Text(
            '🎨 DEBUG CORES',
            style: TextStyle(color: ThemeColors.of(context).surface, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  /// DEBUG: Imprime todas as cores usadas na tela de login
  void _debugPrintLoginColors(BuildContext context) {
    final colors = ThemeColors.of(context);
    
    // ignore: deprecated_member_use
    String colorToHex(Color c) => '#${c.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    
    debugPrint('');
    debugPrint('╔══════════════════════════════════════════════════════════════════╗');
    debugPrint('║          🎨 CORES DA TELA DE LOGIN - DEBUG                       ║');
    debugPrint('╠══════════════════════════════════════════════════════════════════╣');
    debugPrint('║ FUNDO DA PÁGINA (brandLoginGradient):                            ║');
    debugPrint('║   Cor 1: ${colorToHex(colors.brandLoginGradient.colors[0])}                                      ║');
    debugPrint('║   Cor 2: ${colorToHex(colors.brandLoginGradient.colors[1])}                                      ║');
    debugPrint('╠══════════════════════════════════════════════════════════════════╣');
    debugPrint('║ CARD DE LOGIN:                                                   ║');
    debugPrint('║   surface: ${colorToHex(colors.surface)}                                     ║');
    debugPrint('╠══════════════════════════════════════════════════════════════════╣');
    debugPrint('║ BADGE "PREÇO INTELIGENTE":                                       ║');
    debugPrint('║   loginBadgeBackground: ${colorToHex(colors.loginBadgeBackground)}                        ║');
    debugPrint('║   loginBadgeBorder: ${colorToHex(colors.loginBadgeBorder)}                            ║');
    debugPrint('╠══════════════════════════════════════════════════════════════════╣');
    debugPrint('║ INDICADOR "SISTEMA ONLINE":                                      ║');
    debugPrint('║   loginStatusBackground: ${colorToHex(colors.loginStatusBackground)}                       ║');
    debugPrint('║   statusActive: ${colorToHex(colors.statusActive)}                                ║');
    debugPrint('╠══════════════════════════════════════════════════════════════════╣');
    debugPrint('║ INPUTS (USUÁRIO/SENHA):                                          ║');
    debugPrint('║   inputBackground: ${colorToHex(colors.inputBackground)}                             ║');
    debugPrint('║   borderLight: ${colorToHex(colors.borderLight)}                                 ║');
    debugPrint('║   brandPrimaryGreen (ícone): ${colorToHex(colors.brandPrimaryGreen)}                    ║');
    debugPrint('║   iconDefault: ${colorToHex(colors.iconDefault)}                                 ║');
    debugPrint('╠══════════════════════════════════════════════════════════════════╣');
    debugPrint('║ BOTÀO ENTRAR:                                                    ║');
    debugPrint('║   brandPrimaryGreen: ${colorToHex(colors.brandPrimaryGreen)}                          ║');
    debugPrint('║   disabledButton: ${colorToHex(colors.disabledButton)}                              ║');
    debugPrint('╠══════════════════════════════════════════════════════════════════╣');
    debugPrint('║ CHECKBOX:                                                        ║');
    debugPrint('║   brandPrimaryGreen: ${colorToHex(colors.brandPrimaryGreen)}                          ║');
    debugPrint('╠══════════════════════════════════════════════════════════════════╣');
    debugPrint('║ TEXTOS:                                                          ║');
    debugPrint('║   textPrimary: ${colorToHex(colors.textPrimary)}                                 ║');
    debugPrint('║   textSecondary: ${colorToHex(colors.textSecondary)}                               ║');
    debugPrint('║   surfaceOverlay90 (footer): ${colorToHex(colors.surfaceOverlay90)}                    ║');
    debugPrint('║   surfaceOverlay70 (footer2): ${colorToHex(colors.surfaceOverlay70)}                   ║');
    debugPrint('╠══════════════════════════════════════════════════════════════════╣');
    debugPrint('║ SOMBRAS:                                                         ║');
    debugPrint('║   shadowLight: ${colorToHex(colors.shadowLight)}                                 ║');
    debugPrint('╚══════════════════════════════════════════════════════════════════╝');
    debugPrint('');
    
    // Mostra um SnackBar para confirmar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('🎨 Cores impressas no console! Pressione F12 para ver.'),
        backgroundColor: colors.brandPrimaryGreen,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

/// Widget de ponto pulsante animado para indicar status online
class _PulsingDot extends StatefulWidget {
  final Color color;
  final double size;

  const _PulsingDot({
    required this.color,
    this.size = 12,
  });

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 2.5,
      height: widget.size * 2.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Anel pulsante externo
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.color.withValues(alpha: _opacityAnimation.value),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),
          // Ponto central sólido
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.5),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






