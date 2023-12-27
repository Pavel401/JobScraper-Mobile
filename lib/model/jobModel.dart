import 'package:equatable/equatable.dart';

class JobModel extends Equatable {
  final String id;
  final String title;
  final String location;
  final int createdAt;
  final String company;
  final String applyUrl;
  final String imageUrl;

  JobModel({
    required this.id,
    required this.title,
    required this.location,
    required this.createdAt,
    required this.company,
    required this.applyUrl,
    required this.imageUrl,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'].toString(),
      title: json['title'] ?? "",
      location: json['location'] ?? "",
      createdAt: json['createdAt'] != null
          ? int.parse(json['createdAt'].toString())
          : 0,
      company: json['company'] ?? "",
      applyUrl: json['applyUrl'] ?? "",
      imageUrl: json['ImageUrl'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'createdAt': createdAt,
      'company': company,
      'applyUrl': applyUrl,
      'ImageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        location,
        createdAt,
        company,
        applyUrl,
        imageUrl,
      ];
}
