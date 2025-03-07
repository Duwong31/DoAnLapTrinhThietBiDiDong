import 'package:flutter/material.dart';
import 'package:soundflow/core/configs/theme/app_colors.dart';

class BasicButton extends StatelessWidget{
  final VoidCallback onPressed;
  final String title;
  final double ? height;
  const BasicButton({
    required this.onPressed,
    required this.title,
    this.height,
    super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 48)
      ),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.lightBackground
        ),
      ),
    );
  }
}