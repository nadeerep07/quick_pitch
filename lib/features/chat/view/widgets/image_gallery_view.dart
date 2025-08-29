import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/chat/model/message_model.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/cubit/image_gallery_cubit.dart';

class ImageGalleryView extends StatelessWidget {
  final List<AttachmentModel> images;

  const ImageGalleryView({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    return BlocProvider(
      create: (_) => ImageGalleryCubit(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: BlocBuilder<ImageGalleryCubit, int>(
            builder: (context, currentIndex) {
              return Text(
                '${currentIndex + 1} of ${images.length}',
                style: const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        body: PageView.builder(
          controller: pageController,
          itemCount: images.length,
          onPageChanged: (index) =>
              context.read<ImageGalleryCubit>().updateIndex(index),
          itemBuilder: (context, index) {
            return Center(
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: images[index].url,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error, color: Colors.white, size: 50),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
