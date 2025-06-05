// ========== State Management ==========
import 'package:flutter/material.dart';

@immutable
class AssessmentState {
  final List<int> phq9Answers;
  final List<int> gad7Answers;
  final Map<String, bool> riskAssessment;
  final int functionalImpact;
  final Set<String> therapyGoals;
  final String? openEndedResponse;
  final bool currentTreatment;
  final String? diagnosisHistory;
  final String? currentMedication;
  final String functionalImpactString;
  final bool isLoading;
  final String? error;

  const AssessmentState({
    this.phq9Answers = const [],
    this.gad7Answers = const [],
    this.riskAssessment = const {},
    this.functionalImpact = 0,
    this.therapyGoals = const {},
    this.openEndedResponse,
    this.currentTreatment = false,
    this.diagnosisHistory,
    this.currentMedication,
    this.functionalImpactString = 'NOT_AT_ALL',
    this.error,
    this.isLoading = false,
  });

  AssessmentState copyWith({
    List<int>? phq9Answers,
    List<int>? gad7Answers,
    Map<String, bool>? riskAssessment,
    int? functionalImpact,
    Set<String>? therapyGoals,
    String? openEndedResponse,
    bool? currentTreatment,
    String? diagnosisHistory,
    String? currentMedication,
    String? functionalImpactString,
    bool? isLoading,
    String? error,
  }) {
    return AssessmentState(
      phq9Answers: phq9Answers ?? this.phq9Answers,
      gad7Answers: gad7Answers ?? this.gad7Answers,
      riskAssessment: riskAssessment ?? this.riskAssessment,
      functionalImpact: functionalImpact ?? this.functionalImpact,
      therapyGoals: therapyGoals ?? this.therapyGoals,
      openEndedResponse: openEndedResponse ?? this.openEndedResponse,
      currentTreatment: currentTreatment ?? this.currentTreatment,
      diagnosisHistory: diagnosisHistory ?? this.diagnosisHistory,
      currentMedication: currentMedication ?? this.currentMedication,
      functionalImpactString: functionalImpactString ?? this.functionalImpactString,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
