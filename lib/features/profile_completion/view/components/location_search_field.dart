import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/profile_completion/viewmodel/cubit/complete_profile_cubit.dart';

class LocationSearchField extends StatelessWidget {
  final CompleteProfileCubit cubit;
  final String label;
  final bool isRequired;

  const LocationSearchField({
    super.key,
    required this.cubit,
    this.label = "Location",
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteProfileCubit, CompleteProfileState>(
      bloc: cubit,
      builder: (context, state) {
        final showSuggestions = state is PlaceSuggestionsUpdated && 
                               state.suggestions.isNotEmpty && 
                               cubit.showLocationSuggestions;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main text field
            TextFormField(
              controller: cubit.locationController,
              focusNode: cubit.locationFocusNode,
              decoration: InputDecoration(
                labelText: isRequired ? "$label *" : label,
                hintText: "Enter your location",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Current location button
                    IconButton(
                      icon: const Icon(Icons.my_location, color: Colors.blue),
                      onPressed: () {
                        cubit.setCurrentLocationFromDevice();
                      },
                      tooltip: "Use current location",
                    ),
                    // Clear button (only show when text is not empty)
                    if (cubit.locationController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          cubit.clearLocationField();
                        },
                      ),
                  ],
                ),
              ),
              validator: isRequired
                  ? (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your ${label.toLowerCase()}";
                      }
                      return null;
                    }
                  : null,
              onChanged: (value) {
                cubit.onLocationTextChanged(value);
              },
              onTap: () {
                cubit.onLocationFieldTapped();
              },
            ),
            
            // Suggestions dropdown
            if (showSuggestions)
              Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cubit.placeSuggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = cubit.placeSuggestions[index];
                    return ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 20,
                      ),
                      title: Text(
                        suggestion,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        cubit.selectLocationSuggestion(suggestion, index);
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}