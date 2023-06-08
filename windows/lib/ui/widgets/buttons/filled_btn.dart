import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class FilledBtn extends StatelessWidget {
  const FilledBtn({
    Key? key,
    required this.text,
    required this.onClicked,
    this.loading = false,
    this.enabled = true,
    this.fullWidth = true,
    this.background,
    this.textStyle,
  }) : super(key: key);
  final String text;
  final VoidCallback onClicked;
  final bool loading;
  final bool enabled;
  final bool fullWidth;
  final Color? background;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: 12,
      onTap: loading || !enabled ? null : onClicked,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: loading || !enabled
              ? AppColors.disabledSurface
              : background ?? AppColors.onSurface,
        ),
        width: !fullWidth ? null : double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: textStyle ??
                    AppTypography.bodySemiBold(
                      color: loading || !enabled
                          ? AppColors.onDisabledSurface
                          : AppColors.primary,
                    ),
              ),
            ),
            if (loading) const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
