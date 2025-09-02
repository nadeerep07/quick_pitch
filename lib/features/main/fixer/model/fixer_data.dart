import 'package:quick_pitch_app/features/review/model/review_model.dart';

class FixerData {
  final List<String>? skills;
  final String? certification;
  final String? coverImageUrl;
  final String bio;
  final String certificateStatus;
  final double latitude;
  final double longitude;
  final RatingStats? ratingStats;
  final double? distance; 

  FixerData({
    this.skills,
    this.certification,
    this.coverImageUrl,
    required this.bio,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.certificateStatus = 'pending',
    this.ratingStats,
    this.distance, 
  });

  Map<String, dynamic> toJson() => {
    if (skills != null) 'skills': skills,
    'bio': bio,
    if (certification != null) 'certification': certification,
    if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
    'certificateStatus': certificateStatus,
    'latitude': latitude,
    'longitude': longitude,
    if (ratingStats != null) 'ratingStats': ratingStats!.toJson(),
    if (distance != null) 'distance': distance, // ✅ added here
  };

  factory FixerData.fromJson(Map<String, dynamic> json) => FixerData(
    skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
    certification: json['certification'],
    coverImageUrl: json['coverImageUrl'],
    bio: json['bio'] ?? '',
    certificateStatus: json['certificateStatus'] ?? 'pending',
    latitude: json['latitude']?.toDouble() ?? 0.0,
    longitude: json['longitude']?.toDouble() ?? 0.0,
    ratingStats: json['ratingStats'] != null 
        ? RatingStats.fromJson(json['ratingStats']) 
        : null,
    distance: json['distance']?.toDouble(), 
  );

  FixerData copyWith({
    List<String>? skills,
    String? certification,
    String? coverImageUrl,
    String? bio,
    String? certificateStatus,
    double? latitude,
    double? longitude,
    RatingStats? ratingStats,
    double? distance,
  }) {
    return FixerData(
      skills: skills ?? this.skills,
      certification: certification ?? this.certification,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      bio: bio ?? this.bio,
      certificateStatus: certificateStatus ?? this.certificateStatus,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      ratingStats: ratingStats ?? this.ratingStats,
      distance: distance ?? this.distance, 
    );
  }
}
