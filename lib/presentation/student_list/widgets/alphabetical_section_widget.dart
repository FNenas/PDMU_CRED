import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlphabeticalSectionWidget extends StatelessWidget {
  final String letter;
  final List<Map<String, dynamic>> students;
  final Function(Map<String, dynamic>) onStudentTap;
  final Function(Map<String, dynamic>) onViewProfile;
  final Function(Map<String, dynamic>) onGenerateCredential;
  final Function(Map<String, dynamic>) onEditDetails;
  final Function(Map<String, dynamic>) onMarkInactive;
  final Function(Map<String, dynamic>) onDelete;

  const AlphabeticalSectionWidget({
    Key? key,
    required this.letter,
    required this.students,
    required this.onStudentTap,
    required this.onViewProfile,
    required this.onGenerateCredential,
    required this.onEditDetails,
    required this.onMarkInactive,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        ...students.map((student) => _buildStudentCard(student)),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      margin: EdgeInsets.only(top: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.3),
        border: Border(
          left: BorderSide(
            color: AppTheme.lightTheme.colorScheme.primary,
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                letter.toUpperCase(),
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            '${students.length} estudiante${students.length != 1 ? 's' : ''}',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Dismissible(
        key: Key(student['id'].toString()),
        background: _buildSwipeBackground(isLeft: false),
        secondaryBackground: _buildSwipeBackground(isLeft: true),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            return await _showDeleteConfirmation(student);
          } else {
            _showQuickActions(student);
            return false;
          }
        },
        child: GestureDetector(
          onTap: () => onStudentTap(student),
          onLongPress: () => _showContextMenu(student),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                _buildStudentPhoto(student),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildStudentInfo(student),
                ),
                _buildStatusBadge(student),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentPhoto(Map<String, dynamic> student) {
    return Container(
      width: 15.w,
      height: 15.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: ClipOval(
        child: student['photo'] != null && student['photo'].isNotEmpty
            ? CustomImageWidget(
                imageUrl: student['photo'],
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover,
              )
            : Container(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                child: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                  size: 8.w,
                ),
              ),
      ),
    );
  }

  Widget _buildStudentInfo(Map<String, dynamic> student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          student['name'] ?? 'Sin nombre',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Matrícula: ${student['enrollmentNumber'] ?? 'N/A'}',
          style: AppTheme.getDataTextStyle(isLight: true, fontSize: 12.sp),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.5.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'location_on',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 3.w,
            ),
            SizedBox(width: 1.w),
            Expanded(
              child: Text(
                student['state'] ?? 'Estado no especificado',
                style: AppTheme.lightTheme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Año académico: ${student['academicYear'] ?? 'N/A'}',
          style: AppTheme.lightTheme.textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStatusBadge(Map<String, dynamic> student) {
    final status = student['status'] ?? 'pending';
    final statusColor = AppTheme.getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(1.w),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Text(
        _getStatusText(status),
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'enrolled':
        return 'Inscrito';
      case 'pending':
        return 'Pendiente';
      case 'inactive':
        return 'Inactivo';
      case 'graduated':
        return 'Graduado';
      default:
        return 'Desconocido';
    }
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'delete' : 'more_horiz',
                color: Colors.white,
                size: 6.w,
              ),
              SizedBox(height: 1.h),
              Text(
                isLeft ? 'Eliminar' : 'Acciones',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(Map<String, dynamic> student) async {
    return false; // Placeholder - would show actual dialog
  }

  void _showQuickActions(Map<String, dynamic> student) {
    // Placeholder - would show bottom sheet with quick actions
  }

  void _showContextMenu(Map<String, dynamic> student) {
    // Placeholder - would show context menu
  }
}
