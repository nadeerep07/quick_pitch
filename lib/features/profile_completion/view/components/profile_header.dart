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
    Widget imageWidget;

    if (profileImage != null) {
      imageWidget = CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(profileImage!),
      );
    } else if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      imageWidget = ClipOval(
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/avatar_photo_placeholder.jpg',
          image: profileImageUrl!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    } else {
      imageWidget = const CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('assets/images/avatar_photo_placeholder.jpg'),
      );
    }

    return Center(
      child: Stack(
        children: [
          imageWidget,
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditTap,
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.black,
                child: Icon(Icons.camera, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
