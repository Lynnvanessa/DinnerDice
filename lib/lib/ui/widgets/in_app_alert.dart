import 'package:diner_dice/data/models/alert.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class PopupNotification extends StatelessWidget {
  const PopupNotification({
    Key? key,
    required this.alert,
    required this.onDismiss,
  }) : super(key: key);

  final Alert alert;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: const Color(0xFFF1E589),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.error),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(alert.message),
                    ),
                  ),
                  InkWell(
                    onTap: onDismiss,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.close),
                    ),
                  )
                ],
              ),
            ),
            _InAppAlertVisibilityIndicator(
              onEnd: onDismiss,
              duration: alert.duration,
            ),
          ],
        ),
      ),
    );
  }
}

class _InAppAlertVisibilityIndicator extends StatefulWidget {
  const _InAppAlertVisibilityIndicator({
    Key? key,
    required this.onEnd,
    required this.duration,
  }) : super(key: key);

  final VoidCallback onEnd;
  final Duration duration;

  @override
  State<_InAppAlertVisibilityIndicator> createState() =>
      _InAppAlertVisibilityIndicatorState();
}

class _InAppAlertVisibilityIndicatorState
    extends State<_InAppAlertVisibilityIndicator> {
  double width = 300;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        width = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: AnimatedContainer(
        width: width,
        height: 5,
        decoration: BoxDecoration(color: AppColors.primary),
        duration: widget.duration,
        onEnd: widget.onEnd,
      ),
    );
  }
}
