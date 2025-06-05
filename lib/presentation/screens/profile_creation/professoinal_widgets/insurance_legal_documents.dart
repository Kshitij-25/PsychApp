import 'package:flutter/material.dart';

class InsuranceLegalDocuments extends StatelessWidget {
  const InsuranceLegalDocuments({
    super.key,
    required this.acceptInsurance,
    required this.backgroundCheck,
    required this.certificationController,
    required this.disciplinaryAction,
    required this.identityController,
    required this.malpracticeController,
    required this.misconduct,
    required this.privacyPolicy,
    required this.resumeController,
  });

  final ValueNotifier<bool> acceptInsurance;
  final ValueNotifier<bool> disciplinaryAction;
  final ValueNotifier<bool> misconduct;
  final ValueNotifier<bool> backgroundCheck;
  final ValueNotifier<bool> privacyPolicy;
  final TextEditingController certificationController;
  final TextEditingController identityController;
  final TextEditingController malpracticeController;
  final TextEditingController resumeController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(context, 'Insurance & Payment Information'),
        CheckboxListTile.adaptive(
          dense: true,
          value: acceptInsurance.value,
          checkboxScaleFactor: 1.5,
          onChanged: (value) {
            acceptInsurance.value = value!;
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: Text('Do you accept insurance?'),
        ),
        SizedBox(height: 10),
        _buildSectionHeader(context, 'Legal & Ethical Disclosures'),
        CheckboxListTile.adaptive(
          dense: true,
          value: disciplinaryAction.value,
          checkboxScaleFactor: 1.5,
          onChanged: (value) {
            disciplinaryAction.value = value!;
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: Text('Have you ever faced disciplinary action related to your professional conduct?'),
        ),
        SizedBox(height: 10),
        CheckboxListTile.adaptive(
          dense: true,
          value: misconduct.value,
          checkboxScaleFactor: 1.5,
          onChanged: (value) {
            misconduct.value = value!;
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: Text('Are you currently under investigation for any professional misconduct?'),
        ),
        SizedBox(height: 10),
        CheckboxListTile.adaptive(
          dense: true,
          value: backgroundCheck.value,
          checkboxScaleFactor: 1.5,
          onChanged: (value) {
            backgroundCheck.value = value!;
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: Text('Consent to Background Check?'),
        ),
        SizedBox(height: 10),
        CheckboxListTile.adaptive(
          dense: true,
          value: privacyPolicy.value,
          checkboxScaleFactor: 1.5,
          onChanged: (value) {
            privacyPolicy.value = value!;
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: Text('Agree to Terms of Service & Privacy Policy'),
        ),
        SizedBox(height: 10),
        _buildSectionHeader(context, 'Document Uploads (If Applicable)'),
        SizedBox(height: 20),
        TextFormField(
          controller: certificationController,
          decoration: const InputDecoration(
            labelText: 'Professional License/Certification',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: identityController,
          decoration: const InputDecoration(
            labelText: 'Proof of Identity (e.g., Passport, Driver’s License)',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: malpracticeController,
          decoration: const InputDecoration(
            labelText: 'Malpractice Insurance (if required)',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: resumeController,
          decoration: const InputDecoration(
            labelText: 'Curriculum Vitae (CV) or Resume',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
        ),
        SizedBox(height: 10),
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
