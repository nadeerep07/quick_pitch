import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/work_detail/cubit/work_detail_cubit.dart';

class WorkDetailImageCard extends StatelessWidget {
  final String url;
  final int index;
  final ThemeData theme;

  const WorkDetailImageCard({super.key, required this.url, required this.index, required this.theme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<WorkDetailCubit>().showImageFullScreen(index),
      child: Hero(
        tag: 'work_image_$index',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: url,
            width: 180,
            height: 220,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}