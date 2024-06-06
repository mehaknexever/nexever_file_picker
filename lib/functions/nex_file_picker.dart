import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/return_model.dart';
import '../state/nex_file_picker_state.dart';

/// A helper class for picking files, images, and videos, with options for cropping and compression.
class FilePickerHelper {
  final picker = ImagePicker();
  CropAspectRatioPreset? cropAspectRatioPreset;
  late NexFilePickerState callback;

  /// Constructor for [FilePickerHelper].
  ///
  /// [callback] is an instance of [NexFilePickerState] that will handle the success and error states.
  FilePickerHelper(this.callback);

  /// Sets the aspect ratio preset for cropping images.
  ///
  /// [cropAspectRatioPreset] defines the aspect ratio preset to be used for cropping.
  void setCropping(CropAspectRatioPreset cropAspectRatioPreset) {
    this.cropAspectRatioPreset = cropAspectRatioPreset;
  }

  /// Opens a dialog to pick a file with specific extensions.
  ///
  /// [type] is a list of allowed file extensions. If not provided, defaults to common document extensions.
  void openAttachmentDialog({List<String>? type,required String fileType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions:
          type ?? ['pdf', 'docx', 'xlsx', 'pptx', 'doc', 'xls', 'ppt', 'txt'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      int sizeBytes = file.lengthSync();
      double sizeMb = sizeBytes / (1024 * 1024);
      callback.success(
        fileData: ReturnModel(
          filePath: file.path,
          fileName: file.path.split('/').last,
          fileExtension: getFileExtension(file.path),
          size: sizeMb,
        ),
        type: fileType,
      );
    } else {
      callback.error('No file selected.');
    }
  }

  /// Opens a bottom sheet to pick an image from the camera or gallery.
/*  void openImagePicker() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => GestureDetector(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: const BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: Colors.pinkAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x194A841C),
                                offset: Offset(0.0, 1.0),
                                blurRadius: 19,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Camera",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      if (await isCameraEnabled()) {
                        Navigator.pop(context);
                        cropAspectRatioPreset != null
                            ? getImageWithCropping(ImageSource.camera)
                            : getImageWithoutCropping(ImageSource.camera);
                      } else {
                        callback.error('Permission not granted');
                      }
                    },
                  ),
                  const SizedBox(width: 60),
                  GestureDetector(
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: Color(0xff6BBBAE),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x194A841C),
                                offset: Offset(0.0, 1.0),
                                blurRadius: 19,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.image_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Gallery",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      if (await isStorageEnabled()) {
                        Navigator.pop(context);
                        cropAspectRatioPreset != null
                            ? getImageWithCropping(ImageSource.gallery)
                            : getImageWithoutCropping(ImageSource.gallery);
                      } else {
                        callback.error('Permission not granted');
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.all(13.0),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusScopeNode());
        },
      ),
    );
  }*/

  /// Picks an image from the given source and crops it if cropping is enabled.
  ///
  /// [imageSource] specifies whether the image is from the camera or gallery.
  Future<void> getImageWithCropping(ImageSource imageSource , String type) async {
    XFile? imageFile = await picker.pickImage(source: imageSource);
    if (imageFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          cropAspectRatioPreset ?? CropAspectRatioPreset.square
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.cyan,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(minimumAspectRatio: 1.0),
        ],
      );
      if (croppedFile != null) {
        getImageCompressed(XFile(croppedFile.path), type);
      } else {
        getImageCompressed(imageFile, type);
      }
    } else {
      callback.error('No Image Selected');
    }
  }

  /// Picks a video and compresses it if necessary.
  Future<void> getVideo(String type) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      getVideoCompressed(XFile(result.files.single.path ?? ""),type);
    } else {
      callback.error('No Video Selected');
    }
  }

  /// Picks an image from the given source without cropping.
  ///
  /// [imageSource] specifies whether the image is from the camera or gallery.
  Future<void> getImageWithoutCropping(ImageSource imageSource, String type) async {
    XFile? imageFile = await picker.pickImage(source: imageSource);
    if (imageFile != null) {
      getImageCompressed(imageFile, type);
    } else {
      callback.error('No Image Selected');
    }
  }

  /// Compresses the given image file.
  ///
  /// [imageFile] is the image file to be compressed.
  Future<void> getImageCompressed(XFile imageFile, String type) async {
    final filePath = imageFile.path;
    var imgExtension = filePath.split(".").last;
    final splitted = filePath.split(".").first;
    final outPath = "${splitted}_out.$imgExtension";

    XFile? imageCompressed = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      rotate: 0,
      quality: 70,
      format: imgExtension.toLowerCase() == "png"
          ? CompressFormat.png
          : CompressFormat.jpeg,
    );

    if (imageCompressed != null) {
      File file = File(imageCompressed.path);
      int sizeBytes = file.lengthSync();
      double sizeMb = sizeBytes / (1024 * 1024);
      callback.success(
        fileData: ReturnModel(
          filePath: imageCompressed.path,
          fileName: imageCompressed.path.split('/').last,
          fileExtension: getFileExtension(imageCompressed.path),
          size: sizeMb,
        ),
        type: type,
      );
    } else {
      callback.error('Image compression failed');
    }
  }

  /// Compresses the given video file.
  ///
  /// [imageFile] is the video file to be compressed.
  Future<void> getVideoCompressed(XFile imageFile, String type) async {
    File file = File(imageFile.path);
    int sizeBytes = file.lengthSync();
    double sizeMb = sizeBytes / (1024 * 1024);

    if (sizeMb < 30) {
      callback.success(
        fileData: ReturnModel(
          filePath: imageFile.path,
          fileName: imageFile.path.split('/').last,
          fileExtension: getFileExtension(imageFile.path),
          size: sizeMb,
        ),
        type: type,
      );
      return;
    }

    // final info = await VideoCompress.compressVideo(
    //   file.path,
    //   quality: VideoQuality.Res960x540Quality,
    //   deleteOrigin: false,
    //   includeAudio: true,
    // );

    if (imageFile != null) {
      File compressedFile = File(imageFile.path ?? "");
      int compressedSizeBytes = compressedFile.lengthSync();
      double compressedSizeMb = compressedSizeBytes / (1024 * 1024);

      callback.success(
        fileData: ReturnModel(
          filePath: compressedFile.path,
          fileName: compressedFile.path.split('/').last,
          fileExtension: getFileExtension(compressedFile.path),
          size: compressedSizeMb,
        ),
        type: type,
      );
    } else {
      callback.error('Video compression failed');
    }
  }

  /// Checks if camera permissions are granted.
  ///
  /// Returns `true` if camera permissions are granted, otherwise `false`.
  Future<bool> isCameraEnabled() async {
    await Permission.camera.request();
    return await Permission.camera.isGranted;
  }

  /// Checks if storage permissions are granted.
  ///
  /// Returns `true` if storage permissions are granted, otherwise `false`.
  Future<bool> isStorageEnabled() async {
    await Permission.storage.request();
    return await Permission.storage.isGranted;
  }

  /// Extracts the file extension from a given file path.
  ///
  /// [filePath] is the path of the file.
  /// Returns the file extension as a string.
  String getFileExtension(String filePath) {
    int lastDotIndex = filePath.lastIndexOf('.');
    if (lastDotIndex != -1 && lastDotIndex != 0) {
      return filePath.substring(lastDotIndex + 1);
    } else {
      return '';
    }
  }
}
