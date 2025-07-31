import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PersonalInfoSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController curpController;
  final DateTime? birthDate;
  final String? gender;
  final VoidCallback onBirthDateTap;
  final Function(String?) onGenderChanged;
  final Map<String, String?> validationErrors;

  const PersonalInfoSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.curpController,
    required this.birthDate,
    required this.gender,
    required this.onBirthDateTap,
    required this.onGenderChanged,
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
                  iconName: 'person',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Información Personal',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              controller: firstNameController,
              label: 'Nombre(s) *',
              hint: 'Ingresa el nombre del estudiante',
              keyboardType: TextInputType.name,
              errorText: validationErrors['firstName'],
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              controller: lastNameController,
              label: 'Apellidos *',
              hint: 'Ingresa los apellidos del estudiante',
              keyboardType: TextInputType.name,
              errorText: validationErrors['lastName'],
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              controller: curpController,
              label: 'CURP *',
              hint: 'ABCD123456HDFGHI01',
              keyboardType: TextInputType.text,
              errorText: validationErrors['curp'],
              maxLength: 18,
            ),
            SizedBox(height: 2.h),
            _buildDateField(context),
            SizedBox(height: 2.h),
            _buildGenderField(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType keyboardType,
    String? errorText,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            errorText: errorText,
            suffixIcon: errorText == null && controller.text.isNotEmpty
                ? CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.successLight,
                    size: 20,
                  )
                : null,
            counterText: '',
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    return InkWell(
      onTap: onBirthDateTap,
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
                    'Fecha de Nacimiento *',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    birthDate != null
                        ? '${birthDate!.day.toString().padLeft(2, '0')}/${birthDate!.month.toString().padLeft(2, '0')}/${birthDate!.year}'
                        : 'Selecciona la fecha de nacimiento',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: birthDate != null
                          ? AppTheme.textHighEmphasisLight
                          : AppTheme.textDisabledLight,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'calendar_today',
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Género *',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text('Masculino'),
                value: 'M',
                groupValue: gender,
                onChanged: onGenderChanged,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('Femenino'),
                value: 'F',
                groupValue: gender,
                onChanged: onGenderChanged,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
