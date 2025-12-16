import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/features/auth/presentation/providers/auth_provider.dart';

/// Tela de recupera��o de senha
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await ref.read(authProvider.notifier).forgotPassword(
      _emailController.text.trim(),
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (success) {
          _emailSent = true;
        } else {
          _errorMessage = ref.read(authProvider).errorMessage ?? 'Erro ao enviar email';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeColors.of(context).brandLoginGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 24,
                  tablet: 32,
                  desktop: 48,
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? double.infinity : (isTablet ? 500 : 450),
                ),
                child: Container(
                  padding: EdgeInsets.all(
                    ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 24,
                      tablet: 32,
                      desktop: 40,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: ThemeColors.of(context).neutralBlackLight,
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: _emailSent ? _buildSuccessContent() : _buildFormContent(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // �cone
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).brandPrimaryGreen, ThemeColors.of(context).brandPrimaryGreenDark],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.lock_reset_rounded,
              color: ThemeColors.of(context).surface,
              size: 40,
            ),
          ),

          // T�tulo
          Text(
            'Esqueceu a senha?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Descri��o
          Text(
            'Digite seu email para receber as instru��es de recupera��o de senha.',
            style: TextStyle(
              fontSize: 14,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Campo de email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'seu@email.com',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, digite seu email';
              }
              if (!value.contains('@')) {
                return 'Por favor, digite um email v�lido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Mensagem de erro
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).errorLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ThemeColors.of(context).errorLight),
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
          if (_errorMessage != null) const SizedBox(height: 16),

          // Bot�o de enviar
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendResetEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
                foregroundColor: ThemeColors.of(context).surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                shadowColor: ThemeColors.of(context).brandPrimaryGreenLight,
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
                      ),
                    )
                  : Text(
                      'Enviar instru��es',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Voltar para login
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_back_rounded, size: 18),
                const SizedBox(width: 8),
                const Text('Voltar para o login'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // �cone de sucesso
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).greenMainLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mark_email_read_rounded,
            color: ThemeColors.of(context).greenMain,
            size: 50,
          ),
        ),

        // T�tulo
        const Text(
          'Email enviado!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // Descri��o
        Text(
          'Enviamos as instru��es de recupera��o para:\n${_emailController.text}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: ThemeColors.of(context).textSecondary,
          ),
        ),
        const SizedBox(height: 8),

        Text(
          'Verifique sua caixa de entrada e spam.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: ThemeColors.of(context).textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Bot�o voltar para login
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
              foregroundColor: ThemeColors.of(context).surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: ThemeColors.of(context).brandPrimaryGreenLight,
            ),
            child: const Text(
              'Voltar para o login',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Reenviar
        TextButton(
          onPressed: () {
            setState(() => _emailSent = false);
          },
          child: const Text('N�o recebeu? Enviar novamente'),
        ),
      ],
    );
  }
}







