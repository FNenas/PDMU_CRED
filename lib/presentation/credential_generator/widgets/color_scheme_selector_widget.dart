import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ColorSchemeSelectorWidget extends StatelessWidget {
  final String selectedScheme;
  final Function(String) onSchemeChanged;

  const ColorSchemeSelectorWidget({
    super.key,
    required this.selectedScheme,
    required this.onSchemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorSchemes = [
      {
        'id': 'institutional',
        'name': 'Institucional',
        'description': 'Colores oficiales',
        'primary': AppTheme.lightTheme.colorScheme.primary,
        'secondary': AppTheme.lightTheme.colorScheme.secondary,
      },
      {
        'id': 'academic',
        'name': 'Académico',
        'description': 'Azul y verde',
        'primary': Color(0xFF1565C0),
        'secondary': Color(0xFF2E7D32),
      },
      {
        'id': 'military',
        'name': 'Militar',
        'description': 'Azul marino y café',
        'primary': Color(0xFF0D47A1),
        'secondary': Color(0xFF8B4513),
      },
      {
        'id': 'classic',
        'name': 'Clásico',
        'description': 'Escala de grises',
        'primary': Color(0xFF424242),
        'secondary': Color(0xFF757575),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Esquema de Colores',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 2.5,
          ),
          itemCount: colorSchemes.length,
          itemBuilder: (context, index) {
            final scheme = colorSchemes[index];
            final isSelected = selectedScheme == scheme['id'];

            return GestureDetector(
              onTap: () => onSchemeChanged(scheme['id'] as String),
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildColorCircle(scheme['primary'] as Color),
                        SizedBox(width: 2.w),
                        _buildColorCircle(scheme['secondary'] as Color),
                        Spacer(),
                        if (isSelected)
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      scheme['name'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      scheme['description'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildColorCircle(Color color) {
    return Container(
      width: 6.w,
      height: 6.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
    );
  }
}
