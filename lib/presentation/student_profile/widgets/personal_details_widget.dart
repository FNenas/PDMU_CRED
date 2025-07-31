import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PersonalDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> studentData;
  final bool isEditing;
  final Function(String, String)? onFieldChanged;

  const PersonalDetailsWidget({
    Key? key,
    required this.studentData,
    this.isEditing = false,
    this.onFieldChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Datos Personales',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildInfoRow(
              'Nombre Completo',
              studentData['fullName'] ?? '',
              'fullName',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'CURP',
              studentData['curp'] ?? '',
              'curp',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Fecha de Nacimiento',
              studentData['birthDate'] ?? '',
              'birthDate',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Lugar de Nacimiento',
              studentData['birthPlace'] ?? '',
              'birthPlace',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Género',
              studentData['gender'] ?? '',
              'gender',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Tipo de Sangre',
              studentData['bloodType'] ?? '',
              'bloodType',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, String fieldKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 0.5.h),
        isEditing
            ? TextFormField(
                initialValue: value,
                onChanged: (newValue) =>
                    onFieldChanged?.call(fieldKey, newValue),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.h,
                  ),
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              )
            : GestureDetector(
                onLongPress: () {
                  // Copy to clipboard functionality
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Text(
                    value.isNotEmpty ? value : 'No especificado',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: value.isNotEmpty
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
