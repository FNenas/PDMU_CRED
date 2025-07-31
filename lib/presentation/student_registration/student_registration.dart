import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/academic_info_section.dart';
import './widgets/contact_info_section.dart';
import './widgets/military_requirements_section.dart';
import './widgets/personal_info_section.dart';
import './widgets/photo_capture_section.dart';
import './widgets/state_selector_bottom_sheet.dart';

class StudentRegistration extends StatefulWidget {
  const StudentRegistration({super.key});

  @override
  State<StudentRegistration> createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Personal Information Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _curpController = TextEditingController();
  DateTime? _birthDate;
  String? _gender;

  // Academic Information Controllers
  final TextEditingController _enrollmentController = TextEditingController();
  String? _selectedState;
  String? _academicYear;
  String? _gradeLevel;

  // Contact Information Controllers
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();

  // Military Requirements
  String? _militaryRank;
  String? _disciplinaryRecord;
  bool _medicalClearance = false;
  bool _uniformSize = false;

  // Photo
  XFile? _capturedImage;

  // Validation
  Map<String, String?> _validationErrors = {};
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _setupValidationListeners();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _curpController.dispose();
    _enrollmentController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  void _setupValidationListeners() {
    _firstNameController.addListener(_validateForm);
    _lastNameController.addListener(_validateForm);
    _curpController.addListener(_validateForm);
    _enrollmentController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _addressController.addListener(_validateForm);
    _emergencyContactController.addListener(_validateForm);
    _emergencyPhoneController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _validationErrors.clear();

      // Personal Information Validation
      if (_firstNameController.text.trim().isEmpty) {
        _validationErrors['firstName'] = 'El nombre es requerido';
      } else if (_firstNameController.text.trim().length < 2) {
        _validationErrors['firstName'] =
            'El nombre debe tener al menos 2 caracteres';
      }

      if (_lastNameController.text.trim().isEmpty) {
        _validationErrors['lastName'] = 'Los apellidos son requeridos';
      } else if (_lastNameController.text.trim().length < 2) {
        _validationErrors['lastName'] =
            'Los apellidos deben tener al menos 2 caracteres';
      }

      if (_curpController.text.trim().isEmpty) {
        _validationErrors['curp'] = 'La CURP es requerida';
      } else if (_curpController.text.trim().length != 18) {
        _validationErrors['curp'] = 'La CURP debe tener 18 caracteres';
      } else if (!RegExp(r'^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9]{2}$')
          .hasMatch(_curpController.text.trim().toUpperCase())) {
        _validationErrors['curp'] = 'Formato de CURP inválido';
      }

      // Academic Information Validation
      if (_enrollmentController.text.trim().isEmpty) {
        _validationErrors['enrollment'] = 'El número de matrícula es requerido';
      }

      // Contact Information Validation
      if (_phoneController.text.trim().isEmpty) {
        _validationErrors['phone'] = 'El teléfono es requerido';
      } else if (!RegExp(r'^[0-9\s\-\+\(\)]{10,15}$')
          .hasMatch(_phoneController.text.trim())) {
        _validationErrors['phone'] = 'Formato de teléfono inválido';
      }

      if (_emailController.text.trim().isEmpty) {
        _validationErrors['email'] = 'El correo electrónico es requerido';
      } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(_emailController.text.trim())) {
        _validationErrors['email'] = 'Formato de correo electrónico inválido';
      }

      if (_addressController.text.trim().isEmpty) {
        _validationErrors['address'] = 'La dirección es requerida';
      } else if (_addressController.text.trim().length < 10) {
        _validationErrors['address'] = 'La dirección debe ser más específica';
      }

      if (_emergencyContactController.text.trim().isEmpty) {
        _validationErrors['emergencyContact'] =
            'El contacto de emergencia es requerido';
      } else if (_emergencyContactController.text.trim().length < 2) {
        _validationErrors['emergencyContact'] =
            'El nombre debe tener al menos 2 caracteres';
      }

      if (_emergencyPhoneController.text.trim().isEmpty) {
        _validationErrors['emergencyPhone'] =
            'El teléfono de emergencia es requerido';
      } else if (!RegExp(r'^[0-9\s\-\+\(\)]{10,15}$')
          .hasMatch(_emergencyPhoneController.text.trim())) {
        _validationErrors['emergencyPhone'] = 'Formato de teléfono inválido';
      }

      // Check if all required fields are valid
      _isFormValid = _validationErrors.isEmpty &&
          _firstNameController.text.trim().isNotEmpty &&
          _lastNameController.text.trim().isNotEmpty &&
          _curpController.text.trim().isNotEmpty &&
          _enrollmentController.text.trim().isNotEmpty &&
          _phoneController.text.trim().isNotEmpty &&
          _emailController.text.trim().isNotEmpty &&
          _addressController.text.trim().isNotEmpty &&
          _emergencyContactController.text.trim().isNotEmpty &&
          _emergencyPhoneController.text.trim().isNotEmpty &&
          _birthDate != null &&
          _gender != null &&
          _selectedState != null &&
          _academicYear != null &&
          _gradeLevel != null &&
          _militaryRank != null &&
          _disciplinaryRecord != null &&
          _medicalClearance &&
          _uniformSize;
    });
  }

  void _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().subtract(Duration(days: 365 * 15)), // 15 years ago
      firstDate:
          DateTime.now().subtract(Duration(days: 365 * 25)), // 25 years ago
      lastDate:
          DateTime.now().subtract(Duration(days: 365 * 12)), // 12 years ago
      locale: Locale('es', 'MX'),
    );

    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
      _validateForm();
    }
  }

  void _showStateSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StateSelectorBottomSheet(
        selectedState: _selectedState,
        onStateSelected: (state) {
          setState(() {
            _selectedState = state;
          });
          _validateForm();
        },
      ),
    );
  }

  void _generateEnrollmentNumber() {
    final now = DateTime.now();
    final year = now.year;
    final randomNumber =
        (now.millisecondsSinceEpoch % 1000).toString().padLeft(3, '0');
    final stateCode = _selectedState?.substring(0, 2).toUpperCase() ?? 'MX';

    setState(() {
      _enrollmentController.text = 'MIL-$year-$stateCode-$randomNumber';
    });
    _validateForm();

    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: 'Número de matrícula generado',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onImageCaptured(XFile? image) {
    setState(() {
      _capturedImage = image;
    });
  }

  void _saveStudent() async {
    if (!_isFormValid) {
      Fluttertoast.showToast(
        msg: 'Por favor completa todos los campos requeridos',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: AppTheme.lightTheme.primaryColor,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Guardando estudiante...',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Simulate save operation
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context); // Close loading dialog

      // Show success message
      Fluttertoast.showToast(
        msg: 'Estudiante registrado exitosamente',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );

      // Navigate back or to student list
      Navigator.pop(context);
    }
  }

  void _cancelRegistration() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancelar Registro'),
        content: Text(
            '¿Estás seguro de que deseas cancelar el registro? Se perderán todos los datos ingresados.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Continuar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close registration screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Estudiante'),
        leading: IconButton(
          onPressed: _cancelRegistration,
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isFormValid ? _saveStudent : null,
            child: Text(
              'GUARDAR',
              style: TextStyle(
                color: _isFormValid
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onPrimary
                        .withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Column(
              children: [
                SizedBox(height: 1.h),
                PersonalInfoSection(
                  firstNameController: _firstNameController,
                  lastNameController: _lastNameController,
                  curpController: _curpController,
                  birthDate: _birthDate,
                  gender: _gender,
                  onBirthDateTap: _selectBirthDate,
                  onGenderChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                    _validateForm();
                  },
                  validationErrors: _validationErrors,
                ),
                AcademicInfoSection(
                  enrollmentController: _enrollmentController,
                  selectedState: _selectedState,
                  academicYear: _academicYear,
                  gradeLevel: _gradeLevel,
                  onStateSelector: _showStateSelector,
                  onAcademicYearChanged: (value) {
                    setState(() {
                      _academicYear = value;
                    });
                    _validateForm();
                  },
                  onGradeLevelChanged: (value) {
                    setState(() {
                      _gradeLevel = value;
                    });
                    _validateForm();
                  },
                  onGenerateEnrollment: _generateEnrollmentNumber,
                  validationErrors: _validationErrors,
                ),
                ContactInfoSection(
                  phoneController: _phoneController,
                  emailController: _emailController,
                  addressController: _addressController,
                  emergencyContactController: _emergencyContactController,
                  emergencyPhoneController: _emergencyPhoneController,
                  validationErrors: _validationErrors,
                ),
                MilitaryRequirementsSection(
                  militaryRank: _militaryRank,
                  disciplinaryRecord: _disciplinaryRecord,
                  medicalClearance: _medicalClearance,
                  uniformSize: _uniformSize,
                  onMilitaryRankChanged: (value) {
                    setState(() {
                      _militaryRank = value;
                    });
                    _validateForm();
                  },
                  onDisciplinaryRecordChanged: (value) {
                    setState(() {
                      _disciplinaryRecord = value;
                    });
                    _validateForm();
                  },
                  onMedicalClearanceChanged: (value) {
                    setState(() {
                      _medicalClearance = value;
                    });
                    _validateForm();
                  },
                  onUniformSizeChanged: (value) {
                    setState(() {
                      _uniformSize = value;
                    });
                    _validateForm();
                  },
                  validationErrors: _validationErrors,
                ),
                PhotoCaptureSection(
                  capturedImage: _capturedImage,
                  onImageCaptured: _onImageCaptured,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _isFormValid
          ? FloatingActionButton.extended(
              onPressed: _saveStudent,
              icon: CustomIconWidget(
                iconName: 'save',
                color: AppTheme
                    .lightTheme.floatingActionButtonTheme.foregroundColor!,
                size: 20,
              ),
              label: Text('Guardar'),
            )
          : null,
    );
  }
}
