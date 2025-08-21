import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/app_text_field.dart';
import 'package:quick_pitch_app/features/poster_task/viewmodel/cubit/task_post_cubit.dart';

class TaskLocationSelector extends StatelessWidget {
  final TaskPostCubit cubit;
  const TaskLocationSelector({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskPostCubit, TaskPostState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Location"),
            Stack(
              children: [
                AppTextField(
                  controller: cubit.locationController,
                  label: "Enter or select task location",
                  isRequired: true,
                  onChanged: cubit.fetchLocationSuggestions, // 👈 fetch while typing
                  onLocationTap: cubit.setCurrentLocationFromDevice,
                  sufixicon: Icons.location_on_outlined,
                ),
                if (cubit.locationSuggestions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cubit.locationSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = cubit.locationSuggestions[index];
                        return ListTile(
                          title: Text(suggestion.address),
                          onTap: () => cubit.selectLocation(suggestion),
                        );
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

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );
}

