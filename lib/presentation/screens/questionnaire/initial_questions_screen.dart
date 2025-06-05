import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:psych_app/presentation/widgets/custom_elevated_button.dart';

import '../../../data/enums/assessment_state.dart';
import '../../notifiers/assessment_notifier.dart';
import '../../providers/assessment_provider.dart';
import '../welcome/landing_screen.dart';

class FunctionalImpact {
  static const values = ['NOT_AT_ALL', 'LITTLE', 'MODERATE', 'SEVERE'];

  static String get defaultImpact => 'NOT_AT_ALL';

  static bool isValid(String value) => values.contains(value.toUpperCase());
}

class InitialQuestionsScreen extends HookConsumerWidget {
  static const routeName = '/initialQuestionsScreen';
  const InitialQuestionsScreen({
    super.key,
    this.userEmail,
  });

  final String? userEmail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assessmentProvider);
    final notifier = ref.read(assessmentProvider.notifier);
    final pageController = usePageController();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Initial Health Assessment'),
      // ),
      body: SafeArea(
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildAssessmentPage(
              context: context,
              children: [
                _buildPhq9Section(context, state, notifier),
                _buildGad7Section(context, state, notifier),
                _buildRiskAssessmentSection(context, state, notifier),
              ],
              onNext: () => pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
            ),
            _buildAssessmentPage(
              context: context,
              children: [
                _buildFunctionalImpact(context, state, notifier),
                _buildTreatmentHistorySection(context, state, notifier),
                _buildTherapyGoals(context, state, notifier),
                _buildOpenEndedQuestion(context, notifier),
                _buildEmergencySection(context, state),
                const SizedBox(height: 20),
                _buildSubmitButton(
                  context,
                  ref,
                  onBack: () => pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentPage({
    required BuildContext context,
    required List<Widget> children,
    VoidCallback? onNext,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(children: children),
          ),
        ),
        if (onNext != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomElevatedButton(
              onPressed: onNext,
              buttonLabel: 'Next',
              buttonStyle: ElevatedButton.styleFrom(
                enableFeedback: true,
                backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          )
      ],
    );
  }

  // ========== PHQ-9 Section ==========
  Widget _buildPhq9Section(BuildContext context, AssessmentState state, AssessmentNotifier notifier) {
    const questions = [
      "Little interest or pleasure in doing things?",
      "Feeling down, depressed, or hopeless?",
      "Trouble falling/staying asleep, or sleeping too much?",
      "Feeling tired or having little energy?",
      "Poor appetite or overeating?",
      "Feeling bad about yourself - or that you're a failure?",
      "Trouble concentrating on things?",
      "Moving/speaking slowly or being fidgety/restless?",
      "Thoughts of self-harm or suicide?",
    ];

    return _buildAssessmentSection(
      context: context,
      title: 'PHQ-9 Depression Assessment',
      questions: questions,
      answers: state.phq9Answers,
      onChanged: notifier.updatePhq9,
    );
  }

  // ========== GAD-7 Section ==========
  Widget _buildGad7Section(BuildContext context, AssessmentState state, AssessmentNotifier notifier) {
    const questions = [
      "Feeling nervous, anxious, or on edge?",
      "Not being able to stop or control worrying?",
      "Worrying too much about different things?",
      "Trouble relaxing?",
      "Being so restless it's hard to sit still?",
      "Becoming easily annoyed or irritable?",
      "Feeling afraid as if something awful might happen?",
    ];

    return _buildAssessmentSection(
      context: context,
      title: 'GAD-7 Anxiety Assessment',
      questions: questions,
      answers: state.gad7Answers,
      onChanged: notifier.updateGad7,
    );
  }

  Widget _buildAssessmentSection({
    required BuildContext context,
    required String title,
    required List<String> questions,
    required List<int> answers,
    required Function(int, int) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ...List.generate(
            questions.length,
            (index) => _buildLikertQuestion(
                  context: context,
                  question: questions[index],
                  value: answers.length > index ? answers[index] : 0,
                  onChanged: (value) => onChanged(index, value),
                )),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLikertQuestion({
    required BuildContext context,
    required String question,
    required int value,
    required Function(int) onChanged,
  }) {
    const labels = ['Not at all', 'Several days', 'More than half', 'Nearly every day'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: List.generate(
            labels.length,
            (index) => ChoiceChip(
              visualDensity: VisualDensity.compact,
              showCheckmark: false,
              label: Text(
                labels[index],
                textAlign: TextAlign.center,
              ),
              selected: value == index,
              onSelected: (selected) => onChanged(selected ? index : 0),
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              labelStyle: TextStyle(
                color: value == index ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // ========== Risk Assessment ==========
  Widget _buildRiskAssessmentSection(BuildContext context, AssessmentState state, AssessmentNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Risk Assessment', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _buildYesNoQuestion(
            question: "Had thoughts of hurting yourself or others?",
            value: state.riskAssessment['selfHarmThoughts'],
            onChanged: (v) => notifier.updateRiskAssessment('selfHarmThoughts', v),
          ),
          if (state.riskAssessment['selfHarmThoughts'] == true) ...[
            _buildYesNoQuestion(
              question: "Do you have a specific plan?",
              value: state.riskAssessment['selfHarmPlan'],
              onChanged: (v) => notifier.updateRiskAssessment('selfHarmPlan', v),
            ),
          ],
          _buildYesNoQuestion(
            question: "Past suicide attempts?",
            value: state.riskAssessment['suicideHistory'],
            onChanged: (v) => notifier.updateRiskAssessment('suicideHistory', v),
          ),
          _buildYesNoQuestion(
            question: "Unsafe environment?",
            value: state.riskAssessment['unsafeEnvironment'],
            onChanged: (v) => notifier.updateRiskAssessment('unsafeEnvironment', v),
          ),
        ],
      ),
    );
  }

  Widget _buildYesNoQuestion({
    required String question,
    required bool? value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Expanded(child: Text(question)),
          ToggleButtons(
            isSelected: [value == true, value == false],
            onPressed: (index) => onChanged(index == 0),
            constraints: const BoxConstraints(minHeight: 40, minWidth: 80),
            children: const [Text('Yes'), Text('No')],
          ),
        ],
      ),
    );
  }

  // ========== Functional Impact ==========
  Widget _buildFunctionalImpact(BuildContext context, AssessmentState state, AssessmentNotifier notifier) {
    const options = ['NOT_AT_ALL', 'LITTLE', 'MODERATE', 'SEVERE'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daily Life Impact', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("How much are your current feelings affecting your daily life?"),
                DropdownButtonFormField<String>(
                  value: state.functionalImpactString,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: options.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.replaceAll('_', ' ')),
                    );
                  }).toList(),
                  onChanged: (value) => notifier.updateFunctionalImpact(options.indexOf(value!)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ========== New Treatment History Section ==========
  Widget _buildTreatmentHistorySection(
    BuildContext context,
    AssessmentState state,
    AssessmentNotifier notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Treatment History', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _buildYesNoQuestion(
            question: "Are you currently receiving mental health treatment?",
            value: state.currentTreatment,
            onChanged: notifier.updateCurrentTreatment,
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: notifier.updateDiagnosisHistory,
            decoration: const InputDecoration(
              labelText: "Previous diagnoses (optional)",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.medical_services),
            ),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: notifier.updateCurrentMedication,
            decoration: const InputDecoration(
              labelText: "Current medications (optional)",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.medication),
            ),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ========== Therapy Goals ==========
  Widget _buildTherapyGoals(BuildContext context, AssessmentState state, AssessmentNotifier notifier) {
    const goals = [
      'Coping with stress/anxiety',
      'Managing depression',
      'Relationship issues',
      'Trauma recovery',
      'Self-esteem growth',
      'Substance use',
      'Other',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Therapy Goals', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: goals
                .map((goal) => FilterChip(
                      visualDensity: VisualDensity.compact,
                      showCheckmark: false,
                      label: Text(goal),
                      selected: state.therapyGoals.contains(goal),
                      onSelected: (selected) => notifier.toggleTherapyGoal(goal),
                      selectedColor: Theme.of(context).colorScheme.primaryContainer,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      labelStyle: TextStyle(
                        color: state.therapyGoals.contains(goal)
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ========== Open-Ended Question ==========
  Widget _buildOpenEndedQuestion(BuildContext context, AssessmentNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Additional Information', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            onChanged: notifier.updateOpenEnded,
            decoration: const InputDecoration(
              hintText: 'What brings you to seek support today?',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ========== Emergency Section ==========
  Widget _buildEmergencySection(BuildContext context, AssessmentState state) {
    // Get scores from state
    final phq9Score = state.phq9Answers.isNotEmpty ? state.phq9Answers.reduce((a, b) => a + b) : 0;
    final gad7Score = state.gad7Answers.isNotEmpty ? state.gad7Answers.reduce((a, b) => a + b) : 0;

    // Enhanced risk detection logic matching backend
    final isCrisis = state.riskAssessment['selfHarmPlan'] == true;
    final isHighRisk =
        state.riskAssessment['selfHarmThoughts'] == true || state.riskAssessment['unsafeEnvironment'] == true || phq9Score >= 20 || gad7Score >= 15;

    if (!isCrisis && !isHighRisk) return const SizedBox.shrink();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isCrisis)
            _buildEmergencyMessage(
              "Immediate Crisis Detected",
              Colors.red,
              Icons.error_outline,
            ),
          if (!isCrisis && isHighRisk)
            _buildEmergencyMessage(
              "High Risk Level Detected",
              Colors.orange,
              Icons.warning_amber,
            ),
          // ... rest of your existing content
          _buildHotlineRow(
            icon: Icons.phone,
            color: Colors.green,
            number: '1800-599-0019',
            name: 'KIRAN Helpline',
            description: '24/7 mental health support',
          ),
          _buildHotlineRow(
            icon: Icons.phone_in_talk,
            color: Colors.blue,
            number: '14416',
            name: 'Tele MANAS',
            description: 'Nationwide mental health services',
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyMessage(String text, Color color, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(icon, color: color, size: 40),
        const SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHotlineRow({required IconData icon, required Color color, required String number, required String name, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  number,
                  style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.w600),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== Submission ==========
  Widget _buildSubmitButton(
    BuildContext context,
    WidgetRef ref, {
    VoidCallback? onBack,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: CustomElevatedButton(
              onPressed: onBack,
              buttonLabel: 'Back',
              buttonStyle: ElevatedButton.styleFrom(
                enableFeedback: true,
                minimumSize: const Size(double.infinity, 50),
                elevation: 0,
                backgroundColor: Theme.of(context).buttonTheme.colorScheme?.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12), // Add spacing between buttons
          Expanded(
            child: CustomElevatedButton(
              onPressed: () => _handleSubmission(context, ref),
              buttonLabel: 'Submit Assessment',
              buttonStyle: ElevatedButton.styleFrom(
                enableFeedback: true,
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmission(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(assessmentProvider.notifier);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      notifier.validateBeforeSubmission();
      // Show loading indicator
      scaffoldMessenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(
                'Submitting assessment...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );

      // Call the API to save assessment
      final response = await notifier.saveAssessment(userEmail ?? '');
      scaffoldMessenger.hideCurrentSnackBar();
      if (response == true) {
        context.goNamed(LandingScreen.routeName);
      }
    } catch (e) {
      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Failed to submit assessment: ${e.toString()}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    }
    // final state = ref.read(assessmentProvider);

    // final phq9Score = state.phq9Answers.isNotEmpty ? state.phq9Answers.reduce((a, b) => a + b) : 0;

    // final gad7Score = state.gad7Answers.isNotEmpty ? state.gad7Answers.reduce((a, b) => a + b) : 0;

    // // Show results dialog
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text('Assessment Results'),
    //     content: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text('PHQ-9 Score: $phq9Score'),
    //         Text('GAD-7 Score: $gad7Score'),
    //         const SizedBox(height: 16),
    //         Text(_interpretScores(phq9Score, gad7Score)),
    //       ],
    //     ),
    //     actions: [
    //       TextButton(
    //         child: const Text('Close'),
    //         onPressed: () => Navigator.of(context).pop(),
    //       ),
    //     ],
    //   ),
    // );
  }

  String _interpretScores(int phq9, int gad7) {
    String phqInterpretation = '';
    if (phq9 >= 20)
      phqInterpretation = 'Severe depression';
    else if (phq9 >= 15)
      phqInterpretation = 'Moderately severe depression';
    else if (phq9 >= 10)
      phqInterpretation = 'Moderate depression';
    else if (phq9 >= 5)
      phqInterpretation = 'Mild depression';
    else
      phqInterpretation = 'Minimal depression';

    String gadInterpretation = '';
    if (gad7 >= 15)
      gadInterpretation = 'Severe anxiety';
    else if (gad7 >= 10)
      gadInterpretation = 'Moderate anxiety';
    else if (gad7 >= 5)
      gadInterpretation = 'Mild anxiety';
    else
      gadInterpretation = 'Minimal anxiety';

    return 'Interpretation:\n$phqInterpretation\n$gadInterpretation';
  }
}
