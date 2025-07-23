// profile_header.dart
import 'dart:io';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final File? profileImage;
  final VoidCallback onEditTap;

  const ProfileHeader({
    super.key,
    required this.profileImage,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: profileImage != null
                ? FileImage(profileImage!)
                : const AssetImage('assets/images/default_user.png')
                    as ImageProvider,
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
