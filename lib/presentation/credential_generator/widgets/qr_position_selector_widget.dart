import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QrPositionSelectorWidget extends StatelessWidget {
  final String selectedPosition;
  final double qrSize;
  final Function(String) onPositionChanged;
  final Function(double) onSizeChanged;

  const QrPositionSelectorWidget({
    super.key,
    required this.selectedPosition,
    required this.qrSize,
    required this.onPositionChanged,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final positions = [
      {
        'id': 'bottom-right',
        'name': 'Inferior Derecha',
        'icon': 'south_east',
      },
      {
        'id': 'center-bottom',
        'name': 'Centro Inferior',
        'icon': 'south',
      },
      {
        'id': 'back-side',
        'name': 'Lado Posterior',
        'icon': 'flip_to_back',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Posición del Código QR',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: positions.map((position) {
            final isSelected = selectedPosition == position['id'];

            return GestureDetector(
              onTap: () => onPositionChanged(position['id'] as String),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: position['icon'] as String,
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      position['name'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 3.h),
        Text(
          'Tamaño del QR',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'photo_size_select_small',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            Expanded(
              child: Slider(
                value: qrSize,
                min: 0.5,
                max: 2.0,
                divisions: 15,
                activeColor: AppTheme.lightTheme.colorScheme.primary,
                inactiveColor: AppTheme.lightTheme.colorScheme.outline,
                onChanged: onSizeChanged,
              ),
            ),
            CustomIconWidget(
              iconName: 'photo_size_select_large',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
        Center(
          child: Text(
            '${(qrSize * 100).toInt()}%',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
