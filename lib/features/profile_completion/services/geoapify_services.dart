import 'package:dio/dio.dart';

class LocationSuggestion {
  final String address;
  final double latitude;
  final double longitude;

  LocationSuggestion({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() => address;
}

class GeoapifyService {
  static const String _apiKey = "b8c337fb384442d39df4f464ae7cb6cc";
  final Dio _dio = Dio();

  Future<List<String>> fetchPlaceSuggestions(String query) async {
    try {
      final response = await _dio.get(
        "https://api.geoapify.com/v1/geocode/autocomplete",
        queryParameters: {
          "text": query,
          "apiKey": _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final features = data["features"] as List;

        return features
            .map((f) => f["properties"]["formatted"] as String)
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      print("Dio error: ${e.message}");
      return [];
    } catch (e) {
      print("Unexpected error: $e");
      return [];
    }
  }

  Future<List<LocationSuggestion>> fetchPlaceSuggestionsWithCoordinates(String query) async {
    try {
      final response = await _dio.get(
        "https://api.geoapify.com/v1/geocode/autocomplete",
        queryParameters: {
          "text": query,
          "apiKey": _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final features = data["features"] as List;

        return features.map((feature) {
          final properties = feature["properties"];
          final geometry = feature["geometry"];
          final coordinates = geometry["coordinates"] as List;

          return LocationSuggestion(
            address: properties["formatted"] as String,
            latitude: coordinates[1].toDouble(), // Geoapify returns [lng, lat]
            longitude: coordinates[0].toDouble(),
          );
        }).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      print("Dio error: ${e.message}");
      return [];
    } catch (e) {
      print("Unexpected error: $e");
      return [];
    }
  }
}