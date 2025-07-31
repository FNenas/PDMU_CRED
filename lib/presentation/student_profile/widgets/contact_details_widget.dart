import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ContactDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> studentData;
  final bool isEditing;
  final Function(String, String)? onFieldChanged;

  const ContactDetailsWidget({
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
              'Datos de Contacto',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildInfoRow(
              'Dirección',
              studentData['address'] ?? '',
              'address',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Estado',
              studentData['state'] ?? '',
              'state',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Ciudad',
              studentData['city'] ?? '',
              'city',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Código Postal',
              studentData['postalCode'] ?? '',
              'postalCode',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Teléfono',
              studentData['phone'] ?? '',
              'phone',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Email',
              studentData['email'] ?? '',
              'email',
            ),
            SizedBox(height: 2.h),
            Text(
              'Contacto de Emergencia',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Nombre del Tutor',
              studentData['emergencyContactName'] ?? '',
              'emergencyContactName',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Teléfono de Emergencia',
              studentData['emergencyContactPhone'] ?? '',
              'emergencyContactPhone',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Relación',
              studentData['emergencyContactRelation'] ?? '',
              'emergencyContactRelation',
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
            : Container(
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
      ],
    );
  }
}
