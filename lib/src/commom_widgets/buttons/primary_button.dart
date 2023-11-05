import 'package:flutter/material.dart';
import 'package:racha_conta/src/commom_widgets/buttons/button_loading_widgte.dart';

class MyPrimaryButton extends StatelessWidget {
  const MyPrimaryButton(
    this.text,
    this.onPressed, {
    this.isLoading = false,
    this.isFullWidth = false,
    this.width = 100,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: isLoading
            ? const ButtonLoadingWidget()
            : Text(
                text.toUpperCase(),
                style: const TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}
