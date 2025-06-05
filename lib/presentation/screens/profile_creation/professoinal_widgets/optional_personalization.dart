import 'package:flutter/material.dart';

class OptionalPersonalization extends StatelessWidget {
  const OptionalPersonalization({
    super.key,
    required this.healProfessionalController,
    required this.healthJourneyController,
    required this.passionateController,
  });

  final TextEditingController healProfessionalController;
  final TextEditingController healthJourneyController;
  final TextEditingController passionateController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(context, 'Optional Questions for Personalization'),
        SizedBox(height: 20),
        TextFormField(
          controller: healProfessionalController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Why did you choose to become a mental health professional?',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: healthJourneyController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'What motivates you to support clients in their mental health journey?',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: passionateController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Are there any specific populations you feel passionate about working with?',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
