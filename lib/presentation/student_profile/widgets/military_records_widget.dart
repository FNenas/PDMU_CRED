import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MilitaryRecordsWidget extends StatefulWidget {
  final Map<String, dynamic> studentData;
  final bool isEditing;
  final Function(String, String)? onFieldChanged;

  const MilitaryRecordsWidget({
    Key? key,
    required this.studentData,
    this.isEditing = false,
    this.onFieldChanged,
  }) : super(key: key);

  @override
  State<MilitaryRecordsWidget> createState() => _MilitaryRecordsWidgetState();
}

class _MilitaryRecordsWidgetState extends State<MilitaryRecordsWidget> {
  bool _isDisciplineExpanded = false;
  bool _isRankExpanded = false;
  bool _isCeremonialExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Registros Militares',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildInfoRow(
              'Rango Actual',
              widget.studentData['currentRank'] ?? '',
              'currentRank',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Compañía',
              widget.studentData['company'] ?? '',
              'company',
            ),
            SizedBox(height: 1.h),
            _buildInfoRow(
              'Pelotón',
              widget.studentData['platoon'] ?? '',
              'platoon',
            ),
            SizedBox(height: 2.h),

            // Discipline Records Section
            _buildExpandableSection(
              'Registros Disciplinarios',
              _isDisciplineExpanded,
              () => setState(
                  () => _isDisciplineExpanded = !_isDisciplineExpanded),
              _buildDisciplineRecords(),
            ),

            SizedBox(height: 1.h),

            // Rank Progression Section
            _buildExpandableSection(
              'Progresión de Rangos',
              _isRankExpanded,
              () => setState(() => _isRankExpanded = !_isRankExpanded),
              _buildRankProgression(),
            ),

            SizedBox(height: 1.h),

            // Ceremonial Participation Section
            _buildExpandableSection(
              'Participación Ceremonial',
              _isCeremonialExpanded,
              () => setState(
                  () => _isCeremonialExpanded = !_isCeremonialExpanded),
              _buildCeremonialParticipation(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, String fieldKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 0.5.h),
        widget.isEditing
            ? TextFormField(
                initialValue: value,
                onChanged: (newValue) =>
                    widget.onFieldChanged?.call(fieldKey, newValue),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.h,
                  ),
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              )
            : Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Text(
                  value.isNotEmpty ? value : 'No especificado',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: value.isNotEmpty
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildExpandableSection(
      String title, bool isExpanded, VoidCallback onTap, Widget content) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CustomIconWidget(
                  iconName: isExpanded ? 'expand_less' : 'expand_more',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          SizedBox(height: 1.h),
          content,
        ],
      ],
    );
  }

  Widget _buildDisciplineRecords() {
    final List<Map<String, dynamic>> disciplineRecords = [
      {
        "date": "15/01/2024",
        "type": "Reconocimiento",
        "description": "Excelente desempeño en formación militar",
        "status": "Positivo"
      },
      {
        "date": "03/12/2023",
        "type": "Amonestación",
        "description": "Llegada tardía a formación matutina",
        "status": "Negativo"
      },
    ];

    return Column(
      children: disciplineRecords.map((record) {
        return Container(
          margin: EdgeInsets.only(bottom: 1.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: record['status'] == 'Positivo'
                          ? AppTheme.getStatusColor('enrolled')
                          : AppTheme.getStatusColor('error'),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      record['type'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    record['date'],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                record['description'],
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRankProgression() {
    final List<Map<String, dynamic>> rankProgression = [
      {
        "rank": "Cadete de Primera",
        "date": "01/09/2023",
        "achievement": "Promoción por mérito académico"
      },
      {
        "rank": "Cadete",
        "date": "01/09/2022",
        "achievement": "Ingreso al colegio militar"
      },
    ];

    return Column(
      children: rankProgression.map((rank) {
        return Container(
          margin: EdgeInsets.only(bottom: 1.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'military_tech',
                  color: Colors.black,
                  size: 4.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rank['rank'],
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      rank['date'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      rank['achievement'],
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCeremonialParticipation() {
    final List<Map<String, dynamic>> ceremonies = [
      {
        "event": "Desfile del 16 de Septiembre",
        "date": "16/09/2023",
        "role": "Abanderado de Compañía"
      },
      {
        "event": "Ceremonia de Graduación",
        "date": "15/07/2023",
        "role": "Escolta de Honor"
      },
    ];

    return Column(
      children: ceremonies.map((ceremony) {
        return Container(
          margin: EdgeInsets.only(bottom: 1.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ceremony['event'],
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'event',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    ceremony['date'],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ceremony['role'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
