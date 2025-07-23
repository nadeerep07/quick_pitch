import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/main/fixer/model/fixer_data.dart';
import 'package:quick_pitch_app/features/main/poster/model/poster_data.dart';

class UserProfileModel {
  final String uid;
  final String name;
  final String phone;
  final String? profileImageUrl;
  final String role;
  final String location;
  final FixerData? fixerData;
  final PosterData? posterData;
  final DateTime createdAt;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.phone,

    this.profileImageUrl,
    required this.role,
    required this.location,
    this.fixerData,
    this.posterData,
    required this.createdAt,
  });

  Map<String, dynamic> toRoleJson() {
    final Map<String, dynamic> data = {
      'uid': uid,
      'name': name,
      'phone': phone,
      'role': role,
      'location': location,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      'createdAt': createdAt,
    };

    if (role == 'fixer' && fixerData != null) {
      data['fixerData'] = fixerData!.toJson();
    }

    if (role == 'poster' && posterData != null) {
      data['posterData'] = posterData!.toJson();
    }

    return data;
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',

      profileImageUrl: json['profileImageUrl'],
      role: json['role'] ?? 'poster',
      location: json['location'] ?? '',
      createdAt:
          json['createdAt'] != null
              ? (json['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
      fixerData:
          json['fixerData'] != null
              ? FixerData.fromJson(json['fixerData'])
              : null,
      posterData:
          json['posterData'] != null
              ? PosterData.fromJson(json['posterData'])
              : null,
    );
  }

  @override
  String toString() {
    return 'UserProfileModel(uid: $uid, name: $name, phone: $phone, profileImageUrl: $profileImageUrl, role: $role, location: $location,createdAt: $createdAt,';
  }
  UserProfileModel copyWith({
  String? uid,
  String? name,
  String? phone,
  String? profileImageUrl,
  String? role,
  String? location,
  FixerData? fixerData,
  PosterData? posterData,
  DateTime? createdAt,
}) {
  return UserProfileModel(
    uid: uid ?? this.uid,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    role: role ?? this.role,
    location: location ?? this.location,
    fixerData: fixerData ?? this.fixerData,
    posterData: posterData ?? this.posterData,
    createdAt: createdAt ?? this.createdAt,
  );
}

}
