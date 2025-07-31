import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MilitaryRequirementsSection extends StatelessWidget {
  final String? militaryRank;
  final String? disciplinaryRecord;
  final bool medicalClearance;
  final bool uniformSize;
  final Function(String?) onMilitaryRankChanged;
  final Function(String?) onDisciplinaryRecordChanged;
  final Function(bool) onMedicalClearanceChanged;
  final Function(bool) onUniformSizeChanged;
  final Map<String, String?> validationErrors;

  const MilitaryRequirementsSection({
    super.key,
    required this.militaryRank,
    required this.disciplinaryRecord,
    required this.medicalClearance,
    required this.uniformSize,
    required this.onMilitaryRankChanged,
    required this.onDisciplinaryRecordChanged,
    required this.onMedicalClearanceChanged,
    required this.onUniformSizeChanged,
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
                  iconName: 'military_tech',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Requisitos Militares',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildDropdownField(
              label: 'Rango Militar Inicial *',
              value: militaryRank,
              items: ['Cadete', 'Aspirante', 'Recluta', 'Soldado'],
              onChanged: onMilitaryRankChanged,
              hint: 'Selecciona el rango inicial',
            ),
            SizedBox(height: 2.h),
            _buildDropdownField(
              label: 'Registro Disciplinario *',
              value: disciplinaryRecord,
              items: ['Excelente', 'Bueno', 'Regular', 'Requiere Atención'],
              onChanged: onDisciplinaryRecordChanged,
              hint: 'Selecciona el estado disciplinario',
            ),
            SizedBox(height: 2.h),
            Text(
              'Documentación Requerida',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            SizedBox(height: 1.h),
            _buildCheckboxTile(
              title: 'Certificado Médico Completo',
              subtitle: 'Examen médico general y aptitud física',
              value: medicalClearance,
              onChanged: onMedicalClearanceChanged,
            ),
            _buildCheckboxTile(
              title: 'Medidas para Uniforme',
              subtitle: 'Tallas tomadas para uniforme militar',
              value: uniformSize,
              onChanged: onUniformSizeChanged,
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
          ),
        );
      }).toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  Widget _buildCheckboxTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return CheckboxListTile(
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.textMediumEmphasisLight,
        ),
      ),
      value: value,
      onChanged: (bool? newValue) => onChanged(newValue ?? false),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
