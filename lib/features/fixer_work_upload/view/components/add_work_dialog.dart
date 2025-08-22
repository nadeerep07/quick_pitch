import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/bloc/fixer_work_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/bloc/fixer_work_event.dart' show UpdateFixerWork, AddFixerWork;

class AddWorkDialog extends StatefulWidget {
  final String fixerId;
  final ThemeData theme;
  final FixerWork? editingWork;

  const AddWorkDialog({
    super.key,
    required this.fixerId,
    required this.theme,
    this.editingWork,
  });

  @override
  State<AddWorkDialog> createState() => _AddWorkDialogState();
}

class _AddWorkDialogState extends State<AddWorkDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();
  final _amountController = TextEditingController();

  List<XFile> _selectedImages = [];
  List<String> _existingImages = [];
  bool _isLoading = false;
  bool _isSubmitted = false; // Add this flag to prevent multiple submissions

  @override
  void initState() {
    super.initState();
    if (widget.editingWork != null) {
      _titleController.text = widget.editingWork!.title;
      _descriptionController.text = widget.editingWork!.description;
      _timeController.text = widget.editingWork!.time;
      _amountController.text = widget.editingWork!.amount.toString();
      _existingImages = List<String>.from(widget.editingWork!.images);
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
    return BlocListener<FixerWorksBloc, FixerWorksState>(
      listener: (context, state) {
        if (state is FixerWorksLoaded && _isSubmitted) {
          // Only pop if we successfully submitted and got loaded state
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          });
        } else if (state is FixerWorksError) {
          setState(() {
            _isLoading = false;
            _isSubmitted = false; // Reset submission flag on error
          });
          
          // Show error message
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          });
        } else if (state is FixerWorksLoading && _isSubmitted) {
          // Only show loading if we initiated the submission
          setState(() => _isLoading = true);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.editingWork != null ? 'Edit Work' : 'Add New Work',
                    style: widget.theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: _isLoading ? null : () {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildImageSection(),
                        const SizedBox(height: 16),
                        _buildTextFields(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    final totalImages = _existingImages.length + _selectedImages.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Images ($totalImages/5)',
              style: widget.theme.textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: (totalImages < 5 && !_isLoading) ? _pickImages : null,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Add Images'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (totalImages > 0)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: totalImages,
              itemBuilder: (context, index) {
                if (index < _existingImages.length) {
                  return _buildExistingImageItem(_existingImages[index]);
                } else {
                  final fileIndex = index - _existingImages.length;
                  return _buildSelectedImageItem(_selectedImages[fileIndex]);
                }
              },
            ),
          )
        else
          Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: _isLoading ? null : _pickImages,
              borderRadius: BorderRadius.circular(8),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 32,
                      color: Colors.grey,
                    ),
                    Text('Add Images', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExistingImageItem(String imageUrl) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.error),
              ),
            ),
          ),
          if (!_isLoading)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeExistingImage(imageUrl),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectedImageItem(XFile imageFile) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(imageFile.path),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          if (!_isLoading)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeSelectedImage(imageFile),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextFields() {
    return Column(
      children: [
        TextFormField(
          controller: _titleController,
          enabled: !_isLoading,
          decoration: InputDecoration(
            labelText: 'Work Title',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          enabled: !_isLoading,
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _timeController,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: 'Time Taken',
                  hintText: 'e.g., 2 hours, 1 day',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter time taken';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _amountController,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: 'Amount (₹)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid amount';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _isLoading ? null : () {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitWork,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.editingWork != null ? 'Update' : 'Add Work'),
        ),
      ],
    );
  }

  Future<void> _pickImages() async {
    if (_isLoading) return;
    
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      if (images.isNotEmpty && mounted) {
        setState(() {
          final remainingSlots =
              5 - _existingImages.length - _selectedImages.length;
          _selectedImages.addAll(images.take(remainingSlots));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick images: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeExistingImage(String imageUrl) {
    if (!_isLoading) {
      setState(() {
        _existingImages.remove(imageUrl);
      });
    }
  }

  void _removeSelectedImage(XFile imageFile) {
    if (!_isLoading) {
      setState(() {
        _selectedImages.remove(imageFile);
      });
    }
  }

  void _submitWork() {
    if (_isLoading || _isSubmitted) return; // Prevent multiple submissions
    
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitted = true;
        _isLoading = true;
      });

      final work = FixerWork(
        id: widget.editingWork?.id ?? '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        time: _timeController.text.trim(),
        amount: double.parse(_amountController.text),
        images: _existingImages,
        createdAt: widget.editingWork?.createdAt ?? DateTime.now(),
        fixerId: widget.fixerId,
      );

      if (widget.editingWork != null) {
        // Calculate images to delete
        final imagesToDelete = widget.editingWork!.images
            .where((url) => !_existingImages.contains(url))
            .toList();

        context.read<FixerWorksBloc>().add(
              UpdateFixerWork(
                work,
                newImageFiles: _selectedImages.isEmpty ? null : _selectedImages,
                imagesToDelete: imagesToDelete.isEmpty ? null : imagesToDelete,
              ),
            );
      } else {
        context.read<FixerWorksBloc>().add(
              AddFixerWork(
                work,
                imageFiles: _selectedImages.isEmpty ? null : _selectedImages,
              ),
            );
      }
    }
  }
}