class FixerData {
  final List<String>? skills;
  final String? certification;

  FixerData({this.skills, this.certification});

  Map<String, dynamic> toJson() => {
        if (skills != null) 'skills': skills,
        if (certification != null) 'certification': certification,
      };

  factory FixerData.fromJson(Map<String, dynamic> json) => FixerData(
        skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
        certification: json['certification'],
      );
}
