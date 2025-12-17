import 'package:flutter/material.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';



/// Mixin para funcionalidades comuns de formulários

mixin FormMixin<T extends StatefulWidget> on State<T> {

  /// GlobalKey do formulrio
  /// GlobalKey do formulário

  late final GlobalKey<FormState> formKey;



  /// Flag de loading durante submit

  bool isSubmitting = false;



  /// Flag indicando se formulrio foi modificado
  /// Flag indicando se formulário foi modificado

  bool isDirty = false;



  /// Mensagem de erro do formulrio
  /// Mensagem de erro do formulário

  String? formError;



  @override

  void initState() {

    super.initState();

    formKey = GlobalKey<FormState>();

  }



  /// Marca o formulrio como modificado
  /// Marca o formulário como modificado

  void markDirty() {

    if (!isDirty) {

      setState(() {

        isDirty = true;

      });

    }

  }



  /// Valida o formulrio

  bool validate() {

    setState(() {

      formError = null;

    });

    return formKey.currentState?.validate() ?? false;

  }



  /// Salva os dados do formulrio

  void saveForm() {

    formKey.currentState?.save();

  }



  /// Reseta o formulrio

  void resetForm() {

    formKey.currentState?.reset();

    setState(() {

      isDirty = false;

      formError = null;

    });

  }



  /// Define erro no formulrio

  void setFormError(String error) {

    setState(() {

      formError = error;

    });

  }



  /// Limpa erro do formulrio

  void clearFormError() {

    setState(() {

      formError = null;

    });

  }



  /// Submete o formulrio

  Future<void> submitForm(Future<void> Function() onSubmit) async {

    if (isSubmitting) return;



    if (!validate()) return;



    saveForm();



    setState(() {

      isSubmitting = true;

      formError = null;

    });



    try {

      await onSubmit();

      setState(() {

        isDirty = false;

      });

    } catch (e) {

      setState(() {

        formError = e.toString();

      });

    } finally {

      if (mounted) {

        setState(() {

          isSubmitting = false;

        });

      }

    }

  }



  /// Verifica se pode sair da tela (formulrio no salvo)

  Future<bool> canPop() async {

    if (!isDirty) return true;



    final result = await showDialog<bool>(

      context: context,

      builder: (context) => AlertDialog(

        title: const Text('Descartar alteraes?'),

        content: const Text(

          'Voc tem alteraes no salvas. Deseja descartar-las?',

        ),

        actions: [

          TextButton(

            onPressed: () => Navigator.of(context).pop(false),

            child: const Text('Cancelar'),

          ),

          TextButton(

            onPressed: () => Navigator.of(context).pop(true),

            child: const Text('Descartar'),

          ),

        ],

      ),

    );



    return result ?? false;

  }



  /// Envolve contedo com Form widget

  Widget buildForm({

    required Widget child,

    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,

    VoidCallback? onChanged,

  }) {

    return Form(

      key: formKey,

      autovalidateMode: autovalidateMode,

      onChanged: () {

        markDirty();

        onChanged?.call();

      },

      child: child,

    );

  }



  /// Constri boto de submit

  Widget buildSubmitButton({

    required String label,

    required Future<void> Function() onSubmit,

    IconData? icon,

    bool enabled = true,

  }) {

    final colors = ThemeColors.of(context);

    return FilledButton(

      onPressed: enabled && !isSubmitting

          ? () => submitForm(onSubmit)

          : null,

      child: isSubmitting

          ? SizedBox(

              width: 20,

              height: 20,

              child: CircularProgressIndicator(

                strokeWidth: 2,

                color: colors.surface,

              ),

            )

          : Row(

              mainAxisSize: MainAxisSize.min,

              children: [

                if (icon != null) ...[

                  Icon(icon, size: 18),

                  const SizedBox(width: 8),

                ],

                Text(label),

              ],

            ),

    );

  }



  /// Constri widget de erro do formulrio

  Widget? buildFormError() {

    if (formError == null) return null;



    final colors = ThemeColors.of(context);

    return Container(

      padding: const EdgeInsets.all(12),

      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(

        color: colors.redPastel,

        borderRadius: BorderRadius.circular(8),

        border: Border.all(color: Color.alphaBlend(colors.surface.withValues(alpha: 0.7), colors.redMain)),

      ),

      child: Row(

        children: [

          Icon(Icons.error_outline, color: colors.redMain, size: 20),

          const SizedBox(width: 8),

          Expanded(

            child: Text(

              formError!,

              style: TextStyle(color: colors.redMain),

            ),

          ),

          IconButton(

            onPressed: clearFormError,

            icon: const Icon(Icons.close, size: 18),

            color: colors.redMain,

            padding: EdgeInsets.zero,

            constraints: const BoxConstraints(),

          ),

        ],

      ),

    );

  }

}



/// Mixin para formulrio com validao em tempo real

mixin LiveValidationFormMixin<T extends StatefulWidget> on FormMixin<T> {

  /// Campos com erro

  final Map<String, String?> fieldErrors = {};



  /// Valida campo especfico

  void validateField(String fieldName, String? Function(String?) validator, String? value) {

    final error = validator(value);

    setState(() {

      fieldErrors[fieldName] = error;

    });

  }



  /// Retorna se campo tem erro

  bool hasFieldError(String fieldName) {

    return fieldErrors[fieldName] != null;

  }



  /// Retorna erro do campo

  String? getFieldError(String fieldName) {

    return fieldErrors[fieldName];

  }



  /// Limpa erro do campo

  void clearFieldError(String fieldName) {

    setState(() {

      fieldErrors.remove(fieldName);

    });

  }



  /// Retorna se todos os campos so vlidos

  bool get areAllFieldsValid {

    return fieldErrors.values.every((error) => error == null);

  }

}



/// Mixin para formulrio multi-step

mixin StepFormMixin<T extends StatefulWidget> on State<T> {

  /// Step atual

  int currentStep = 0;



  /// Total de steps

  int get totalSteps;



  /// GlobalKeys para cada step

  late final List<GlobalKey<FormState>> stepFormKeys;



  @override

  void initState() {

    super.initState();

    stepFormKeys = List.generate(

      totalSteps,

      (_) => GlobalKey<FormState>(),

    );

  }



  /// Valida step atual

  bool validateCurrentStep() {

    return stepFormKeys[currentStep].currentState?.validate() ?? false;

  }



  /// Salva step atual

  void saveCurrentStep() {

    stepFormKeys[currentStep].currentState?.save();

  }



  /// Avana para prximo step

  void nextStep() {

    if (!validateCurrentStep()) return;

    saveCurrentStep();



    if (currentStep < totalSteps - 1) {

      setState(() {

        currentStep++;

      });

    }

  }



  /// Volta para step anterior

  void previousStep() {

    if (currentStep > 0) {

      setState(() {

        currentStep--;

      });

    }

  }



  /// Vai para step especfico

  void goToStep(int step) {

    if (step >= 0 && step < totalSteps) {

      // Valida todos os steps anteriores

      for (int i = 0; i < step; i++) {

        if (!(stepFormKeys[i].currentState?.validate() ?? true)) {

          setState(() {

            currentStep = i;

          });

          return;

        }

      }

      setState(() {

        currentStep = step;

      });

    }

  }



  /// Retorna se  primeiro step

  bool get isFirstStep => currentStep == 0;



  /// Retorna se  Último step

  bool get isLastStep => currentStep == totalSteps - 1;



  /// Retorna progresso (0.0 a 1.0)

  double get progress => (currentStep + 1) / totalSteps;



  /// Envolve contedo do step com Form

  Widget buildStepForm({

    required Widget child,

    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,

  }) {

    return Form(

      key: stepFormKeys[currentStep],

      autovalidateMode: autovalidateMode,

      child: child,

    );

  }



  /// Constri indicador de progresso dos steps

  Widget buildStepIndicator({

    List<String>? labels,

  }) {

    final colors = ThemeColors.of(context);

    return Column(

      children: [

        // Barra de progresso

        ClipRRect(

          borderRadius: BorderRadius.circular(4),

          child: LinearProgressIndicator(

            value: progress,

            minHeight: 4,

          ),

        ),

        const SizedBox(height: 8),

        // Labels ou contador

        Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            if (labels != null)

              Text(

                labels[currentStep],

                style: const TextStyle(fontWeight: FontWeight.w500),

              )

            else

              Text('Etapa ${currentStep + 1}'),

            Text(

              '${currentStep + 1} de $totalSteps',

              style: TextStyle(

                color: colors.grey600,

                fontSize: 12,

              ),

            ),

          ],

        ),

      ],

    );

  }



  /// Constri botes de navegao

  Widget buildStepButtons({

    required VoidCallback onComplete,

    String nextLabel = 'Prximo',

    String previousLabel = 'Anterior',

    String completeLabel = 'Finalizar',

    bool showPrevious = true,

  }) {

    return Row(

      children: [

        if (showPrevious && !isFirstStep)

          Expanded(

            child: OutlinedButton(

              onPressed: previousStep,

              child: Text(previousLabel),

            ),

          ),

        if (showPrevious && !isFirstStep)

          const SizedBox(width: 16),

        Expanded(

          child: FilledButton(

            onPressed: isLastStep

                ? () {

                    if (validateCurrentStep()) {

                      saveCurrentStep();

                      onComplete();

                    }

                  }

                : nextStep,

            child: Text(isLastStep ? completeLabel : nextLabel),

          ),

        ),

      ],

    );

  }

}













