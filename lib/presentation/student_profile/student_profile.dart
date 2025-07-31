import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/academic_info_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/contact_details_widget.dart';
import './widgets/military_records_widget.dart';
import './widgets/personal_details_widget.dart';
import './widgets/qr_code_widget.dart';
import './widgets/student_photo_widget.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  bool _isEditing = false;
  late Map<String, dynamic> _studentData;
  late Map<String, dynamic> _originalData;

  @override
  void initState() {
    super.initState();
    _initializeStudentData();
  }

  void _initializeStudentData() {
    _studentData = {
      "id": "EST001",
      "fullName": "Carlos Eduardo Hernández Morales",
      "curp": "HEMC050315HDFRRL09",
      "birthDate": "15/03/2005",
      "birthPlace": "Ciudad de México, CDMX",
      "gender": "Masculino",
      "bloodType": "O+",
      "enrollmentNumber": "2024-CMX-001",
      "academicYear": "2024-2025",
      "grade": "3° Año",
      "group": "A",
      "enrollmentDate": "01/09/2024",
      "status": "Activo",
      "address": "Av. Insurgentes Sur 1234, Col. Del Valle",
      "state": "Ciudad de México",
      "city": "Ciudad de México",
      "postalCode": "03100",
      "phone": "+52 55 1234 5678",
      "email": "carlos.hernandez@milschool.edu.mx",
      "emergencyContactName": "María Elena Morales Vázquez",
      "emergencyContactPhone": "+52 55 9876 5432",
      "emergencyContactRelation": "Madre",
      "currentRank": "Cadete de Primera",
      "company": "Compañía Alpha",
      "platoon": "1er Pelotón",
      "photoUrl":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "lastUpdate": "30/07/2025 02:27"
    };
    _originalData = Map<String, dynamic>.from(_studentData);
  }

  void _onFieldChanged(String fieldKey, String newValue) {
    setState(() {
      _studentData[fieldKey] = newValue;
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset to original data if canceling
        _studentData = Map<String, dynamic>.from(_originalData);
      }
    });
  }

  void _saveChanges() {
    // Simulate saving changes
    setState(() {
      _isEditing = false;
      _originalData = Map<String, dynamic>.from(_studentData);
      _studentData['lastUpdate'] =
          "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Perfil actualizado correctamente'),
        backgroundColor: AppTheme.getStatusColor('enrolled'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _studentData = Map<String, dynamic>.from(_originalData);
    });
  }

  void _generateCredential() {
    Navigator.pushNamed(context, '/credential-generator');
  }

  void _shareProfile() {
    // Simulate sharing functionality
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Perfil compartido como PDF'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _editPhoto() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Cambiar Foto de Perfil',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                title: Text('Tomar Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'photo_library',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                title: Text('Seleccionar de Galería'),
                onTap: () {
                  Navigator.pop(context);
                  _selectFromGallery();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _takePhoto() {
    // Simulate camera functionality
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Foto capturada correctamente'),
        backgroundColor: AppTheme.getStatusColor('enrolled'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _selectFromGallery() {
    // Simulate gallery selection
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Foto seleccionada de la galería'),
        backgroundColor: AppTheme.getStatusColor('enrolled'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      child: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 6.w,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Perfil del Estudiante',
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _isEditing ? null : _toggleEditMode,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      child: CustomIconWidget(
                        iconName: 'edit',
                        color: _isEditing
                            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            : AppTheme.lightTheme.colorScheme.primary,
                        size: 6.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Student Photo Section
                    StudentPhotoWidget(
                      photoUrl: _studentData['photoUrl'],
                      onEditPressed: _editPhoto,
                    ),

                    SizedBox(height: 2.h),

                    // Student Name and Basic Info
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        children: [
                          Text(
                            _studentData['fullName'] ?? '',
                            textAlign: TextAlign.center,
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Matrícula: ${_studentData['enrollmentNumber'] ?? ''}',
                            style: AppTheme.getDataTextStyle(
                              isLight: true,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Última actualización: ${_studentData['lastUpdate'] ?? ''}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Personal Details Section
                    PersonalDetailsWidget(
                      studentData: _studentData,
                      isEditing: _isEditing,
                      onFieldChanged: _onFieldChanged,
                    ),

                    // Academic Information Section
                    AcademicInfoWidget(
                      studentData: _studentData,
                      isEditing: _isEditing,
                      onFieldChanged: _onFieldChanged,
                    ),

                    // Contact Details Section
                    ContactDetailsWidget(
                      studentData: _studentData,
                      isEditing: _isEditing,
                      onFieldChanged: _onFieldChanged,
                    ),

                    // Military Records Section
                    MilitaryRecordsWidget(
                      studentData: _studentData,
                      isEditing: _isEditing,
                      onFieldChanged: _onFieldChanged,
                    ),

                    // QR Code Section
                    QrCodeWidget(
                      studentId: _studentData['id'] ?? '',
                      enrollmentNumber: _studentData['enrollmentNumber'] ?? '',
                    ),

                    SizedBox(height: 2.h),

                    // Action Buttons
                    ActionButtonsWidget(
                      isEditing: _isEditing,
                      onGenerateCredential: _generateCredential,
                      onShareProfile: _shareProfile,
                      onEditProfile: _toggleEditMode,
                      onSaveChanges: _saveChanges,
                      onCancelEdit: _cancelEdit,
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
