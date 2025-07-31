import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContactInfoSection extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController emergencyContactController;
  final TextEditingController emergencyPhoneController;
  final Map<String, String?> validationErrors;

  const ContactInfoSection({
    super.key,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.emergencyContactController,
    required this.emergencyPhoneController,
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
                  iconName: 'contact_phone',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Información de Contacto',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              controller: phoneController,
              label: 'Teléfono *',
              hint: '55 1234 5678',
              keyboardType: TextInputType.phone,
              errorText: validationErrors['phone'],
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              controller: emailController,
              label: 'Correo Electrónico *',
              hint: 'estudiante@ejemplo.com',
              keyboardType: TextInputType.emailAddress,
              errorText: validationErrors['email'],
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              controller: addressController,
              label: 'Dirección *',
              hint: 'Calle, Número, Colonia, CP',
              keyboardType: TextInputType.streetAddress,
              errorText: validationErrors['address'],
              maxLines: 2,
            ),
            SizedBox(height: 2.h),
            Text(
              'Contacto de Emergencia',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            SizedBox(height: 1.h),
            _buildTextField(
              controller: emergencyContactController,
              label: 'Nombre del Contacto *',
              hint: 'Nombre completo del tutor/padre',
              keyboardType: TextInputType.name,
              errorText: validationErrors['emergencyContact'],
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              controller: emergencyPhoneController,
              label: 'Teléfono de Emergencia *',
              hint: '55 9876 5432',
              keyboardType: TextInputType.phone,
              errorText: validationErrors['emergencyPhone'],
            ),
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
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
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
      ),
    );
  }
}
