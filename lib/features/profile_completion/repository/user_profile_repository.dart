import 'dart:io';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:quick_pitch_app/core/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class UserProfileRepository {
  final UserProfileService service = UserProfileService();

  Future<void> saveProfile(UserProfileModel profile) async {
    await service.saveProfile(profile);
  }

  Future<String> uploadFileToCloudinary(File file) async {
    const cloudName = 'duf8fq4xl'; 
    const uploadPreset = 'quickpitch_unsigned'; 
    final dio = Dio();
    final mimeTypeData = lookupMimeType(file.path)?.split('/') ?? ['image', 'jpeg'];

    final formData = FormData.fromMap({
      'upload_preset': uploadPreset,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: p.basename(file.path),
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ),
    });

    final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    try {
      final response = await dio.post(url, data: formData);

      if (response.statusCode == 200) {
        final imageUrl = response.data['secure_url'];
        print(" Uploaded to Cloudinary: $imageUrl");
        return imageUrl;
      } else {
        throw Exception(" Cloudinary upload failed: ${response.statusCode}");
      }
    } catch (e) {
      print(" Dio Cloudinary upload error: $e");
      rethrow;
    }
  }
  
  Future<String> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return 'Location services disabled';

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return 'Permission denied';
    }

    final pos = await Geolocator.getCurrentPosition();
    final placemarks = await geo.placemarkFromCoordinates(
      pos.latitude,
      pos.longitude,
    );

    final place = placemarks.first;
    return '${place.name}, ${place.administrativeArea}, ${place.country}';//${place.locality}
  }
}
