import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/journal_entry.dart';
import '../../shared/constants/firebase_helper.dart';

final journalProvider = StateNotifierProvider<JournalNotifier, List<JournalEntry>>((ref) {
  return JournalNotifier();
});

class JournalNotifier extends StateNotifier<List<JournalEntry>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid = FirebaseHelper.currentUserId!;

  JournalNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _firestore.collection('users').doc(uid).collection('journals').snapshots().listen((snapshot) {
      state = snapshot.docs.map((doc) => JournalEntry.fromJson({...doc.data(), 'id': doc.id})).toList();
    });
  }

  Future<void> addJournal(JournalEntry entry) async {
    try {
      // Remove the ID as Firestore will generate one
      final journalData = entry.toJson()..remove('id');

      await _firestore.collection('users').doc(uid).collection('journals').add(journalData);
    } catch (e) {
      print('Error adding journal: $e');
      rethrow;
    }
  }

  Future<void> updateJournal(String id, JournalEntry updatedEntry) async {
    try {
      // Remove the ID from the data as it's in the document path
      final journalData = updatedEntry.toJson()..remove('id');

      await _firestore.collection('users').doc(uid).collection('journals').doc(id).update(journalData);
    } catch (e) {
      print('Error updating journal: $e');
      rethrow;
    }
  }

  Future<void> deleteJournal(String id) async {
    try {
      await _firestore.collection('users').doc(uid).collection('journals').doc(id).delete();
    } catch (e) {
      print('Error deleting journal: $e');
      rethrow;
    }
  }
}
