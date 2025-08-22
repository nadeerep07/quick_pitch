import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/screen/add_work_dialog.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/bloc/fixer_work_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/bloc/fixer_work_event.dart';

class WorkDetailDialog extends StatelessWidget {
  final FixerWork work;
  final ThemeData theme;
  final bool isOwner;

  const WorkDetailDialog({
    super.key,
    required this.work,
    required this.theme,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (work.images.isNotEmpty) _buildImageGallery(),
                    const SizedBox(height: 16),
                    _buildWorkDetails(),
                  ],
                ),
              ),
            ),
            if (isOwner) _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            work.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildImageGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Images',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: work.images.length,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: work.images[index],
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error, size: 40),
                        ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWorkDetails() {
    final dateFormatter = DateFormat('MMM dd, yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Description', work.description),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildDetailRow('Time Taken', work.time)),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDetailRow(
                'Amount',
                '₹${work.amount.toStringAsFixed(0)}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDetailRow('Date Added', dateFormatter.format(work.createdAt)),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            onPressed: () => _deleteWork(context),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => _editWork(context),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _editWork(BuildContext context) {
    Navigator.of(context).pop(); // Close current dialog
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: BlocProvider.of<FixerWorksBloc>(context),
            child: AddWorkDialog(
              fixerId: work.fixerId,
              theme: theme,
              editingWork: work,
            ),
          ),
    );
  }

  void _deleteWork(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Delete Work'),
            content: const Text(
              'Are you sure you want to delete this work? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(
                    dialogContext,
                  ).pop(); // Close confirmation dialog
                  Navigator.of(context).pop(); // Close detail dialog
                  context.read<FixerWorksBloc>().add(DeleteFixerWork(work));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
