import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import '../data/enums/PickerType.dart';
import 'MediaPermissionHandler.dart';

class FilePickerUtil {
  ///Only pick images
  static Future<List<Media>?> pickImages({
    PickerType pickerType = PickerType.gallery,
    int count = 1,
    int cropHeight = -1,
    int cropWidth = -1,
    bool showCamera = true,
  }) async {
    var permissionResult = pickerType == PickerType.camera
        ? await MediaPermissionHandler.requestCameraPermission()
        : await MediaPermissionHandler.requestGalleryPermission();

    List<Media> mediaList = [];

    if (permissionResult) {
      if (pickerType == PickerType.gallery) {
        mediaList = await ImagePickers.pickerPaths(
          selectCount: count,
          cropConfig: CropConfig(
              enableCrop: true, height: cropHeight, width: cropWidth),
          showCamera: showCamera,
        );
      } else if (pickerType == PickerType.camera) {
        var cameraMedia = await ImagePickers.openCamera(
          cropConfig: CropConfig(
              enableCrop: true, height: cropHeight, width: cropWidth),
        );
        mediaList.add(cameraMedia!);
      }

      return mediaList;
    } else {
      //show permission dialog
      return null;
    }
  }

  ///Only pick videos
  static Future<List<Media>?> pickMedia({
    PickerType pickerType = PickerType.gallery,
    int count = 1,
    int cropHeight = -1,
    int cropWidth = -1,
    bool showCamera = true,
  }) async {
    var permissionResult = pickerType == PickerType.camera
        ? await MediaPermissionHandler.requestCameraPermission()
        : await MediaPermissionHandler.requestGalleryPermission();

    List<Media> mediaList = [];

    if (permissionResult) {
      if (pickerType == PickerType.gallery) {
        mediaList = await ImagePickers.pickerPaths(
          galleryMode: GalleryMode.all,
          selectCount: count,
          cropConfig: CropConfig(
              enableCrop: true, height: cropHeight, width: cropWidth),
          showCamera: showCamera,
        );
      } else if (pickerType == PickerType.camera) {
        var cameraMedia = await ImagePickers.openCamera(
          cropConfig: CropConfig(
              enableCrop: true, height: cropHeight, width: cropWidth),
        );
        mediaList.add(cameraMedia!);
      }

      return mediaList;
    } else {
      //show permision dialog
      return null;
    }
  }

  static Future<List<PlatformFile>?> pickFile() async {
    try {
      var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
         /* "jpeg",
          "jpg",
          "svg",
          "png",*/
          "doc",
          "docx",
          "xls",
          "xlsx",
          "pdf",
        ],
      );
      if (result != null) {
        return result.files;
      } else {
        return null;
      }
    } on Exception catch (e) {
      print("Error picking file $e");
      return null;
    }
  }

  static Future<File?> pickSingleFile() async {
    try {
      var result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: [
          "doc",
          "docx",
          "xls",
          "xlsx",
          "pdf",
        ],
      );
      if (result != null) {
        File file = File(result.files.single.path!);
        return file;
      } else {
        return null;
      }
    } on Exception catch (e) {
      print("Error picking file $e");
      return null;
    }
  }
}
