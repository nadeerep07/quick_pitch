import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/add_work/work_text_field.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_work/bloc/fixer_work_bloc.dart';

class TextFieldsSection extends StatelessWidget {
  final ThemeData theme;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController timeController;
  final TextEditingController amountController;

  const TextFieldsSection({
    required this.theme,
    required this.titleController,
    required this.descriptionController,
    required this.timeController,
    required this.amountController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FixerWorksBloc, FixerWorksState>(
      builder: (context, state) {
        final isLoading = state is FixerWorksLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Work Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            WorkTextField(
              theme: theme,
              controller: titleController,
              label: 'Work Title',
              hint: 'Enter work title',
              icon: Icons.work_outline,
              enabled: !isLoading,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            WorkTextField(
              theme: theme,
              controller: descriptionController,
              label: 'Description',
              hint: 'Describe the work performed',
              icon: Icons.description_outlined,
              maxLines: 3,
              enabled: !isLoading,
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
                  child: WorkTextField(
                    theme: theme,
                    controller: timeController,
                    label: 'Time Taken',
                    hint: '2 hours, 1 day',
                    icon: Icons.access_time,
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter time taken';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: WorkTextField(
                    theme: theme,
                    controller: amountController,
                    label: 'Amount (₹)',
                    hint: 'Enter amount',
                    icon: Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid amount';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
