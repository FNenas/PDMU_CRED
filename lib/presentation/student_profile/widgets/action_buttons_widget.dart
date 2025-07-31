import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onGenerateCredential;
  final VoidCallback? onShareProfile;
  final VoidCallback? onEditProfile;
  final bool isEditing;
  final VoidCallback? onSaveChanges;
  final VoidCallback? onCancelEdit;

  const ActionButtonsWidget({
    Key? key,
    this.onGenerateCredential,
    this.onShareProfile,
    this.onEditProfile,
    this.isEditing = false,
    this.onSaveChanges,
    this.onCancelEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          if (!isEditing) ...[
            // Generate Credential Button
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton.icon(
                onPressed: onGenerateCredential,
                icon: CustomIconWidget(
                  iconName: 'badge',
                  color: Colors.white,
                  size: 5.w,
                ),
                label: Text(
                  'Generar Credencial',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Action Buttons Row
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 6.h,
                    child: OutlinedButton.icon(
                      onPressed: onShareProfile,
                      icon: CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                      label: Text(
                        'Compartir',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: SizedBox(
                    height: 6.h,
                    child: OutlinedButton.icon(
                      onPressed: onEditProfile,
                      icon: CustomIconWidget(
                        iconName: 'edit',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                      label: Text(
                        'Editar',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Edit Mode Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 6.h,
                    child: OutlinedButton.icon(
                      onPressed: onCancelEdit,
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.getStatusColor('error'),
                        size: 5.w,
                      ),
                      label: Text(
                        'Cancelar',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.getStatusColor('error'),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppTheme.getStatusColor('error'),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: SizedBox(
                    height: 6.h,
                    child: ElevatedButton.icon(
                      onPressed: onSaveChanges,
                      icon: CustomIconWidget(
                        iconName: 'save',
                        color: Colors.white,
                        size: 5.w,
                      ),
                      label: Text(
                        'Guardar',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.getStatusColor('enrolled'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
