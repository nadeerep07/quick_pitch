class TaskPostModel {
  final String id;
  final String posterId;
  final String title;
  final String description;
  final double budget;
  final String? location;
  final List<String> skills;
  final String priority;
  final String preferredTime;
  final String phone;
  final String email;
  final DateTime deadline;
  final DateTime createdAt;
  final List<String>? imagesUrl;
  final String workType;
  final String? assignedFixerId;
  final String? assignedFixerName;
  final String status;
  final String posterName;
  final String posterImageUrl;


  TaskPostModel({
    required this.id,
    required this.posterId,
    required this.title,
    required this.description,
    required this.budget,
     this.location,
    required this.skills,
    required this.priority,
    required this.preferredTime,
    required this.phone,
    required this.email,
    required this.deadline,
    required this.createdAt,
    required this.workType,
    required this.status,
    required this.posterName,
    required this.posterImageUrl,
    this.assignedFixerId,
    this.imagesUrl,
    this.assignedFixerName,
   
  });

  factory TaskPostModel.fromMap(Map<String, dynamic> map, [ String? id ]) {
    return TaskPostModel(
      id: map['id'] ?? '',
      posterId: map['posterId'] ?? '',
      posterName: map['posterName'] ?? '',
      posterImageUrl: map['posterImageUrl'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      budget: map['budget'] is num
          ? (map['budget'] as num).toDouble()
          : double.tryParse(map['budget'].toString()) ?? 0.0,
      location: map['location'] ?? '',
      skills: map['skills'] is List
          ? List<String>.from(map['skills'])
          : [map['skills'].toString()], 
      priority: map['priority'] ?? '',
      preferredTime: map['preferredTime'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      deadline: DateTime.parse(map['deadline']),
      createdAt: DateTime.parse(map['createdAt']),
      workType: map['workType'] ?? '',
      status: map['status'] ?? 'pending',
      assignedFixerId: map['assignedFixerId'],
      assignedFixerName: map['assignedFixerName'],
      imagesUrl: map['imagesUrl'] != null
          ? List<String>.from(map['imagesUrl'])
          : null,
     
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'posterId': posterId,
      'title': title,
      'description': description,
      'budget': budget,
      'location': location,
      'skills': skills,
      'priority': priority,
      'preferredTime': preferredTime,
      'phone': phone,
      'email': email,
      'deadline': deadline.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'workType': workType,
      'status': status,
      'assignedFixerId': assignedFixerId,
      'assignedFixerName': assignedFixerName,
      'imagesUrl': imagesUrl,
      'posterName': posterName,
      'posterImageUrl': posterImageUrl
      
    };
  }
}
