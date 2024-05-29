import 'dart:developer';

/// A class for logging application errors.
class AppLogs {
  /// A static variable to control whether logs should be displayed.
  static bool showLogs = true;

  /// Logs an error message with optional additional information.
  ///
  /// If [showLogs] is true, logs the error information.
  ///
  /// - [fileName]: The name of the file where the error occurred.
  /// - [error]: The error message to be logged.
  /// - [stackTrace]: An optional [StackTrace] object to provide the stack trace of the error.
  /// - [text]: An optional additional text message to be logged.
  void logError({
    required String fileName,
    required String error,
    StackTrace? stackTrace,
    String? text,
  }) {
    if (showLogs) {
      log(text.toString(),
          name: fileName, error: error, stackTrace: stackTrace);
    }
  }
}

/// An extension on [Object] to facilitate error logging.
extension ErrorLogs on Object {
  /// Logs an error message using the [AppLogs] class.
  ///
  /// - [error]: The error message to be logged.
  /// - [text]: An optional additional text message to be logged.
  /// - [stackTrace]: An optional [StackTrace] object to provide the stack trace of the error.
  void logError({
    required String error,
    String? text,
    StackTrace? stackTrace,
  }) {
    AppLogs().logError(
        fileName: runtimeType.toString(),
        error: error,
        stackTrace: stackTrace,
        text: text);
  }
}