import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/enums/assessment_state.dart';
import '../../data/remote_data_source/assessment_remote_source.dart';
import '../../data/repository/assessment_repository.dart';
import '../notifiers/assessment_notifier.dart';

final assessmentProvider = StateNotifierProvider.autoDispose<AssessmentNotifier, AssessmentState>((ref) {
  final repository = ref.read(assessmentRepositoryProvider);
  return AssessmentNotifier(repository);
});

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  return AssessmentRepository(AssessmentRemoteSource());
});
