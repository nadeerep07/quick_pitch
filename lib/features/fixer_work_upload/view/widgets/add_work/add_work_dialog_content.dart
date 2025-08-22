import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/add_work/action_buttons.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/add_work/dialog_header.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/add_work/image_section.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/add_work/text_fields_section.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_add_work/cubit/add_work_dialog_cubit.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_work/bloc/fixer_work_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_work/bloc/fixer_work_event.dart';

class AddWorkDialogContent extends StatefulWidget {
  final String fixerId;
  final ThemeData theme;
  final FixerWork? editingWork;

  const AddWorkDialogContent({
    super.key,
    required this.fixerId,
    required this.theme,
    this.editingWork,
  });

  @override
  State<AddWorkDialogContent> createState() => _AddWorkDialogContentState();
}

class _AddWorkDialogContentState extends State<AddWorkDialogContent> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.editingWork != null) {
      _titleController.text = widget.editingWork!.title;
      _descriptionController.text = widget.editingWork!.description;
      _timeController.text = widget.editingWork!.time;
      _amountController.text = widget.editingWork!.amount.toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FixerWorksBloc, FixerWorksState>(
          listener: (context, state) {
            final dialogCubit = context.read<AddWorkDialogCubit>();

            if (state is FixerWorksLoaded && dialogCubit.state.isSubmitted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              });
            } else if (state is FixerWorksError) {
              dialogCubit.setSubmitted(false);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _showErrorSnackBar(context, state.message);
                }
              });
            }
          },
        ),
      ],
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
          child: Card(
            elevation: 16,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Section
                DialogHeader(
                  theme: widget.theme,
                  editingWork: widget.editingWork,
                  onClose: () => _closeDialog(context),
                ),

                // Content Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AddImageSection(
                            theme: widget.theme,
                            onPickImages: () => _pickImages(context),
                          ),
                          const SizedBox(height: 28),
                          TextFieldsSection(
                            theme: widget.theme,
                            titleController: _titleController,
                            descriptionController: _descriptionController,
                            timeController: _timeController,
                            amountController: _amountController,
                          ),
                          const SizedBox(height: 32),
                          ActionButtons(
                            theme: widget.theme,
                            editingWork: widget.editingWork,
                            onCancel: () => _closeDialog(context),
                            onSubmit: () => _submitWork(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      if (images.isNotEmpty && mounted) {
        context.read<AddWorkDialogCubit>().addSelectedImages(images);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(context, 'Failed to pick images: $e');
      }
    }
  }

  void _submitWork(BuildContext context) {
    final dialogCubit = context.read<AddWorkDialogCubit>();

    if (dialogCubit.state.isSubmitted) return;

    if (_formKey.currentState!.validate()) {
      dialogCubit.setSubmitted(true);

      final work = FixerWork(
        id: widget.editingWork?.id ?? '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        time: _timeController.text.trim(),
        amount: double.parse(_amountController.text),
        images: dialogCubit.state.existingImages,
        createdAt: widget.editingWork?.createdAt ?? DateTime.now(),
        fixerId: widget.fixerId,
      );

      if (widget.editingWork != null) {
        final imagesToDelete =
            widget.editingWork!.images
                .where((url) => !dialogCubit.state.existingImages.contains(url))
                .toList();

        context.read<FixerWorksBloc>().add(
          UpdateFixerWork(
            work,
            newImageFiles:
                dialogCubit.state.selectedImages.isEmpty
                    ? null
                    : dialogCubit.state.selectedImages,
            imagesToDelete: imagesToDelete.isEmpty ? null : imagesToDelete,
          ),
        );
      } else {
        context.read<FixerWorksBloc>().add(
          AddFixerWork(
            work,
            imageFiles:
                dialogCubit.state.selectedImages.isEmpty
                    ? null
                    : dialogCubit.state.selectedImages,
          ),
        );
      }
    }
  }

  void _closeDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
