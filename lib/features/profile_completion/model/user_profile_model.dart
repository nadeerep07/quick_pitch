class UserProfileModel {
  final String uid;
  final String name;
  final String phone;
  final String bio;
  final String? profileImageUrl;
  final String role;
  final String? certification;
  final List<String>? skills;
  final String location;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.bio,
    this.profileImageUrl,
    this.certification,
    required this.role,
    this.skills,
    required this.location,
  });

Map<String, dynamic> toJson() {
  final data = {
    'uid': uid,
    'name': name,
    'phone': phone,
    'bio': bio,
    'role': role,
    'location': location,
  };

  if (profileImageUrl != null) {
    data['profileImageUrl'] = profileImageUrl ?? '';
  }

  if (certification != null) {
    data['certification'] = certification ?? '';
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
      certification: json['certification'],
      role: json['role'],
      location: json['location'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
    );
  }
  @override
  String toString() {
    return 'UserProfileModel(uid: $uid, name: $name, phone: $phone, bio: $bio, profileImageUrl: $profileImageUrl, role: $role, certification: $certification, skills: $skills, location: $location)';
  }
}
