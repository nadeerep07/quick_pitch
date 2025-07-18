import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/main/fixer/model/fixer_data.dart';
import 'package:quick_pitch_app/features/main/poster/model/poster_data.dart';

class UserProfileModel {
  final String uid;
  final String name;
  final String phone;
  final String bio;
  final String? profileImageUrl;
  final String role;
  // final String? certification;
  // final List<String>? skills;
  final String location;
  final FixerData? fixerData;
  final PosterData? posterData;
  final DateTime createdAt;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.bio,
    this.profileImageUrl,
    //this.certification,
    required this.role,
   // this.skills,
    required this.location,
    this.fixerData,
    this.posterData,
   required this.createdAt
  });

Map<String, dynamic> toRoleJson() {
  final Map<String, dynamic> data = {
    'uid': uid,
    'name': name,
    'phone': phone,
    'bio': bio,
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
      uid: json['uid'],
      name: json['name'],
      phone: json['phone'],
      bio: json['bio'],
      profileImageUrl: json['profileImageUrl'],
    //  certification: json['certification'],
   createdAt: json['createdAt'] != null
    ? (json['createdAt'] as Timestamp).toDate()
    : DateTime.now(), 


      role: json['role'],
      location: json['location'],
     // skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      fixerData: json['fixerData'] != null
          ? FixerData.fromJson(json['fixerData'])
          : null,
      posterData: json['posterData'] != null
          ? PosterData.fromJson(json['posterData'])
          : null,
    );
  }
  @override
  String toString() {
    return 'UserProfileModel(uid: $uid, name: $name, phone: $phone, bio: $bio, profileImageUrl: $profileImageUrl, role: $role, location: $location,createdAt: $createdAt)';
  }
}
