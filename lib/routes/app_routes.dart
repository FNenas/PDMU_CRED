import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/student_registration/student_registration.dart';
import '../presentation/student_profile/student_profile.dart';
import '../presentation/student_list/student_list.dart';
import '../presentation/credential_generator/credential_generator.dart';
import '../presentation/settings/settings.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String studentRegistration = '/student-registration';
  static const String studentProfile = '/student-profile';
  static const String studentList = '/student-list';
  static const String credentialGenerator = '/credential-generator';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => LoginScreen(),
    loginScreen: (context) => LoginScreen(),
    studentRegistration: (context) => StudentRegistration(),
    studentProfile: (context) => StudentProfile(),
    studentList: (context) => StudentList(),
    credentialGenerator: (context) => CredentialGenerator(),
    settings: (context) => Settings(),
    // TODO: Add your other routes here
  };
}
