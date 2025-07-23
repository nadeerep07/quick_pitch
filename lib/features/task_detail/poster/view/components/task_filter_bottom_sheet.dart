import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/task_detail/poster/viewmodel/cubit/task_filter_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showTaskFilterBottomSheet(BuildContext context) {
  final cubit = context.read<TaskFilterCubit>();
  final current = cubit.state;

  String selectedStatus = current.status;
  bool isDescending = current.newestFirst;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => StatefulBuilder(
      builder: (context, setModalState) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Filter Your Tasks", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),

              /// Status Dropdown
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Task Status',
                  border: OutlineInputBorder(),
                ),
                items: ['All', 'Pending', 'In Progress', 'Completed', 'Rejected']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setModalState(() => selectedStatus = val);
                },
              ),
              const SizedBox(height: 20),

              /// Sort Order Dropdown
              DropdownButtonFormField<bool>(
                value: isDescending,
                decoration: const InputDecoration(
                  labelText: 'Sort by Posting Date',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: true, child: Text('Newest to Oldest')),
                  DropdownMenuItem(value: false, child: Text('Oldest to Newest')),
                ],
                onChanged: (val) {
                  if (val != null) setModalState(() => isDescending = val);
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Apply Filter"),
                  onPressed: () {
                    cubit.updateAll(status: selectedStatus, newestFirst: isDescending);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    backgroundColor: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
