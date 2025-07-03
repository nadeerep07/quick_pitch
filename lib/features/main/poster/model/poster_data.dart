

class PosterData {
  final int? totalPosts; // optional
  PosterData({this.totalPosts});

  Map<String, dynamic> toJson() => {
        if (totalPosts != null) 'totalPosts': totalPosts,
      };

  factory PosterData.fromJson(Map<String, dynamic> json) => PosterData(
        totalPosts: json['totalPosts'],
      );
}
