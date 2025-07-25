

class PosterData {
  final List<String>? postIds;
  final String? coverImageUrl;
  final String bio;

  PosterData({
    this.postIds,
    this.coverImageUrl,
    required this.bio,
  });

  PosterData copyWith({List<String>? postIds}) {
    return PosterData(
      bio: bio,
      postIds: postIds ?? this.postIds,
    );
  }
  Map<String, dynamic> toJson() => {
        if (postIds != null) 'postIds': postIds,
        if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
        'bio': bio,
      };

  factory PosterData.fromJson(Map<String, dynamic> json) => PosterData(
        postIds: json['postIds'] != null
            ? List<String>.from(json['postIds'])
            : null,
        coverImageUrl: json['coverImageUrl'],
        bio: json['bio'] ?? '',
      );
}


