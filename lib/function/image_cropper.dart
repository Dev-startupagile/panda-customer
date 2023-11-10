import 'dart:io';

import 'package:image_cropper/image_cropper.dart';

Future<File?> cropImage({required File imageFile}) async {
  CroppedFile? croppedImage =
  await ImageCropper().cropImage(sourcePath: imageFile.path);
  if (croppedImage == null) return null;
  return File(croppedImage.path);
}