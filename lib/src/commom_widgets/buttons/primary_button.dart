import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import 'button_loading_widgte.dart';

// Widget personalizado para um botão primário.
class MyPrimaryButton extends StatelessWidget {
  // Construtor que aceita parâmetros para personalizar o botão.
  const MyPrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width = 100.0,
  }) : super(key: key);

  // Texto que será exibido no botão.
  final String text;
  // Ação a ser executada quando o botão for pressionado.
  final VoidCallback onPressed;
  // Indica se o botão está em estado de carregamento.
  final bool isLoading;
  // Determina se o botão deve ocupar a largura total disponível.
  final bool isFullWidth;
  // Define a largura do botão quando `isFullWidth` é `false`.
  final double width;

  // Constrói a interface visual do botão.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Define a largura com base na propriedade `isFullWidth`.
      height: 60,
      width: isFullWidth ? double.infinity : width,
      child: ElevatedButton(
        onPressed: onPressed,
        // Exibe um widget de carregamento se `isLoading` for verdadeiro,
        // caso contrário, exibe o texto fornecido.
        child: isLoading
            ? const ButtonLoadingWidget()
            : Text(
                text.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: whiteColor),
              ),
      ),
    );
  }
}
