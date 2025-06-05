import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/enums/assessment_state.dart';
import '../../data/repository/assessment_repository.dart';

class AssessmentNotifier extends StateNotifier<AssessmentState> {
  final AssessmentRepository _repository;

  AssessmentNotifier(this._repository) : super(AssessmentState());

  // ✅ Update PHQ-9 Answer
  void updatePhq9(int index, int value) {
    final newAnswers = List<int>.from(state.phq9Answers);
    while (newAnswers.length <= index) newAnswers.add(0);
    newAnswers[index] = value;
    state = state.copyWith(phq9Answers: newAnswers);
  }

  // ✅ Update GAD-7 Answer
  void updateGad7(int index, int value) {
    final newAnswers = List<int>.from(state.gad7Answers);
    while (newAnswers.length <= index) newAnswers.add(0);
    newAnswers[index] = value;
    state = state.copyWith(gad7Answers: newAnswers);
  }

  // ✅ Update Risk Assessment
  void updateRiskAssessment(String key, bool value) {
    final newRisk = Map<String, bool>.from(state.riskAssessment);
    newRisk[key] = value;
    state = state.copyWith(riskAssessment: newRisk);
  }

  // ✅ Update Functional Impact
  void updateFunctionalImpact(int value) {
    state = state.copyWith(functionalImpact: value);
  }

  // ✅ Toggle Therapy Goals
  void toggleTherapyGoal(String goal) {
    final newGoals = Set<String>.from(state.therapyGoals);
    newGoals.contains(goal) ? newGoals.remove(goal) : newGoals.add(goal);
    state = state.copyWith(therapyGoals: newGoals);
  }

  // ✅ Update Open-ended Response
  void updateOpenEnded(String value) {
    state = state.copyWith(openEndedResponse: value);
  }

  // ✅ Update Current Treatment
  void updateCurrentTreatment(bool value) {
    state = state.copyWith(currentTreatment: value);
  }

  // ✅ Update Diagnosis History
  void updateDiagnosisHistory(String value) {
    state = state.copyWith(diagnosisHistory: value);
  }

  // ✅ Update Current Medication
  void updateCurrentMedication(String value) {
    state = state.copyWith(currentMedication: value);
  }

  void validateBeforeSubmission() {
    if (state.phq9Answers.length != 9) {
      throw Exception('Complete all PHQ-9 questions');
    }
    if (state.gad7Answers.length != 7) {
      throw Exception('Complete all GAD-7 questions');
    }
    if (state.functionalImpactString.isEmpty) {
      throw Exception('Select functional impact level');
    }
  }

  // 🚀 **Save Assessment Method (API Call)**
  Future<bool> saveAssessment(String email) async {
    state = state.copyWith(isLoading: true);

    try {
      final assessmentState = state;
      final response = await _repository.saveAssessment(
        email: email,
        phq9Answers: assessmentState.phq9Answers,
        gad7Answers: assessmentState.gad7Answers,
        selfHarmThoughts: assessmentState.riskAssessment['selfHarmThoughts'] ?? false,
        selfHarmPlan: assessmentState.riskAssessment['selfHarmPlan'] ?? false,
        suicideHistory: assessmentState.riskAssessment['suicideHistory'] ?? false,
        unsafeEnvironment: assessmentState.riskAssessment['unsafeEnvironment'] ?? false,
        functionalImpact: assessmentState.functionalImpact,
        therapyGoals: assessmentState.therapyGoals,
        openEndedResponse: assessmentState.openEndedResponse,
        currentTreatment: assessmentState.currentTreatment,
        diagnosisHistory: assessmentState.diagnosisHistory?.isNotEmpty == true ? assessmentState.diagnosisHistory : null,
        currentMedication: assessmentState.currentMedication?.isNotEmpty == true ? assessmentState.currentMedication : null,
        functionalImpactString: assessmentState.functionalImpactString.toUpperCase() ?? 'NOT_AT_ALL',
      );

      if (response != null) {
        state = assessmentState;
        return true;
      } else {
        throw Exception('Failed to save assessment');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('Error saving assessment: $e');
      return false;
    }
  }
}
