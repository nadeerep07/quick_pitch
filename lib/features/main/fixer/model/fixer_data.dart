class FixerData {
  final List<String>? skills;
  final String? certification;
  final String? coverImageUrl;
   final String bio;
   final String certificateStatus;
   final double latitude;
  final double longitude;

  FixerData({this.skills, this.certification, this.coverImageUrl, required this.bio,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.certificateStatus = 'pending'});

  Map<String, dynamic> toJson() => {
    if (skills != null) 'skills': skills,
     'bio': bio,
    if (certification != null) 'certification': certification,
    if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
    'certificateStatus': certificateStatus,
    'latitude': latitude,
    'longitude': longitude,

  };

  factory FixerData.fromJson(Map<String, dynamic> json) => FixerData(
    skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
    certification: json['certification'],
    coverImageUrl: json['coverImageUrl'],
     bio: json['bio'] ?? '',
    certificateStatus: json['certificateStatus'] ?? 'pending',
    latitude: json['latitude']?.toDouble() ?? 0.0,
    longitude: json['longitude']?.toDouble() ?? 0.0,
  );
}
 
 
   
    
    