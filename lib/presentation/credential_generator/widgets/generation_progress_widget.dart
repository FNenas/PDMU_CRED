import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GenerationProgressWidget extends StatefulWidget {
  final bool isGenerating;
  final Function() onCancel;

  const GenerationProgressWidget({
    super.key,
    required this.isGenerating,
    required this.onCancel,
  });

  @override
  State<GenerationProgressWidget> createState() =>
      _GenerationProgressWidgetState();
}

class _GenerationProgressWidgetState extends State<GenerationProgressWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  double _currentProgress = 0.0;
  String _currentStep = '';
  int _estimatedTime = 0;

  final List<Map<String, dynamic>> _generationSteps = [
    {'step': 'Preparando datos del estudiante...', 'duration': 1000},
    {'step': 'Aplicando plantilla seleccionada...', 'duration': 1500},
    {'step': 'Generando código QR...', 'duration': 800},
    {'step': 'Aplicando formato y colores...', 'duration': 1200},
    {'step': 'Creando archivo PDF...', 'duration': 2000},
    {'step': 'Generando imagen PNG...', 'duration': 1000},
    {'step': 'Guardando credencial...', 'duration': 500},
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: Duration(milliseconds: 8000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isGenerating) {
      _startGeneration();
    }
  }

  @override
  void didUpdateWidget(GenerationProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isGenerating && !oldWidget.isGenerating) {
      _startGeneration();
    } else if (!widget.isGenerating && oldWidget.isGenerating) {
      _stopGeneration();
    }
  }

  void _startGeneration() {
    _progressController.reset();
    _pulseController.repeat(reverse: true);
    _simulateProgress();
    _progressController.forward();
  }

  void _stopGeneration() {
    _progressController.stop();
    _pulseController.stop();
  }

  void _simulateProgress() async {
    int totalDuration = _generationSteps.fold(
        0, (sum, step) => sum + (step['duration'] as int));
    _estimatedTime = (totalDuration / 1000).ceil();

    double progressIncrement = 0.0;

    for (int i = 0; i < _generationSteps.length; i++) {
      if (!widget.isGenerating) break;

      setState(() {
        _currentStep = _generationSteps[i]['step'];
      });

      int stepDuration = _generationSteps[i]['duration'];
      double stepProgress = (stepDuration / totalDuration);

      for (int j = 0; j < 10; j++) {
        if (!widget.isGenerating) break;

        await Future.delayed(Duration(milliseconds: stepDuration ~/ 10));
        setState(() {
          _currentProgress = progressIncrement + (stepProgress * (j + 1) / 10);
          _estimatedTime =
              ((totalDuration * (1 - _currentProgress)) / 1000).ceil();
        });
      }

      progressIncrement += stepProgress;
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isGenerating) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
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
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 4.h),
          _buildProgressIndicator(),
          SizedBox(height: 3.h),
          _buildCurrentStep(),
          SizedBox(height: 3.h),
          _buildTimeEstimate(),
          SizedBox(height: 4.h),
          _buildCancelButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: CustomIconWidget(
                iconName: 'auto_awesome',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 32,
              ),
            );
          },
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Generando Credencial',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              Text(
                'Creando archivos PDF y PNG...',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progreso',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(_currentProgress * 100).toInt()}%',
              style: AppTheme.getDataTextStyle(
                isLight: true,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _currentProgress,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStep() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              _currentStep.isEmpty ? 'Iniciando generación...' : _currentStep,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeEstimate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIconWidget(
          iconName: 'schedule',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Text(
          'Tiempo estimado: ${_estimatedTime}s',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: widget.onCancel,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.lightTheme.colorScheme.error,
          side: BorderSide(
            color: AppTheme.lightTheme.colorScheme.error,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'cancel',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text('Cancelar Generación'),
          ],
        ),
      ),
    );
  }
}
