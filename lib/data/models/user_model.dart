import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String fullName;
  String gender;
  String phoneNumber;
  String avatarPath;
  String avatarUrl;
  String avatarData;
  DateTime? dateOfBirth;
  String emergencyContact;
  String role;
  DateTime createdAt;
  DateTime updatedAt;

  UserModel({
    this.email = '',
    this.fullName = '',
    this.gender = '',
    this.phoneNumber = '',
    this.avatarPath = '',
    this.avatarUrl = '',
    this.avatarData = '',
    this.dateOfBirth,
    this.emergencyContact = '',
    this.role = 'user',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert Firestore document to UserModel
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      gender: data['gender'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      avatarPath: data['avatarPath'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      avatarData: data['avatarData'] ?? '',
      dateOfBirth: (data['dateOfBirth'] as Timestamp?)?.toDate(),
      emergencyContact: data['emergencyContact'] ?? '',
      role: data['role'] ?? 'user',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert UserModel to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'fullName': fullName,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'avatarPath': avatarPath,
      'avatarUrl': avatarUrl,
      'avatarData': avatarData,
      'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'emergencyContact': emergencyContact,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
