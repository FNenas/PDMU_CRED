import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AcademicInfoSection extends StatelessWidget {
  final TextEditingController enrollmentController;
  final String? selectedState;
  final String? academicYear;
  final String? gradeLevel;
  final VoidCallback onStateSelector;
  final Function(String?) onAcademicYearChanged;
  final Function(String?) onGradeLevelChanged;
  final VoidCallback onGenerateEnrollment;
  final Map<String, String?> validationErrors;

  const AcademicInfoSection({
    super.key,
    required this.enrollmentController,
    required this.selectedState,
    required this.academicYear,
    required this.gradeLevel,
    required this.onStateSelector,
    required this.onAcademicYearChanged,
    required this.onGradeLevelChanged,
    required this.onGenerateEnrollment,
    required this.validationErrors,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'school',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Información Académica',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: enrollmentController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Número de Matrícula *',
                      hintText: 'MIL-2025-001',
                      errorText: validationErrors['enrollment'],
                      suffixIcon: validationErrors['enrollment'] == null &&
                              enrollmentController.text.isNotEmpty
                          ? CustomIconWidget(
                              iconName: 'check_circle',
                              color: AppTheme.successLight,
                              size: 20,
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: onGenerateEnrollment,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    child: CustomIconWidget(
                      iconName: 'refresh',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildStateSelector(context),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Año Académico *',
                    value: academicYear,
                    items: ['2024-2025', '2025-2026', '2026-2027'],
                    onChanged: onAcademicYearChanged,
                    hint: 'Selecciona el año',
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Grado *',
                    value: gradeLevel,
                    items: [
                      '1° Secundaria',
                      '2° Secundaria',
                      '3° Secundaria',
                      '1° Preparatoria',
                      '2° Preparatoria',
                      '3° Preparatoria'
                    ],
                    onChanged: onGradeLevelChanged,
                    hint: 'Selecciona el grado',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateSelector(BuildContext context) {
    return InkWell(
      onTap: onStateSelector,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppTheme.lightTheme.dividerColor,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estado *',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    selectedState ?? 'Selecciona el estado',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: selectedState != null
                          ? AppTheme.textHighEmphasisLight
                          : AppTheme.textDisabledLight,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hint,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }
}
