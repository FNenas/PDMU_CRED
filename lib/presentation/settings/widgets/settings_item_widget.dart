import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? value;
  final String iconName;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showDivider;

  const SettingsItemWidget({
    Key? key,
    required this.title,
    this.subtitle,
    this.value,
    required this.iconName,
    this.onTap,
    this.trailing,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle != null
                          ? SizedBox(height: 0.5.h)
                          : SizedBox.shrink(),
                      subtitle != null
                          ? Text(
                              subtitle!,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                value != null
                    ? Text(
                        value!,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    : SizedBox.shrink(),
                SizedBox(width: 2.w),
                trailing ??
                    CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
              ],
            ),
          ),
        ),
        showDivider
            ? Divider(
                height: 1,
                thickness: 0.5,
                color: AppTheme.lightTheme.dividerColor,
                indent: 14.w,
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
