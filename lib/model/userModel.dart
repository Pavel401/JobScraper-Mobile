import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? id;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final Timestamp createdAt;
  final DateTime dob;
  final String? gender;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? about;
  final String? resumeUrl;
  final String? githubUrl;
  final String? linkedinUrl;
  final String? twitterUrl;
  final String? websiteUrl;
  final List<String?> skills;
  final List<String?> tokens;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.photoUrl,
    required this.createdAt,
    required this.dob,
    required this.gender,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.about,
    required this.resumeUrl,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.twitterUrl,
    required this.websiteUrl,
    required this.skills,
    required this.tokens,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        createdAt,
        dob,
        gender,
        phoneNumber,
        address,
        city,
        state,
        country,
        pincode,
        about,
        resumeUrl,
        githubUrl,
        linkedinUrl,
        twitterUrl,
        websiteUrl,
        skills,
        tokens,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'dob': dob,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'about': about,
      'resumeUrl': resumeUrl,
      'githubUrl': githubUrl,
      'linkedinUrl': linkedinUrl,
      'twitterUrl': twitterUrl,
      'websiteUrl': websiteUrl,
      'skills': skills,
      'tokens': tokens,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? "",
      email: json['email'] ?? "",
      displayName: json['displayName'] ?? "",
      photoUrl: json['photoUrl'] ?? "",
      createdAt: json['createdAt'] as Timestamp,
      dob: (json['dob'] as Timestamp).toDate(),
      gender: json['gender'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      address: json['address'] ?? "",
      city: json['city'] ?? "",
      state: json['state'] ?? "",
      country: json['country'] ?? "",
      pincode: json['pincode'] ?? "",
      about: json['about'] ?? "",
      resumeUrl: json['resumeUrl'] ?? "",
      githubUrl: json['githubUrl'] ?? "",
      linkedinUrl: json['linkedinUrl'] ?? "",
      twitterUrl: json['twitterUrl'] ?? "",
      websiteUrl: json['websiteUrl'] ?? "",
      skills: (json['skills'] as List<dynamic>).cast<String>(),
      tokens: (json['tokens'] as List<dynamic>).cast<String>(),
    );
  }
}
