

class PosterData {
  final int? totalPosts; 
   final String? coverImageUrl;
   final String bio;
  PosterData({this.totalPosts,  this.coverImageUrl,
  required this.bio
});

  Map<String, dynamic> toJson() => {
        if (totalPosts != null) 'totalPosts': totalPosts,
            if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
               'bio': bio,

      };

  factory PosterData.fromJson(Map<String, dynamic> json) => PosterData(
        totalPosts: json['totalPosts'],
            coverImageUrl: json['coverImageUrl'],
             bio: json['bio'] ?? '',
      );
}

