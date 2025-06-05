import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String userId;
  final String professionalId;
  final DateTime appointmentDateTime;
  final String status;
  final double consultationFee;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String specialization;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.professionalId,
    required this.appointmentDateTime,
    required this.status,
    required this.consultationFee,
    required this.createdAt,
    required this.updatedAt,
    required this.specialization,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => AppointmentModel(
        id: json['id'],
        userId: json['userId'],
        professionalId: json['professionalId'],
        appointmentDateTime: (json['appointmentDateTime'] as Timestamp).toDate(),
        status: json['status'],
        consultationFee: json['consultationFee'].toDouble(),
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        updatedAt: (json['updatedAt'] as Timestamp).toDate(),
        specialization: json['specialization'],
      );

  AppointmentModel copyWith({
    String? status,
    DateTime? updatedAt,
  }) =>
      AppointmentModel(
        id: id,
        userId: userId,
        professionalId: professionalId,
        appointmentDateTime: appointmentDateTime,
        status: status ?? this.status,
        consultationFee: consultationFee,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        specialization: specialization,
      );
}
