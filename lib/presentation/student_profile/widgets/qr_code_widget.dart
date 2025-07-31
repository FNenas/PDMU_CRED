import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QrCodeWidget extends StatefulWidget {
  final String studentId;
  final String enrollmentNumber;

  const QrCodeWidget({
    Key? key,
    required this.studentId,
    required this.enrollmentNumber,
  }) : super(key: key);

  @override
  State<QrCodeWidget> createState() => _QrCodeWidgetState();
}

class _QrCodeWidgetState extends State<QrCodeWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'qr_code',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Código QR de Identificación',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 6.w,
                  ),
                ],
              ),
            ),
            if (_isExpanded) ...[
              SizedBox(height: 2.h),
              Center(
                child: GestureDetector(
                  onTap: _showEnlargedQR,
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: _buildQRCodePlaceholder(),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Matrícula: ${widget.enrollmentNumber}',
                textAlign: TextAlign.center,
                style: AppTheme.getDataTextStyle(
                  isLight: true,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Toca el código QR para ampliar',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQRCodePlaceholder() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // QR Code pattern simulation
          Expanded(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: 64,
              itemBuilder: (context, index) {
                // Create a pattern that looks like a QR code
                bool shouldFill = _getQRPattern(index);
                return Container(
                  decoration: BoxDecoration(
                    color: shouldFill ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(1),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _getQRPattern(int index) {
    // Create a pattern that resembles a QR code
    int row = index ~/ 8;
    int col = index % 8;

    // Corner squares (finder patterns)
    if ((row < 3 && col < 3) || (row < 3 && col > 4) || (row > 4 && col < 3)) {
      return (row == 0 ||
          row == 2 ||
          col == 0 ||
          col == 2 ||
          (row == 1 && col == 1));
    }

    // Data pattern (pseudo-random based on student ID)
    int hash = widget.studentId.hashCode + widget.enrollmentNumber.hashCode;
    return ((hash + index) % 3) == 0;
  }

  void _showEnlargedQR() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Expanded(
                  child: _buildQRCodePlaceholder(),
                ),
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    children: [
                      Text(
                        'Código QR de Identificación',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Matrícula: ${widget.enrollmentNumber}',
                        style: AppTheme.getDataTextStyle(
                          isLight: true,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cerrar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
