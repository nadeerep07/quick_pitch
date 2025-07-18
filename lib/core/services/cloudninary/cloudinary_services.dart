import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

class CloudinaryService {
  static const _cloudName = 'duf8fq4xl';
  static const _uploadPreset = 'quickpitch_unsigned';

  final Dio _dio = Dio();

  Future<String> uploadFile(File file) async {
    final mimeTypeData = lookupMimeType(file.path)?.split('/') ?? ['image', 'jpeg'];

    final formData = FormData.fromMap({
      'upload_preset': _uploadPreset,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: p.basename(file.path),
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ),
    });

    final url = 'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

    try {
      final response = await _dio.post(url, data: formData);

      if (response.statusCode == 200) {
        final imageUrl = response.data['secure_url'];
        print("Uploaded to Cloudinary: $imageUrl");
        return imageUrl;
      } else {
        throw Exception(" Cloudinary upload failed: ${response.statusCode}");
      }
    } catch (e) {
     // print(" Dio Cloudinary upload error: $e");
      rethrow;
    }
  }
   Future<List<String>> uploadImagesToCloudinary(List<File> images) async {
    List<String> urls = [];
    for (var file in images) {
      final url = await uploadFile(file);
      urls.add(url);
    }
    return urls;
  }
}
