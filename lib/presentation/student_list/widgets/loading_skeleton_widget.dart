import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingSkeletonWidget extends StatefulWidget {
  final int itemCount;

  const LoadingSkeletonWidget({
    Key? key,
    this.itemCount = 10,
  }) : super(key: key);

  @override
  State<LoadingSkeletonWidget> createState() => _LoadingSkeletonWidgetState();
}

class _LoadingSkeletonWidgetState extends State<LoadingSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) => _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
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
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                _buildSkeletonAvatar(),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildSkeletonContent(),
                ),
                _buildSkeletonBadge(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonAvatar() {
    return Container(
      width: 15.w,
      height: 15.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.lightTheme.colorScheme.outline.withValues(
          alpha: _animation.value * 0.3,
        ),
      ),
    );
  }

  Widget _buildSkeletonContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60.w,
          height: 2.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.outline.withValues(
              alpha: _animation.value * 0.3,
            ),
            borderRadius: BorderRadius.circular(1.w),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: 40.w,
          height: 1.5.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.outline.withValues(
              alpha: _animation.value * 0.2,
            ),
            borderRadius: BorderRadius.circular(1.w),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: 50.w,
          height: 1.5.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.outline.withValues(
              alpha: _animation.value * 0.2,
            ),
            borderRadius: BorderRadius.circular(1.w),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: 35.w,
          height: 1.5.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.outline.withValues(
              alpha: _animation.value * 0.2,
            ),
            borderRadius: BorderRadius.circular(1.w),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonBadge() {
    return Container(
      width: 20.w,
      height: 3.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.outline.withValues(
          alpha: _animation.value * 0.2,
        ),
        borderRadius: BorderRadius.circular(1.w),
      ),
    );
  }
}
