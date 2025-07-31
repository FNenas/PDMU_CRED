import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricPromptWidget extends StatelessWidget {
  final VoidCallback onBiometricLogin;
  final bool isAvailable;

  const BiometricPromptWidget({
    super.key,
    required this.onBiometricLogin,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    if (!isAvailable) return SizedBox.shrink();

    return Column(
      children: [
        SizedBox(height: 3.h),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'O',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        OutlinedButton.icon(
          onPressed: () {
            HapticFeedback.lightImpact();
            onBiometricLogin();
          },
          icon: CustomIconWidget(
            iconName: 'fingerprint',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 5.w,
          ),
          label: Text(
            'Autenticación Biométrica',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}
