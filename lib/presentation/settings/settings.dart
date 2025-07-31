import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/admin_profile_card_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/settings_toggle_widget.dart';
import './widgets/version_info_widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  late TabController _tabController;

  // Settings state variables
  bool _biometricEnabled = true;
  bool _notificationsEnabled = true;
  bool _autoBackupEnabled = false;
  bool _darkModeEnabled = false;
  String _selectedLanguage = "Español (México)";
  String _dateFormat = "DD/MM/YYYY";
  int _sessionTimeout = 30;

  // Mock data
  final Map<String, dynamic> _adminData = {
    "name": "Dr. Carlos Mendoza Ruiz",
    "role": "Director Académico",
    "avatar":
        "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "lastLogin": "30/07/2025 02:28",
    "email": "c.mendoza@milschool.edu.mx",
    "phone": "+52 55 1234-5678"
  };

  final Map<String, dynamic> _versionData = {
    "version": "2.1.4",
    "buildNumber": "2140",
    "releaseDate": "25/07/2025",
    "environment": "Producción"
  };

  final List<String> _navigationRoutes = [
    '/login-screen',
    '/student-registration',
    '/student-list',
    '/student-profile',
    '/credential-generator',
    '/settings'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Configuración",
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.lightTheme.tabBarTheme.labelColor,
          unselectedLabelColor:
              AppTheme.lightTheme.tabBarTheme.unselectedLabelColor,
          indicatorColor: AppTheme.lightTheme.tabBarTheme.indicatorColor,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'login',
                color: _tabController.index == 0
                    ? AppTheme.lightTheme.tabBarTheme.labelColor!
                    : AppTheme.lightTheme.tabBarTheme.unselectedLabelColor!,
                size: 5.w,
              ),
              text: "Acceso",
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'person_add',
                color: _tabController.index == 1
                    ? AppTheme.lightTheme.tabBarTheme.labelColor!
                    : AppTheme.lightTheme.tabBarTheme.unselectedLabelColor!,
                size: 5.w,
              ),
              text: "Registro",
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'list',
                color: _tabController.index == 2
                    ? AppTheme.lightTheme.tabBarTheme.labelColor!
                    : AppTheme.lightTheme.tabBarTheme.unselectedLabelColor!,
                size: 5.w,
              ),
              text: "Estudiantes",
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'person',
                color: _tabController.index == 3
                    ? AppTheme.lightTheme.tabBarTheme.labelColor!
                    : AppTheme.lightTheme.tabBarTheme.unselectedLabelColor!,
                size: 5.w,
              ),
              text: "Perfil",
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'badge',
                color: _tabController.index == 4
                    ? AppTheme.lightTheme.tabBarTheme.labelColor!
                    : AppTheme.lightTheme.tabBarTheme.unselectedLabelColor!,
                size: 5.w,
              ),
              text: "Credencial",
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'settings',
                color: _tabController.index == 5
                    ? AppTheme.lightTheme.tabBarTheme.labelColor!
                    : AppTheme.lightTheme.tabBarTheme.unselectedLabelColor!,
                size: 5.w,
              ),
              text: "Configuración",
            ),
          ],
          onTap: (index) {
            if (index != 5) {
              Navigator.pushNamed(context, _navigationRoutes[index]);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Administrator Profile Card
              AdminProfileCardWidget(adminData: _adminData),

              // Account Management Section
              SettingsSectionWidget(
                title: "Gestión de Cuenta",
                children: [
                  SettingsItemWidget(
                    title: "Editar Perfil",
                    subtitle: "Actualizar información personal",
                    iconName: 'edit',
                    onTap: () => _showEditProfileDialog(),
                    showDivider: true,
                  ),
                  SettingsItemWidget(
                    title: "Cambiar Contraseña",
                    subtitle: "Actualizar credenciales de acceso",
                    iconName: 'lock',
                    onTap: () => _showChangePasswordDialog(),
                    showDivider: true,
                  ),
                  SettingsToggleWidget(
                    title: "Autenticación Biométrica",
                    subtitle: "Usar huella dactilar o Face ID",
                    iconName: 'fingerprint',
                    value: _biometricEnabled,
                    onChanged: (value) {
                      setState(() {
                        _biometricEnabled = value;
                      });
                      _showBiometricConfirmation(value);
                    },
                    showDivider: false,
                  ),
                ],
              ),

              // School Configuration Section
              SettingsSectionWidget(
                title: "Configuración Escolar",
                children: [
                  SettingsItemWidget(
                    title: "Personalización Institucional",
                    subtitle: "Logo, colores y marca de la institución",
                    iconName: 'palette',
                    onTap: () => _showInstitutionalBrandingDialog(),
                    showDivider: true,
                  ),
                  SettingsItemWidget(
                    title: "Año Académico",
                    subtitle: "Configurar período escolar actual",
                    value: "2025-2026",
                    iconName: 'calendar_today',
                    onTap: () => _showAcademicYearDialog(),
                    showDivider: true,
                  ),
                  SettingsItemWidget(
                    title: "Formato de Matrícula",
                    subtitle: "Configurar numeración de estudiantes",
                    value: "MIL-2025-####",
                    iconName: 'format_list_numbered',
                    onTap: () => _showEnrollmentFormatDialog(),
                    showDivider: false,
                  ),
                ],
              ),

              // Data & Privacy Section
              SettingsSectionWidget(
                title: "Datos y Privacidad",
                children: [
                  SettingsItemWidget(
                    title: "Respaldo de Base de Datos",
                    subtitle: "Crear copia de seguridad manual",
                    iconName: 'backup',
                    onTap: () => _showBackupDialog(),
                    showDivider: true,
                  ),
                  SettingsToggleWidget(
                    title: "Respaldo Automático",
                    subtitle: "Respaldo diario a las 02:00 AM",
                    iconName: 'cloud_sync',
                    value: _autoBackupEnabled,
                    onChanged: (value) {
                      setState(() {
                        _autoBackupEnabled = value;
                      });
                    },
                    showDivider: true,
                  ),
                  SettingsItemWidget(
                    title: "Exportar Datos",
                    subtitle: "Descargar información estudiantil",
                    iconName: 'download',
                    onTap: () => _showExportDialog(),
                    showDivider: true,
                  ),
                  SettingsItemWidget(
                    title: "Retención de Datos",
                    subtitle: "Cumplimiento normativo mexicano",
                    value: "7 años",
                    iconName: 'policy',
                    onTap: () => _showDataRetentionDialog(),
                    showDivider: false,
                  ),
                ],
              ),

              // Security Section
              SettingsSectionWidget(
                title: "Seguridad",
                children: [
                  SettingsItemWidget(
                    title: "Tiempo de Sesión",
                    subtitle: "Cierre automático por inactividad",
                    value: "$_sessionTimeout min",
                    iconName: 'timer',
                    onTap: () => _showSessionTimeoutDialog(),
                    showDivider: true,
                  ),
                  SettingsItemWidget(
                    title: "Intentos de Acceso",
                    subtitle: "Límite de intentos fallidos",
                    value: "3 intentos",
                    iconName: 'security',
                    onTap: () => _showFailedLoginDialog(),
                    showDivider: true,
                  ),
                  SettingsItemWidget(
                    title: "Registro de Auditoría",
                    subtitle: "Historial de actividades del sistema",
                    iconName: 'history',
                    onTap: () => _showAuditLogDialog(),
                    showDivider: false,
                  ),
                ],
              ),

              // System Preferences Section
              SettingsSectionWidget(
                title: "Preferencias del Sistema",
                children: [
                  SettingsItemWidget(
                    title: "Idioma",
                    subtitle: "Configuración regional",
                    value: _selectedLanguage,
                    iconName: 'language',
                    onTap: () => _showLanguageDialog(),
                    showDivider: true,
                  ),
                  SettingsItemWidget(
                    title: "Formato de Fecha",
                    subtitle: "Visualización de fechas",
                    value: _dateFormat,
                    iconName: 'date_range',
                    onTap: () => _showDateFormatDialog(),
                    showDivider: true,
                  ),
                  SettingsToggleWidget(
                    title: "Modo Oscuro",
                    subtitle: "Tema visual de la aplicación",
                    iconName: 'dark_mode',
                    value: _darkModeEnabled,
                    onChanged: (value) {
                      setState(() {
                        _darkModeEnabled = value;
                      });
                    },
                    showDivider: true,
                  ),
                  SettingsToggleWidget(
                    title: "Notificaciones",
                    subtitle: "Alertas y recordatorios del sistema",
                    iconName: 'notifications',
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    showDivider: false,
                  ),
                ],
              ),

              // Critical Actions Section
              SettingsSectionWidget(
                title: "Acciones Críticas",
                children: [
                  SettingsItemWidget(
                    title: "Restablecer Base de Datos",
                    subtitle: "PRECAUCIÓN: Elimina todos los datos",
                    iconName: 'warning',
                    onTap: () => _showResetDatabaseDialog(),
                    showDivider: true,
                  ),
                  SettingsItemWidget(
                    title: "Cerrar Sesión",
                    subtitle: "Salir de la aplicación",
                    iconName: 'logout',
                    onTap: () => _showLogoutDialog(),
                    showDivider: false,
                  ),
                ],
              ),

              // Version Information
              VersionInfoWidget(versionData: _versionData),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Editar Perfil"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _adminData["name"],
              decoration: InputDecoration(labelText: "Nombre Completo"),
            ),
            SizedBox(height: 2.h),
            TextFormField(
              initialValue: _adminData["email"],
              decoration: InputDecoration(labelText: "Correo Electrónico"),
            ),
            SizedBox(height: 2.h),
            TextFormField(
              initialValue: _adminData["phone"],
              decoration: InputDecoration(labelText: "Teléfono"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessMessage("Perfil actualizado correctamente");
            },
            child: Text("Guardar"),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cambiar Contraseña"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Contraseña Actual"),
            ),
            SizedBox(height: 2.h),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Nueva Contraseña"),
            ),
            SizedBox(height: 2.h),
            TextFormField(
              obscureText: true,
              decoration:
                  InputDecoration(labelText: "Confirmar Nueva Contraseña"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessMessage("Contraseña actualizada correctamente");
            },
            child: Text("Cambiar"),
          ),
        ],
      ),
    );
  }

  void _showBiometricConfirmation(bool enabled) {
    final message = enabled
        ? "Autenticación biométrica activada"
        : "Autenticación biométrica desactivada";
    _showSuccessMessage(message);
  }

  void _showInstitutionalBrandingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Personalización Institucional"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Configurar elementos visuales:"),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'image',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w),
              title: Text("Logo Institucional"),
              subtitle: Text("Actualizar logo de la escuela"),
              onTap: () {},
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'palette',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w),
              title: Text("Colores Corporativos"),
              subtitle: Text("Personalizar esquema de colores"),
              onTap: () {},
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'text_fields',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w),
              title: Text("Nombre de la Institución"),
              subtitle: Text("Escuela Militar Nacional"),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cerrar"),
          ),
        ],
      ),
    );
  }

  void _showAcademicYearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Configurar Año Académico"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: "2025-2026",
              decoration: InputDecoration(labelText: "Año Académico"),
              items: [
                "2024-2025",
                "2025-2026",
                "2026-2027",
              ]
                  .map((year) =>
                      DropdownMenuItem(value: year, child: Text(year)))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 2.h),
            TextFormField(
              initialValue: "15/08/2025",
              decoration: InputDecoration(labelText: "Fecha de Inicio"),
            ),
            SizedBox(height: 2.h),
            TextFormField(
              initialValue: "30/06/2026",
              decoration: InputDecoration(labelText: "Fecha de Fin"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessMessage("Año académico configurado");
            },
            child: Text("Guardar"),
          ),
        ],
      ),
    );
  }

  void _showEnrollmentFormatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Formato de Matrícula"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: "MIL",
              decoration: InputDecoration(labelText: "Prefijo"),
            ),
            SizedBox(height: 2.h),
            TextFormField(
              initialValue: "2025",
              decoration: InputDecoration(labelText: "Año"),
            ),
            SizedBox(height: 2.h),
            DropdownButtonFormField<String>(
              value: "4 dígitos",
              decoration: InputDecoration(labelText: "Formato de Número"),
              items: [
                "3 dígitos (001-999)",
                "4 dígitos (0001-9999)",
                "5 dígitos (00001-99999)",
              ]
                  .map((format) =>
                      DropdownMenuItem(value: format, child: Text(format)))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 2.h),
            Text(
              "Ejemplo: MIL-2025-0001",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessMessage("Formato de matrícula actualizado");
            },
            child: Text("Guardar"),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Respaldo de Base de Datos"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Crear respaldo completo de:"),
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w),
                SizedBox(width: 2.w),
                Text("Datos de estudiantes"),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w),
                SizedBox(width: 2.w),
                Text("Credenciales generadas"),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w),
                SizedBox(width: 2.w),
                Text("Configuraciones del sistema"),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              "El respaldo se guardará en almacenamiento seguro.",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showBackupProgress();
            },
            child: Text("Crear Respaldo"),
          ),
        ],
      ),
    );
  }

  void _showBackupProgress() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Creando Respaldo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 2.h),
            Text("Procesando datos..."),
          ],
        ),
      ),
    );

    // Simulate backup process
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
      _showSuccessMessage("Respaldo creado exitosamente");
    });
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exportar Datos"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'table_chart',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w),
              title: Text("Exportar a Excel"),
              subtitle: Text("Lista completa de estudiantes"),
              onTap: () {
                Navigator.of(context).pop();
                _showSuccessMessage("Archivo Excel descargado");
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'description',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w),
              title: Text("Exportar a CSV"),
              subtitle: Text("Datos en formato CSV"),
              onTap: () {
                Navigator.of(context).pop();
                _showSuccessMessage("Archivo CSV descargado");
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'picture_as_pdf',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w),
              title: Text("Reporte PDF"),
              subtitle: Text("Reporte completo con estadísticas"),
              onTap: () {
                Navigator.of(context).pop();
                _showSuccessMessage("Reporte PDF generado");
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  void _showDataRetentionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Política de Retención"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cumplimiento normativo mexicano:",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            Text("• Expedientes estudiantiles: 7 años"),
            Text("• Credenciales académicas: Permanente"),
            Text("• Registros disciplinarios: 5 años"),
            Text("• Datos biométricos: 3 años"),
            SizedBox(height: 2.h),
            Text(
              "Conforme a la Ley Federal de Protección de Datos Personales en Posesión de los Particulares.",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Entendido"),
          ),
        ],
      ),
    );
  }

  void _showSessionTimeoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Tiempo de Sesión"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              value: _sessionTimeout,
              decoration: InputDecoration(labelText: "Minutos de inactividad"),
              items: [15, 30, 60, 120, 240]
                  .map((minutes) => DropdownMenuItem(
                      value: minutes, child: Text("$minutes minutos")))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _sessionTimeout = value;
                  });
                }
              },
            ),
            SizedBox(height: 2.h),
            Text(
              "La sesión se cerrará automáticamente después del tiempo especificado sin actividad.",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessMessage("Tiempo de sesión actualizado");
            },
            child: Text("Guardar"),
          ),
        ],
      ),
    );
  }

  void _showFailedLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Intentos de Acceso"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              value: 3,
              decoration: InputDecoration(labelText: "Intentos permitidos"),
              items: [3, 5, 10]
                  .map((attempts) => DropdownMenuItem(
                      value: attempts, child: Text("$attempts intentos")))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 2.h),
            DropdownButtonFormField<int>(
              value: 15,
              decoration:
                  InputDecoration(labelText: "Tiempo de bloqueo (minutos)"),
              items: [5, 15, 30, 60]
                  .map((minutes) => DropdownMenuItem(
                      value: minutes, child: Text("$minutes minutos")))
                  .toList(),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessMessage("Configuración de seguridad actualizada");
            },
            child: Text("Guardar"),
          ),
        ],
      ),
    );
  }

  void _showAuditLogDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Registro de Auditoría"),
        content: Container(
          width: 80.w,
          height: 50.h,
          child: Column(
            children: [
              Text(
                "Actividades recientes del sistema:",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView(
                  children: [
                    _buildAuditLogItem("30/07/2025 02:28", "Inicio de sesión",
                        "Dr. Carlos Mendoza"),
                    _buildAuditLogItem("30/07/2025 01:45",
                        "Exportación de datos", "Dr. Carlos Mendoza"),
                    _buildAuditLogItem("29/07/2025 23:30",
                        "Registro de estudiante", "Prof. Ana García"),
                    _buildAuditLogItem("29/07/2025 22:15",
                        "Generación de credencial", "Prof. Ana García"),
                    _buildAuditLogItem(
                        "29/07/2025 20:00", "Respaldo automático", "Sistema"),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cerrar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessMessage("Registro de auditoría exportado");
            },
            child: Text("Exportar"),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditLogItem(String timestamp, String action, String user) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: 'history',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "$user • $timestamp",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Seleccionar Idioma"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text("Español (México)"),
              value: "Español (México)",
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.of(context).pop();
                _showSuccessMessage("Idioma actualizado");
              },
            ),
            RadioListTile<String>(
              title: Text("Español (España)"),
              value: "Español (España)",
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.of(context).pop();
                _showSuccessMessage("Idioma actualizado");
              },
            ),
            RadioListTile<String>(
              title: Text("English (US)"),
              value: "English (US)",
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.of(context).pop();
                _showSuccessMessage("Language updated");
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  void _showDateFormatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Formato de Fecha"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text("DD/MM/YYYY (30/07/2025)"),
              value: "DD/MM/YYYY",
              groupValue: _dateFormat,
              onChanged: (value) {
                setState(() {
                  _dateFormat = value!;
                });
                Navigator.of(context).pop();
                _showSuccessMessage("Formato de fecha actualizado");
              },
            ),
            RadioListTile<String>(
              title: Text("MM/DD/YYYY (07/30/2025)"),
              value: "MM/DD/YYYY",
              groupValue: _dateFormat,
              onChanged: (value) {
                setState(() {
                  _dateFormat = value!;
                });
                Navigator.of(context).pop();
                _showSuccessMessage("Formato de fecha actualizado");
              },
            ),
            RadioListTile<String>(
              title: Text("YYYY-MM-DD (2025-07-30)"),
              value: "YYYY-MM-DD",
              groupValue: _dateFormat,
              onChanged: (value) {
                setState(() {
                  _dateFormat = value!;
                });
                Navigator.of(context).pop();
                _showSuccessMessage("Formato de fecha actualizado");
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  void _showResetDatabaseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text("PRECAUCIÓN"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Esta acción eliminará PERMANENTEMENTE:",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
            SizedBox(height: 2.h),
            Text("• Todos los registros de estudiantes"),
            Text("• Credenciales generadas"),
            Text("• Configuraciones personalizadas"),
            Text("• Historial de actividades"),
            SizedBox(height: 2.h),
            Text(
              "Esta acción NO se puede deshacer.",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
            SizedBox(height: 2.h),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Escriba 'CONFIRMAR' para continuar",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showBiometricVerificationDialog("reset");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text("Restablecer"),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cerrar Sesión"),
        content: Text("¿Está seguro que desea cerrar la sesión actual?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login-screen', (route) => false);
            },
            child: Text("Cerrar Sesión"),
          ),
        ],
      ),
    );
  }

  void _showBiometricVerificationDialog(String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'fingerprint',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text("Verificación Biométrica"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Se requiere verificación biométrica para continuar con esta acción crítica."),
            SizedBox(height: 3.h),
            CustomIconWidget(
              iconName: 'fingerprint',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20.w,
            ),
            SizedBox(height: 2.h),
            Text(
              "Toque el sensor de huella dactilar",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (action == "reset") {
                _showSuccessMessage("Base de datos restablecida");
              }
            },
            child: Text("Verificar"),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.w),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
