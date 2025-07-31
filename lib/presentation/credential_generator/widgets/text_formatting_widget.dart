import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TextFormattingWidget extends StatelessWidget {
  final double fontSize;
  final Function(double) onFontSizeChanged;

  const TextFormattingWidget({
    super.key,
    required this.fontSize,
    required this.onFontSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Formato de Texto',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        _buildFontSizeControl(),
        SizedBox(height: 2.h),
        _buildAccessibilityInfo(),
      ],
    );
  }

  Widget _buildFontSizeControl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tamaño de Fuente',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${fontSize.toStringAsFixed(1)}x',
                style: AppTheme.getDataTextStyle(
                  isLight: true,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'text_decrease',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            Expanded(
              child: Slider(
                value: fontSize,
                min: 0.8,
                max: 1.5,
                divisions: 14,
                activeColor: AppTheme.lightTheme.colorScheme.primary,
                inactiveColor: AppTheme.lightTheme.colorScheme.outline,
                onChanged: onFontSizeChanged,
              ),
            ),
            CustomIconWidget(
              iconName: 'text_increase',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pequeño',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'Normal',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'Grande',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccessibilityInfo() {
    String accessibilityLevel = _getAccessibilityLevel();
    Color levelColor = _getAccessibilityColor();

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: levelColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: levelColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'accessibility',
            color: levelColor,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cumplimiento de Accesibilidad',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: levelColor,
                  ),
                ),
                Text(
                  accessibilityLevel,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getAccessibilityLevel() {
    if (fontSize >= 1.2) {
      return 'Excelente - Cumple estándares AA+';
    } else if (fontSize >= 1.0) {
      return 'Bueno - Cumple estándares AA';
    } else if (fontSize >= 0.9) {
      return 'Aceptable - Cumple estándares A';
    } else {
      return 'Mejorable - Considere aumentar el tamaño';
    }
  }

  Color _getAccessibilityColor() {
    if (fontSize >= 1.2) {
      return AppTheme.getStatusColor('confirmed');
    } else if (fontSize >= 1.0) {
      return AppTheme.getStatusColor('active');
    } else if (fontSize >= 0.9) {
      return AppTheme.getStatusColor('pending');
    } else {
      return AppTheme.getStatusColor('error');
    }
  }
}
