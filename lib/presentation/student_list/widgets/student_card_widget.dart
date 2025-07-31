import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StudentCardWidget extends StatelessWidget {
  final Map<String, dynamic> student;
  final VoidCallback? onTap;
  final VoidCallback? onViewProfile;
  final VoidCallback? onGenerateCredential;
  final VoidCallback? onEditDetails;
  final VoidCallback? onMarkInactive;
  final VoidCallback? onDelete;

  const StudentCardWidget({
    Key? key,
    required this.student,
    this.onTap,
    this.onViewProfile,
    this.onGenerateCredential,
    this.onEditDetails,
    this.onMarkInactive,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(student['id'].toString()),
      background: _buildSwipeBackground(context, isLeft: false),
      secondaryBackground: _buildSwipeBackground(context, isLeft: true),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation(context);
        } else {
          _showQuickActions(context);
          return false;
        }
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
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
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                _buildStudentPhoto(),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildStudentInfo(),
                ),
                _buildStatusBadge(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentPhoto() {
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

  Widget _buildStudentInfo() {
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

  Widget _buildStatusBadge() {
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

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
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

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirmar eliminación'),
            content: Text(
              '¿Estás seguro de que deseas eliminar a ${student['name']}? Esta acción no se puede deshacer.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onDelete?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
                child: Text('Eliminar'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Acciones rápidas',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            _buildActionTile(
              context,
              'Ver perfil',
              'visibility',
              onViewProfile,
            ),
            _buildActionTile(
              context,
              'Generar credencial',
              'badge',
              onGenerateCredential,
            ),
            _buildActionTile(
              context,
              'Editar detalles',
              'edit',
              onEditDetails,
            ),
            _buildActionTile(
              context,
              'Marcar inactivo',
              'block',
              onMarkInactive,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Opciones adicionales',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            _buildActionTile(
                context, 'Duplicar entrada', 'content_copy', () {}),
            _buildActionTile(context, 'Exportar datos', 'download', () {}),
            _buildActionTile(context, 'Enviar credencial', 'send', () {}),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    String title,
    String iconName,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 6.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
    );
  }
}
