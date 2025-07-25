import 'dart:io';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final File? profileImage;
  final String? profileImageUrl;
  final VoidCallback onEditTap;

  const ProfileHeader({
    super.key,
    required this.profileImage,
    required this.profileImageUrl,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (profileImage != null) {
      imageProvider = FileImage(profileImage!);
    } else if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(profileImageUrl!);
    } else {
      imageProvider = const AssetImage('assets/images/default_user.png');
    }

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: imageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditTap,
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.black,
                child: Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
