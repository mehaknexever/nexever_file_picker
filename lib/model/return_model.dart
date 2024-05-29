/// A model class that represents the details of a file.
class ReturnModel {
  /// The path of the file.
  String? filePath;

  /// The name of the file.
  String? fileName;

  /// The extension of the file.
  String? fileExtension;

  /// The size of the file in bytes.
  double? size;

  /// Creates an instance of [ReturnModel].
  ///
  /// All parameters are optional and can be `null`.
  ReturnModel({
    this.filePath,
    this.fileName,
    this.fileExtension,
    this.size,
  });

  /// Creates an instance of [ReturnModel] from a JSON object.
  ///
  /// The [json] parameter is expected to be a [Map] containing the keys
  /// `filePath`, `fileName`, `fileExtension`, and `size`.
  ReturnModel.fromJson(Map<String, dynamic> json) {
    filePath = json['filePath'];
    fileName = json['fileName'];
    fileExtension = json['fileExtension'];
    size = json['size'];
  }

  /// Converts an instance of [ReturnModel] to a JSON object.
  ///
  /// Returns a [Map] containing the keys `filePath`, `fileName`, `fileExtension`, and `size`.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['filePath'] = filePath;
    data['fileName'] = fileName;
    data['fileExtension'] = fileExtension;
    data['size'] = size;
    return data;
  }
}
