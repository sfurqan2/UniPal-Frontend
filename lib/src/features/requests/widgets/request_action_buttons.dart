import 'package:flutter/material.dart';

// Helpers
import '../../../helpers/constants/app_colors.dart';
import '../../../helpers/constants/app_typography.dart';

// Widgets
import '../../shared/widgets/custom_text_button.dart';

class RequestActionButtons extends StatelessWidget {
  final bool isReceived;

  const RequestActionButtons({
    Key? key,
    required this.isReceived,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: isReceived
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.center,
      children: [
        // Secondary
        CustomTextButton.outlined(
          width: 80,
          height: 30,
          onPressed: () {},
          border: Border.all(
            color: AppColors.primaryColor,
            width: 1.2,
          ),
          child: Center(
            child: Text(
              isReceived ? 'Reject' : 'Cancel',
              style: AppTypography.secondary.subtitle13.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),

        // Primary
        if (isReceived)
          CustomTextButton.gradient(
            width: 80,
            height: 30,
            onPressed: () {},
            gradient: AppColors.buttonGradientPurple,
            child: Center(
              child: Text(
                'Accept',
                style: AppTypography.secondary.subtitle13.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
