import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CredentialPreviewWidget extends StatelessWidget {
  final Map<String, dynamic> studentData;
  final String selectedTemplate;
  final String qrPosition;
  final double qrSize;
  final double fontSize;
  final String colorScheme;
  final bool showSignature;
  final String signaturePosition;

  const CredentialPreviewWidget({
    super.key,
    required this.studentData,
    required this.selectedTemplate,
    required this.qrPosition,
    required this.qrSize,
    required this.fontSize,
    required this.colorScheme,
    required this.showSignature,
    required this.signaturePosition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      height: 55.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            _buildCredentialBackground(),
            _buildCredentialContent(),
            if (qrPosition != 'back-side') _buildQRCode(),
            if (showSignature) _buildSignature(),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialBackground() {
    Color primaryColor = _getSchemeColor('primary');
    Color secondaryColor = _getSchemeColor('secondary');

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: 0.1),
            secondaryColor.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: selectedTemplate == 'military'
          ? _buildMilitaryPattern()
          : selectedTemplate == 'academic'
              ? _buildAcademicPattern()
              : _buildStandardPattern(),
    );
  }

  Widget _buildMilitaryPattern() {
    return Stack(
      children: [
        Positioned(
          top: -20,
          right: -20,
          child: CustomIconWidget(
            iconName: 'shield',
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            size: 120,
          ),
        ),
        Positioned(
          bottom: -30,
          left: -30,
          child: CustomIconWidget(
            iconName: 'star',
            color:
                AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
            size: 100,
          ),
        ),
      ],
    );
  }

  Widget _buildAcademicPattern() {
    return Stack(
      children: [
        Positioned(
          top: -15,
          right: -15,
          child: CustomIconWidget(
            iconName: 'school',
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            size: 100,
          ),
        ),
        Positioned(
          bottom: -25,
          left: -25,
          child: CustomIconWidget(
            iconName: 'menu_book',
            color:
                AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
            size: 90,
          ),
        ),
      ],
    );
  }

  Widget _buildStandardPattern() {
    return Stack(
      children: [
        Positioned(
          top: -10,
          right: -10,
          child: CustomIconWidget(
            iconName: 'badge',
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            size: 80,
          ),
        ),
      ],
    );
  }

  Widget _buildCredentialContent() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 3.h),
          _buildStudentInfo(),
          Spacer(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: selectedTemplate == 'military'
                  ? 'shield'
                  : selectedTemplate == 'academic'
                      ? 'school'
                      : 'badge',
              color: _getSchemeColor('primary'),
              size: 32,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Escuela Militar Nacional',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontSize: (fontSize * 0.9).sp,
                      fontWeight: FontWeight.bold,
                      color: _getSchemeColor('primary'),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    selectedTemplate == 'military'
                        ? 'Credencial Militar'
                        : selectedTemplate == 'academic'
                            ? 'Certificado Académico'
                            : 'Identificación Estudiantil',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontSize: (fontSize * 0.7).sp,
                      color: _getSchemeColor('secondary'),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          height: 1,
          width: double.infinity,
          color: _getSchemeColor('primary').withValues(alpha: 0.3),
        ),
      ],
    );
  }

  Widget _buildStudentInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStudentPhoto(),
        SizedBox(width: 4.w),
        Expanded(
          child: _buildStudentDetails(),
        ),
      ],
    );
  }

  Widget _buildStudentPhoto() {
    return Container(
      width: 20.w,
      height: 25.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getSchemeColor('primary'),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: studentData['photo'] != null
            ? CustomImageWidget(
                imageUrl: studentData['photo'] as String,
                width: 20.w,
                height: 25.w,
                fit: BoxFit.cover,
              )
            : Container(
                color: AppTheme.lightTheme.colorScheme.surface,
                child: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.outline,
                  size: 40,
                ),
              ),
      ),
    );
  }

  Widget _buildStudentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Nombre:', studentData['fullName'] ?? 'N/A'),
        SizedBox(height: 1.h),
        _buildDetailRow('Matrícula:', studentData['enrollmentNumber'] ?? 'N/A'),
        SizedBox(height: 1.h),
        _buildDetailRow('Estado:', studentData['state'] ?? 'N/A'),
        SizedBox(height: 1.h),
        _buildDetailRow('Año:', studentData['academicYear'] ?? 'N/A'),
        SizedBox(height: 1.h),
        _buildDetailRow('Estado:', studentData['status'] ?? 'Activo'),
        if (selectedTemplate == 'military') ...[
          SizedBox(height: 1.h),
          _buildDetailRow('Rango:', studentData['rank'] ?? 'Cadete'),
        ],
        if (selectedTemplate == 'academic') ...[
          SizedBox(height: 1.h),
          _buildDetailRow('Promedio:', studentData['gpa'] ?? '9.5'),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 18.w,
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontSize: (fontSize * 0.6).sp,
              fontWeight: FontWeight.w500,
              color: _getSchemeColor('secondary'),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontSize: (fontSize * 0.6).sp,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Container(
          height: 1,
          width: double.infinity,
          color: _getSchemeColor('primary').withValues(alpha: 0.3),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Válida hasta: 31/12/2025',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontSize: (fontSize * 0.5).sp,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'ID: ${studentData['id'] ?? '001'}',
              style: AppTheme.getDataTextStyle(
                isLight: true,
                fontSize: (fontSize * 0.5).sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQRCode() {
    double qrCodeSize = qrSize * 60;

    Widget qrWidget = Container(
      width: qrCodeSize,
      height: qrCodeSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'qr_code',
              color: Colors.black,
              size: qrCodeSize * 0.6,
            ),
            Text(
              'QR',
              style: TextStyle(
                fontSize: (qrCodeSize * 0.1),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );

    switch (qrPosition) {
      case 'bottom-right':
        return Positioned(
          bottom: 4.w,
          right: 4.w,
          child: qrWidget,
        );
      case 'center-bottom':
        return Positioned(
          bottom: 4.w,
          left: 0,
          right: 0,
          child: Center(child: qrWidget),
        );
      default:
        return Positioned(
          bottom: 4.w,
          right: 4.w,
          child: qrWidget,
        );
    }
  }

  Widget _buildSignature() {
    Widget signatureWidget = Container(
      width: 25.w,
      height: 8.w,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Firma Digital',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontSize: (fontSize * 0.4).sp,
              fontStyle: FontStyle.italic,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Director Académico',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontSize: (fontSize * 0.4).sp,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );

    switch (signaturePosition) {
      case 'bottom-left':
        return Positioned(
          bottom: 4.w,
          left: 4.w,
          child: signatureWidget,
        );
      case 'bottom-center':
        return Positioned(
          bottom: 4.w,
          left: 0,
          right: 0,
          child: Center(child: signatureWidget),
        );
      case 'top-right':
        return Positioned(
          top: 15.h,
          right: 4.w,
          child: signatureWidget,
        );
      default:
        return Positioned(
          bottom: 4.w,
          left: 4.w,
          child: signatureWidget,
        );
    }
  }

  Color _getSchemeColor(String colorType) {
    Map<String, Map<String, Color>> schemes = {
      'institutional': {
        'primary': AppTheme.lightTheme.colorScheme.primary,
        'secondary': AppTheme.lightTheme.colorScheme.secondary,
      },
      'academic': {
        'primary': Color(0xFF1565C0),
        'secondary': Color(0xFF2E7D32),
      },
      'military': {
        'primary': Color(0xFF0D47A1),
        'secondary': Color(0xFF8B4513),
      },
      'classic': {
        'primary': Color(0xFF424242),
        'secondary': Color(0xFF757575),
      },
    };

    return schemes[colorScheme]?[colorType] ??
        AppTheme.lightTheme.colorScheme.primary;
  }
}
