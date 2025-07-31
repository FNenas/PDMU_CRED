import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AcademicInfoWidget extends StatelessWidget {
  final Map<String, dynamic> studentData;
  final bool isEditing;
  final Function(String, String)? onFieldChanged;

  const AcademicInfoWidget({
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
              'Información Académica',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildInfoRow(
              'Número de Matrícula',
              studentData['enrollmentNumber'] ?? '',
              'enrollmentNumber',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Año Académico',
              studentData['academicYear'] ?? '',
              'academicYear',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Grado',
              studentData['grade'] ?? '',
              'grade',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Grupo',
              studentData['group'] ?? '',
              'group',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Fecha de Inscripción',
              studentData['enrollmentDate'] ?? '',
              'enrollmentDate',
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Text(
                  'Estado de Inscripción',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(studentData['status'] ?? ''),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    studentData['status'] ?? 'Pendiente',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
      case 'inscrito':
        return AppTheme.getStatusColor('enrolled');
      case 'pendiente':
        return AppTheme.getStatusColor('pending');
      case 'inactivo':
        return AppTheme.getStatusColor('inactive');
      default:
        return AppTheme.getStatusColor('pending');
    }
  }
}
