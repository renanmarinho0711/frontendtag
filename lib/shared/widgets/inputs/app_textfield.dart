import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campo de texto customizado do app
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.prefix,
    this.suffix,
    this.inputFormatters,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  /// Factory para campo de e-mail
  factory AppTextField.email({
    TextEditingController? controller,
    FocusNode? focusNode,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    bool enabled = true,
    bool autofocus = false,
  }) =>
      AppTextField(
        label: 'E-mail',
        hint: 'seu@email.com',
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        enabled: enabled,
        autofocus: autofocus,
        keyboardType: TextInputType.emailAddress,
        textCapitalization: TextCapitalization.none,
        prefixIcon: Icons.email_outlined,
      );

  /// Factory para campo de telefone
  factory AppTextField.phone({
    TextEditingController? controller,
    FocusNode? focusNode,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    bool enabled = true,
  }) =>
      AppTextField(
        label: 'Telefone',
        hint: '(00) 00000-0000',
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        enabled: enabled,
        keyboardType: TextInputType.phone,
        prefixIcon: Icons.phone_outlined,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          _PhoneInputFormatter(),
        ],
      );

  /// Factory para campo de moeda
  factory AppTextField.currency({
    String? label,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    bool enabled = true,
  }) =>
      AppTextField(
        label: label ?? 'Valor',
        hint: 'R\$ 0,00',
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        enabled: enabled,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        prefixIcon: Icons.attach_money,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
        ],
      );

  /// Factory para campo numérico
  factory AppTextField.number({
    String? label,
    String? hint,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    bool enabled = true,
    bool allowDecimal = false,
    IconData? prefixIcon,
  }) =>
      AppTextField(
        label: label,
        hint: hint,
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        enabled: enabled,
        keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
        prefixIcon: prefixIcon,
        inputFormatters: [
          if (allowDecimal)
            FilteringTextInputFormatter.allow(RegExp(r'[\d,.]'))
          else
            FilteringTextInputFormatter.digitsOnly,
        ],
      );

  /// Factory para campo de busca
  factory AppTextField.search({
    TextEditingController? controller,
    FocusNode? focusNode,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    String hint = 'Buscar...',
    Widget? suffix,
  }) =>
      AppTextField(
        hint: hint,
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        prefixIcon: Icons.search,
        suffix: suffix,
        textInputAction: TextInputAction.search,
      );

  /// Factory para campo de texto longo
  factory AppTextField.multiline({
    String? label,
    String? hint,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool enabled = true,
    int maxLines = 4,
    int? maxLength,
  }) =>
      AppTextField(
        label: label,
        hint: hint,
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        onChanged: onChanged,
        enabled: enabled,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        textCapitalization: TextCapitalization.sentences,
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        prefix: prefix,
        suffix: suffix,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}

/// Formatador de telefone brasileiro
class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String formatted;
    if (text.length <= 2) {
      formatted = '($text';
    } else if (text.length <= 6) {
      formatted = '(${text.substring(0, 2)}) ${text.substring(2)}';
    } else if (text.length <= 10) {
      formatted =
          '(${text.substring(0, 2)}) ${text.substring(2, 6)}-${text.substring(6)}';
    } else {
      formatted =
          '(${text.substring(0, 2)}) ${text.substring(2, 7)}-${text.substring(7, 11)}';
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}



