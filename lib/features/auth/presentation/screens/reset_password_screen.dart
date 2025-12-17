import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/auth/presentation/screens/login_screen.dart';
import 'package:tagbean/features/auth/presentation/providers/auth_provider.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String emailOrUsername;

  const ResetPasswordScreen({
    super.key,
    required this.emailOrUsername,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> 
    with SingleTickerProviderStateMixin, ResponsiveCache {
  
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _passwordReset = false;
  String? _errorMessage;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    HapticFeedback.mediumImpact();

    // Chama API real de redefiniãão de senha
    final success = await ref.read(authProvider.notifier).resetPassword(
      email: widget.emailOrUsername,
      token: _codeController.text.trim(),
      newPassword: _newPasswordController.text,
    );

    if (!mounted) return;

    if (success) {
      setState(() {
        _isLoading = false;
        _passwordReset = true;
      });

      HapticFeedback.lightImpact();

      // Aguarda 3 segundos e volta para login
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
        (route) => false,
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = ref.read(authProvider).errorMessage ?? 'Token inválido ou expirado';
      });
    }
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
                        _passwordReset
                            ? _buildSuccessCard(isMobile, isTablet)
                            : _buildResetCard(isMobile, isTablet),
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
          child: Image.asset(
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
        ),
        SizedBox(height: AppSizes.headerLogoToTitle.get(isMobile, isTablet)),
        Text(
          'Nova Senha',
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
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.subtitlePaddingHorizontal.get(isMobile, isTablet),
            vertical: AppSizes.subtitlePaddingVertical.get(isMobile, isTablet),
          ),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).overlayLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ThemeColors.of(context).overlayLighter,
              width: AppSizes.borderWidthMedium,
            ),
          ),
          child: Text(
            'DEFINIR SENHA',
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle.responsive(isMobile, isTablet).copyWith(
              fontSize: isMobile ? 10 : (isTablet ? 10.5 : 11),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResetCard(bool isMobile, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: isMobile ?  AppRadius.lg : AppRadius.xl,
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
                  'Redefinir Senha',
                  style: AppTextStyles.h2.responsive(isMobile, isTablet).copyWith(
                    fontSize: isMobile ? 15 : (isTablet ? 16 : 17),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Digite o código recebido e sua nova senha.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.responsive(isMobile, isTablet).copyWith(
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
              SizedBox(height: AppSizes.cardTitleToFields.get(isMobile, isTablet)),
              _buildCodeField(isMobile, isTablet),
              SizedBox(height: AppSizes.fieldToField.get(isMobile, isTablet)),
              _buildNewPasswordField(isMobile, isTablet),
              SizedBox(height: AppSizes.fieldToField.get(isMobile, isTablet)),
              _buildConfirmPasswordField(isMobile, isTablet),
              if (_errorMessage != null) ...[  
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ThemeColors.of(context).error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_rounded, color: ThemeColors.of(context).error, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: ThemeColors.of(context).error, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: AppSizes.fieldsToButton.get(isMobile, isTablet)),
              _buildResetButton(isMobile, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessCard(bool isMobile, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: isMobile ? AppRadius.lg : AppRadius.xl,
        boxShadow: AppShadows.softCard,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.loginCardPadding.get(isMobile, isTablet) * 1.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                size: 64,
                color: ThemeColors.of(context).brandPrimaryGreen,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Senha Redefinida! ',
              style: AppTextStyles.h2.responsive(isMobile, isTablet).copyWith(
                color: ThemeColors.of(context).brandPrimaryGreen,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Sua senha foi alterada com sucesso. você pode fazer login com sua nova senha.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.responsive(isMobile, isTablet).copyWith(
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ThemeColors.of(context).brandPrimaryGreen,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Redirecionando para o login...',
                  style: AppTextStyles.body.responsive(isMobile, isTablet).copyWith(
                    color: ThemeColors.of(context).textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeField(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cãdigo de VerificAção',
          style: AppTextStyles.fieldLabel.responsive(isMobile, isTablet),
        ),
        const SizedBox(height: AppSizes.fieldLabelToInput),
        TextFormField(
          controller: _codeController,
          style: AppTextStyles.input.responsive(isMobile, isTablet),
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            hintText: '000000',
            counterText: '',
            prefixIcon: Container(
              margin: const EdgeInsets.all(AppSpacing.sm),
              padding: const EdgeInsets.all(AppSizes.inputIconPadding),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).brandPrimaryGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.pin_rounded,
                color: ThemeColors.of(context).surface,
                size: isMobile 
                  ? AppSizes.iconMedium.get(isMobile, isTablet) 
                  : AppSizes.iconLarge.get(isMobile, isTablet),
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
              return 'Por favor, insira o código';
            }
            if (value.length != 6) {
              return 'O código deve ter 6 dígitos';
            }
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
        ),
      ],
    );
  }

  Widget _buildNewPasswordField(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nova Senha',
          style: AppTextStyles.fieldLabel.responsive(isMobile, isTablet),
        ),
        const SizedBox(height: AppSizes.fieldLabelToInput),
        TextFormField(
          controller: _newPasswordController,
          obscureText: _obscureNewPassword,
          style: AppTextStyles.input.responsive(isMobile, isTablet),
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
                size: isMobile 
                  ?  AppSizes.iconMedium.get(isMobile, isTablet) 
                  : AppSizes.iconLarge.get(isMobile, isTablet),
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureNewPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: ThemeColors.of(context).iconDefault,
                size: isMobile 
                  ? AppSizes.iconMedium.get(isMobile, isTablet) 
                  : AppSizes.iconLarge.get(isMobile, isTablet),
              ),
              onPressed: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
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
              return 'Por favor, insira uma senha';
            }
            if (value.length < 6) {
              return 'A senha deve ter no mínimo 6 caracteres';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirmar Senha',
          style: AppTextStyles.fieldLabel.responsive(isMobile, isTablet),
        ),
        const SizedBox(height: AppSizes.fieldLabelToInput),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          style: AppTextStyles.input.responsive(isMobile, isTablet),
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
                Icons.lock_reset_rounded,
                color: ThemeColors.of(context).surface,
                size: isMobile 
                  ? AppSizes.iconMedium.get(isMobile, isTablet) 
                  : AppSizes.iconLarge.get(isMobile, isTablet),
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: ThemeColors.of(context).iconDefault,
                size: isMobile 
                  ?  AppSizes.iconMedium.get(isMobile, isTablet) 
                  : AppSizes.iconLarge.get(isMobile, isTablet),
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
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
              return 'Por favor, confirme sua senha';
            }
            if (value != _newPasswordController.text) {
              return 'As senhas não coincidem';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildResetButton(bool isMobile, bool isTablet) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight.get(isMobile, isTablet),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _resetPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
          foregroundColor: ThemeColors.of(context).surface,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
          disabledBackgroundColor: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.6),
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
                    'REDEFINIR SENHA',
                    style: AppTextStyles.buttonPrimary.responsive(isMobile, isTablet),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(Icons.check_circle_rounded, size: 20),
                ],
              ),
      ),
    );
  }
}






