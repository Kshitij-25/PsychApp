// Appointment Providers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/appointment_model.dart';

final appointmentProvider = StateNotifierProvider<AppointmentNotifier, AsyncValue<List<AppointmentModel>>>((ref) {
  return AppointmentNotifier();
});

final userAppointmentsStreamProvider = StreamProvider.family<List<AppointmentModel>, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection('appointments')
      .where('userId', isEqualTo: userId)
      .orderBy('appointmentDateTime', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => AppointmentModel.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList());
});

final professionalAppointmentsStreamProvider = StreamProvider.family<List<AppointmentModel>, String>((ref, professionalId) {
  return FirebaseFirestore.instance
      .collection('appointments')
      .where('professionalId', isEqualTo: professionalId)
      .orderBy('appointmentDateTime', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => AppointmentModel.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList());
});

// Appointment Notifier
class AppointmentNotifier extends StateNotifier<AsyncValue<List<AppointmentModel>>> {
  AppointmentNotifier() : super(const AsyncValue.loading());
  final _firestore = FirebaseFirestore.instance;

  Future<void> bookAppointment({
    required String userId,
    required String professionalId,
    required String specialization,
    required DateTime appointmentDateTime,
    required double consultationFee,
  }) async {
    try {
      state = const AsyncValue.loading();

      final appointmentRef = _firestore.collection('appointments').doc();

      await appointmentRef.set({
        'id': appointmentRef.id,
        'userId': userId,
        'professionalId': professionalId,
        'specialization': specialization,
        'appointmentDateTime': Timestamp.fromDate(appointmentDateTime),
        'status': 'pending',
        'consultationFee': consultationFee,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      state = AsyncValue.data([
        ...?state.value,
        AppointmentModel(
          id: appointmentRef.id,
          userId: userId,
          professionalId: professionalId,
          appointmentDateTime: appointmentDateTime,
          status: 'pending',
          consultationFee: consultationFee,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          specialization: specialization,
        )
      ]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    try {
      state = const AsyncValue.loading();

      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': status,
        'updatedAt': Timestamp.now(),
      });

      state = AsyncValue.data([
        for (final appointment in state.value ?? [])
          if (appointment.id == appointmentId) appointment.copyWith(status: status, updatedAt: DateTime.now()) else appointment
      ]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> fetchAppointments(String userId, {bool isProfessional = false}) async {
    try {
      state = const AsyncValue.loading();

      final querySnapshot = await _firestore
          .collection('appointments')
          .where(isProfessional ? 'professionalId' : 'userId', isEqualTo: userId)
          .orderBy('appointmentDateTime', descending: true)
          .get();

      final appointments = querySnapshot.docs
          .map((doc) => AppointmentModel.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList();

      state = AsyncValue.data(appointments);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}
