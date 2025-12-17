import 'package:flutter/material.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Campo de senha customizado do app
class AppPasswordField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final bool autofocus;
  final TextInputAction textInputAction;
  final AutovalidateMode autovalidateMode;
  final bool showStrengthIndicator;

  const AppPasswordField({
    super.key,
    this.label = 'Senha',
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction = TextInputAction.done,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.showStrengthIndicator = false,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;
  double _passwordStrength = 0;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _onChanged(String value) {
    if (widget.showStrengthIndicator) {
      setState(() {
        _passwordStrength = _calculateStrength(value);
      });
    }
    widget.onChanged?.call(value);
  }

  double _calculateStrength(String password) {
    if (password.isEmpty) return 0;

    double strength = 0;

    // Comprimento
    if (password.length >= 6) strength += 0.2;
    if (password.length >= 8) strength += 0.1;
    if (password.length >= 12) strength += 0.1;

    // Maiúsculas
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.15;

    // Minúsculas
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.15;

    // Números
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.15;

    // Caracteres especiais
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.15;

    return strength.clamp(0, 1);
  }

  Color _getStrengthColor(ThemeColorsData colors) {
    if (_passwordStrength < 0.3) return colors.redMain;
    if (_passwordStrength < 0.6) return colors.orangeMaterial;
    if (_passwordStrength < 0.8) return colors.yellowGold;
    return colors.greenMaterial;
  }

  String _getStrengthLabel() {
    if (_passwordStrength < 0.3) return 'Fraca';
    if (_passwordStrength < 0.6) return 'Média';
    if (_passwordStrength < 0.8) return 'Boa';
    return 'Forte';
  }

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          validator: widget.validator,
          onChanged: _onChanged,
          onFieldSubmitted: widget.onSubmitted,
          obscureText: _obscureText,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          textInputAction: widget.textInputAction,
          autovalidateMode: widget.autovalidateMode,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            helperText: widget.helperText,
            errorText: widget.errorText,
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              ),
              onPressed: _toggleVisibility,
            ),
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        if (widget.showStrengthIndicator &&
            widget.controller != null &&
            widget.controller!.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _passwordStrength,
                    backgroundColor: colors.grey300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getStrengthColor(colors),
                    ),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _getStrengthLabel(),
                style: TextStyle(
                  fontSize: 12,
                  color: _getStrengthColor(colors),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Campo de confirmação de senha
class AppConfirmPasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController? confirmController;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final TextInputAction textInputAction;

  const AppConfirmPasswordField({
    super.key,
    required this.passwordController,
    this.confirmController,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.textInputAction = TextInputAction.done,
  });

  @override
  State<AppConfirmPasswordField> createState() =>
      _AppConfirmPasswordFieldState();
}

class _AppConfirmPasswordFieldState extends State<AppConfirmPasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirme a senha';
    }

    if (value != widget.passwordController.text) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.confirmController,
      focusNode: widget.focusNode,
      validator: _validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      obscureText: _obscureText,
      enabled: widget.enabled,
      textInputAction: widget.textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: 'Confirmar Senha',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: _toggleVisibility,
        ),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}




