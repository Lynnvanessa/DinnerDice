class Alert {
  final String message;
  final AlertType type;
  final Duration duration;

  Alert({
    required this.message,
    required this.type,
    this.duration = const Duration(seconds: 4),
  });
}

enum AlertType {
  warning,
  success,
  error,
}
