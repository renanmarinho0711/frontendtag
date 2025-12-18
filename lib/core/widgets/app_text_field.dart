import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tagbean/design_system/design_system.dart';

/// # Campos de Texto Customizados
/// 
/// Sistema unificado de inputs.
/// 
/// ## Variantes:
/// - **Filled**: Preenchido (padrão)
/// - **Outlined**: Com borda
/// - **Underlined**: Apenas linha inferior
/// 
/// ## Recursos:
/// - Validação integrada
/// - Máscaras de input
/// - Contador de caracteres
/// - Suporte a prefixo/sufixo
enum AppTextFieldVariant {
  filled,
  outlined,
  underlined,
}

class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helper;
  final String? error;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? maxLines;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final Widget? prefix;
  final Widget? suffix;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final AppTextFieldVariant variant;
  
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helper,
    this.error,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.variant = AppTextFieldVariant.filled,
  });
  
  /// Campo de email
  factory AppTextField.email({
    Key? key,
    String? label = 'Email',
    String? hint = 'seu@email.com',
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return AppTextField(
      key: key,
      label: label,
      hint: hint,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: Icons.email_outlined,
      onChanged: onChanged,
      validator: validator ?? _emailValidator,
    );
  }
  
  /// Campo de senha
  factory AppTextField.password({
    Key? key,
    String? label = 'Senha',
    String? hint = '••••••••',
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return AppTextField(
      key: key,
      label: label,
      hint: hint,
      controller: controller,
      obscureText: true,
      textInputAction: TextInputAction.done,
      prefixIcon: Icons.lock_outline,
      onChanged: onChanged,
      validator: validator ?? _passwordValidator,
    );
  }
  
  /// Campo de busca
  factory AppTextField.search({
    Key? key,
    String? hint = 'Buscar...',
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    VoidCallback? onClear,
  }) {
    return AppTextField(
      key: key,
      hint: hint,
      controller: controller,
      textInputAction: TextInputAction.search,
      prefixIcon: Icons.search,
      suffixIcon: Icons.clear,
      onSuffixTap: onClear,
      onChanged: onChanged,
      variant: AppTextFieldVariant.outlined,
    );
  }
  
  static String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }
  
  static String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 8) {
      return 'Senha deve ter no mínimo 8 caracteres';
    }
    return null;
  }
  
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _obscureText = false;
  bool _hasFocus = false;
  
  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
    _focusNode.addListener(_handleFocusChange);
  }
  
  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }
  
  void _handleFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }
  
  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.labelMediumWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: AppSpacing.gapVerticalXs),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          maxLength: widget.maxLength,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          style: AppTextStyles.bodyLargeWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          decoration: _getDecoration(isDark),
        ),
        if (widget.helper != null && widget.error == null) ...[
          SizedBox(height: AppSpacing.gapVerticalXs),
          Text(
            widget.helper!,
            style: AppTextStyles.bodySmallWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
        if (widget.error != null) ...[
          SizedBox(height: AppSpacing.gapVerticalXs),
          Text(
            widget.error!,
            style: AppTextStyles.bodySmallWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
  
  InputDecoration _getDecoration(bool isDark) {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: AppTextStyles.bodyLargeWith(
        color: isDark ? AppColors.grey600 : AppColors.grey400,
      ),
      filled: widget.variant == AppTextFieldVariant.filled,
      fillColor: widget.variant == AppTextFieldVariant.filled
          ? (isDark ? AppColors.grey800 : AppColors.grey100)
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              size: 20,
              color: _hasFocus
                  ? (isDark ? AppColors.primaryLight : AppColors.primary)
                  : (isDark ? AppColors.grey600 : AppColors.grey500),
            )
          : widget.prefix,
      suffixIcon: _buildSuffix(isDark),
      border: _getBorder(),
      enabledBorder: _getEnabledBorder(isDark),
      focusedBorder: _getFocusedBorder(isDark),
      errorBorder: _getErrorBorder(),
      focusedErrorBorder: _getFocusedErrorBorder(),
      disabledBorder: _getDisabledBorder(isDark),
      counterText: '',
    );
  }
  
  Widget? _buildSuffix(bool isDark) {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 20,
        ),
        color: isDark ? AppColors.grey600 : AppColors.grey500,
        onPressed: _toggleObscureText,
      );
    }
    
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon, size: 20),
        color: isDark ? AppColors.grey600 : AppColors.grey500,
        onPressed: widget.onSuffixTap,
      );
    }
    
    return widget.suffix;
  }
  
  InputBorder _getBorder() {
    return switch (widget.variant) {
      AppTextFieldVariant.filled => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          borderSide: BorderSide.none,
        ),
      AppTextFieldVariant.outlined => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        ),
      AppTextFieldVariant.underlined => const UnderlineInputBorder(),
    };
  }
  
  InputBorder _getEnabledBorder(bool isDark) {
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    
    return switch (widget.variant) {
      AppTextFieldVariant.filled => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          borderSide: BorderSide.none,
        ),
      AppTextFieldVariant.outlined => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          borderSide: BorderSide(color: borderColor),
        ),
      AppTextFieldVariant.underlined => UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
    };
  }
  
  InputBorder _getFocusedBorder(bool isDark) {
    final focusColor = isDark ? AppColors.primaryLight : AppColors.primary;
    
    return switch (widget.variant) {
      AppTextFieldVariant.filled => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          borderSide: BorderSide(color: focusColor, width: 2),
        ),
      AppTextFieldVariant.outlined => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          borderSide: BorderSide(color: focusColor, width: 2),
        ),
      AppTextFieldVariant.underlined => UnderlineInputBorder(
          borderSide: BorderSide(color: focusColor, width: 2),
        ),
    };
  }
  
  InputBorder _getErrorBorder() {
    return switch (widget.variant) {
      AppTextFieldVariant.filled => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      AppTextFieldVariant.outlined => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      AppTextFieldVariant.underlined => const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
        ),
    };
  }
  
  InputBorder _getFocusedErrorBorder() {
    return switch (widget.variant) {
      AppTextFieldVariant.filled => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      AppTextFieldVariant.outlined => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      AppTextFieldVariant.underlined => const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
    };
  }
  
  InputBorder _getDisabledBorder(bool isDark) {
    final borderColor = isDark ? AppColors.grey700 : AppColors.grey300;
    
    return switch (widget.variant) {
      AppTextFieldVariant.filled => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          borderSide: BorderSide.none,
        ),
      AppTextFieldVariant.outlined => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          borderSide: BorderSide(color: borderColor),
        ),
      AppTextFieldVariant.underlined => UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
    };
  }
}
