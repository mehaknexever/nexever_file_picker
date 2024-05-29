import '../model/return_model.dart';

/// An abstract class to define the state handling for file picking operations.
abstract class NexFilePickerState {
  /// Called when a file is successfully picked.
  ///
  /// [fileData] represents the details of the file that was picked.
  /// [type] represents the type or category of the file.
  void success({ReturnModel? fileData, String? type});

  /// Called when an error occurs during the file picking process.
  ///
  /// [error] represents the error that occurred.
  void error(var error);
}
