import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/chat/view/widgets/individual_message/image_preview_section.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/message_input/cubit/message_input_cubit.dart';


class ImagePreview extends StatelessWidget {
  final List<File> images;
  const ImagePreview({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ImagePreviewSection(
        images: images,
        onRemove: (index) =>
            context.read<MessageInputCubit>().removeImage(index),
      ),
    );
  }
}
