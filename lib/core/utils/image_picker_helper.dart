import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    return picked != null ? File(picked.path) : null;
  }
}
