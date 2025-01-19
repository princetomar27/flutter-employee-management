import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/navigation_constants.dart';
import '../../../../presentation/dialogs/info_alert_dialog.dart';
import '../../../../presentation/paddings.dart';

class HomeScreenMenuCardItem extends StatelessWidget {
  final IconData iconPath;
  final String title;
  final VoidCallback? onTap;

  const HomeScreenMenuCardItem({
    Key? key,
    required this.iconPath,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            showInfoAlertDialog(
              context: context,
              title: "Feature In-Progress",
              description: "This feature is to be implemented",
              onTap: () {
                NavigationHelper.goBack(context);
              },
            );
          },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconPath,
                size: 48,
                color: generateRandomTextColor(),
              ),
              padding10,
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.buttonColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color generateRandomTextColor() {
  Random random = Random();
  List<Color> palette = const [
    Color(0xFFFFBF00),
    Color(0xFFD72638),
    Color(0xFF1B998B),
    Color(0xFF3A86FF),
    Color(0xFF8338EC),
    Color(0xFFFF006E),
    Color(0xFFFFBE0B),
    Color(0xFFFB5607),
    Color(0xFF2EC4B6),
    Color(0xFF6A0572),
  ];

  return palette[random.nextInt(palette.length)];
}
