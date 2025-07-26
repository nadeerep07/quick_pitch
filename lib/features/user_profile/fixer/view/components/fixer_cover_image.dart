import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildCoverImage(String imageUrl, double height) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    fit: BoxFit.cover,
    height: height,
    width: double.infinity,
    placeholder: (context, url) => Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: double.infinity,
        color: Colors.white,
      ),
    ),
    errorWidget: (context, url, error) => Container(
      height: height,
      color: Colors.grey[300],
      child: Icon(Icons.broken_image),
    ),
  );
}
