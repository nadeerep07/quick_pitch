// features/explore/poster/repository/poster_explore_repository.dart

import 'package:quick_pitch_app/features/main/fixer/model/fixer_data.dart';

extension FixerDataExtension on FixerData {
  FixerData copyWith({
    List<String>? skills,
    String? certification,
    String? coverImageUrl,
    String? bio,
    String? certificateStatus,
    double? latitude,
    double? longitude,
    double? distance,
  }) {
    return FixerData(
      skills: skills ?? this.skills,
      certification: certification ?? this.certification,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      bio: bio ?? this.bio,
      certificateStatus: certificateStatus ?? this.certificateStatus,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  double? get distance => null; // This should be added to your FixerData model
}
