import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/color_scheme_selector_widget.dart';
import './widgets/credential_preview_widget.dart';
import './widgets/generation_progress_widget.dart';
import './widgets/qr_position_selector_widget.dart';
import './widgets/signature_options_widget.dart';
import './widgets/template_selector_widget.dart';
import './widgets/text_formatting_widget.dart';

class CredentialGenerator extends StatefulWidget {
  const CredentialGenerator({super.key});

  @override
  State<CredentialGenerator> createState() => _CredentialGeneratorState();
}

class _CredentialGeneratorState extends State<CredentialGenerator>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Mock student data
  final Map<String, dynamic> _studentData = {
    "id": "001",
    "fullName": "María Elena Rodríguez García",
    "enrollmentNumber": "MIL-2024-001",
    "state": "Ciudad de México",
    "academicYear": "2024-2025",
    "status": "Activo",
    "rank": "Cadete Segundo",
    "gpa": "9.2",
    "photo":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
  };

  // Credential settings
  String _selectedTemplate = 'standard';
  String _qrPosition = 'bottom-right';
  double _qrSize = 1.0;
  double _fontSize = 1.0;
  String _colorScheme = 'institutional';
  bool _showSignature = false;
  String _signaturePosition = 'bottom-left';
  bool _isGenerating = false;

  final List<String> _tabTitles = [
    'Plantilla',
    'QR & Posición',
    'Formato',
    'Colores',
    'Firma',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
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
      appBar: _buildAppBar(),
      body: _isGenerating ? _buildGeneratingView() : _buildMainView(),
      bottomNavigationBar: _isGenerating ? null : _buildBottomActions(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Generador de Credenciales',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      actions: [
        if (!_isGenerating)
          IconButton(
            onPressed: _showHelpDialog,
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
          ),
      ],
    );
  }

  Widget _buildMainView() {
    return SafeArea(
      child: Column(
        children: [
          _buildPreviewSection(),
          _buildControlsSection(),
        ],
      ),
    );
  }

  Widget _buildGeneratingView() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Spacer(),
            GenerationProgressWidget(
              isGenerating: _isGenerating,
              onCancel: _cancelGeneration,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Vista Previa de la Credencial',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: _showFullScreenPreview,
            child: CredentialPreviewWidget(
              studentData: _studentData,
              selectedTemplate: _selectedTemplate,
              qrPosition: _qrPosition,
              qrSize: _qrSize,
              fontSize: _fontSize,
              colorScheme: _colorScheme,
              showSignature: _showSignature,
              signaturePosition: _signaturePosition,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'zoom_in',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Toca para vista completa',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlsSection() {
    return Expanded(
      child: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTemplateTab(),
                _buildQRTab(),
                _buildFormatTab(),
                _buildColorsTab(),
                _buildSignatureTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        indicatorColor: AppTheme.lightTheme.colorScheme.primary,
        indicatorWeight: 3,
        labelStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle:
            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
      ),
    );
  }

  Widget _buildTemplateTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: TemplateSelectorWidget(
        selectedTemplate: _selectedTemplate,
        onTemplateChanged: (template) {
          setState(() {
            _selectedTemplate = template;
          });
        },
      ),
    );
  }

  Widget _buildQRTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: QrPositionSelectorWidget(
        selectedPosition: _qrPosition,
        qrSize: _qrSize,
        onPositionChanged: (position) {
          setState(() {
            _qrPosition = position;
          });
        },
        onSizeChanged: (size) {
          setState(() {
            _qrSize = size;
          });
        },
      ),
    );
  }

  Widget _buildFormatTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: TextFormattingWidget(
        fontSize: _fontSize,
        onFontSizeChanged: (size) {
          setState(() {
            _fontSize = size;
          });
        },
      ),
    );
  }

  Widget _buildColorsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: ColorSchemeSelectorWidget(
        selectedScheme: _colorScheme,
        onSchemeChanged: (scheme) {
          setState(() {
            _colorScheme = scheme;
          });
        },
      ),
    );
  }

  Widget _buildSignatureTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: SignatureOptionsWidget(
        showSignature: _showSignature,
        signaturePosition: _signaturePosition,
        onSignatureToggle: (show) {
          setState(() {
            _showSignature = show;
          });
        },
        onPositionChanged: (position) {
          setState(() {
            _signaturePosition = position;
          });
        },
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                ),
                child: Text('Cancelar'),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _generateCredential,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'download',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text('Generar Credencial'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenPreview() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: Container(
                  margin: EdgeInsets.all(4.w),
                  child: CredentialPreviewWidget(
                    studentData: _studentData,
                    selectedTemplate: _selectedTemplate,
                    qrPosition: _qrPosition,
                    qrSize: _qrSize,
                    fontSize: _fontSize,
                    colorScheme: _colorScheme,
                    showSignature: _showSignature,
                    signaturePosition: _signaturePosition,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8.h,
              right: 4.w,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'help',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text('Ayuda'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instrucciones de uso:',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildHelpItem('1. Selecciona la plantilla deseada'),
            _buildHelpItem('2. Configura la posición y tamaño del QR'),
            _buildHelpItem('3. Ajusta el formato de texto'),
            _buildHelpItem('4. Elige el esquema de colores'),
            _buildHelpItem('5. Agrega firma digital si es necesario'),
            _buildHelpItem('6. Genera la credencial en PDF y PNG'),
            SizedBox(height: 2.h),
            Text(
              'La vista previa se actualiza en tiempo real.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.getStatusColor('confirmed'),
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  void _generateCredential() async {
    setState(() {
      _isGenerating = true;
    });

    // Simulate generation process
    await Future.delayed(Duration(seconds: 8));

    if (_isGenerating) {
      setState(() {
        _isGenerating = false;
      });

      _showGenerationComplete();
    }
  }

  void _cancelGeneration() {
    setState(() {
      _isGenerating = false;
    });
  }

  void _showGenerationComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.getStatusColor('confirmed'),
              size: 28,
            ),
            SizedBox(width: 3.w),
            Text('¡Credencial Generada!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'La credencial ha sido generada exitosamente en los siguientes formatos:',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            _buildFormatItem('PDF de alta calidad', 'picture_as_pdf'),
            _buildFormatItem('Imagen PNG', 'image'),
            SizedBox(height: 2.h),
            Text(
              'Los archivos han sido guardados en el perfil del estudiante.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _shareCredential();
            },
            child: Text('Compartir'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Finalizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatItem(String text, String iconName) {
    return Container(
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.getStatusColor('confirmed').withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.getStatusColor('confirmed').withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.getStatusColor('confirmed'),
            size: 20,
          ),
          SizedBox(width: 3.w),
          Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _shareCredential() {
    // Simulate sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'share',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Text('Credencial compartida exitosamente'),
          ],
        ),
        backgroundColor: AppTheme.getStatusColor('confirmed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
