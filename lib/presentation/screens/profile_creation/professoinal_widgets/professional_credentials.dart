import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psych_app/data/models/professional_profile_data/credentials_model.dart';

import '../../../../data/models/professional_profile_data/professional_profile_model.dart';
import '../../../notifiers/psychologist_profile_creation_notifier.dart';

class ProfessionalCredentials extends StatelessWidget {
  const ProfessionalCredentials({
    super.key,
    required this.formKey,
    required this.boardCertified,
    required this.issuingAuthorityController,
    required this.licenseExpireController,
    required this.licenseNumberController,
    required this.multipleStatePractice,
    required this.professionalProfileProvider,
    required this.professionalTitleController,
    required this.professionalformState,
  });

  final ValueNotifier<GlobalKey<FormState>> formKey;
  final TextEditingController professionalTitleController;
  final TextEditingController licenseNumberController;
  final TextEditingController issuingAuthorityController;
  final TextEditingController licenseExpireController;
  final PsychologistProfileCreationNotifier professionalProfileProvider;
  final ProfessionalProfileModel professionalformState;
  final ValueNotifier<bool> multipleStatePractice;
  final ValueNotifier<bool> boardCertified;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey.value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(context, 'Professional Credentials'),
          SizedBox(height: 20),
          TextFormField(
            controller: professionalTitleController,
            decoration: const InputDecoration(
              labelText: 'Professional Title*',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            validator: (value) {
              if (professionalTitleController.text.isEmpty) {
                return 'Please enter your professional title';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: licenseNumberController,
            decoration: const InputDecoration(
              labelText: 'License Number*',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            validator: (value) {
              if (licenseNumberController.text.isEmpty) {
                return 'Please enter your license number';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: issuingAuthorityController,
            decoration: const InputDecoration(
              labelText: 'Issuing Authority/State*',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            validator: (value) {
              if (issuingAuthorityController.text.isEmpty) {
                return 'Please enter the issuing authority or state';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: licenseExpireController,
            decoration: const InputDecoration(
              labelText: 'License Expiry Date*',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            textInputAction: TextInputAction.next,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            readOnly: true,
            validator: (value) {
              if (licenseExpireController.text.isEmpty) {
                return 'Please select the license expiry date';
              }
              return null;
            },
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                licenseExpireController.text = DateFormat('dd-MM-yyyy').format(date);
                professionalProfileProvider.updateField(
                  professionalformState.copyWith(
                    credentials: CredentialsModel(
                      licenseExpiry: DateFormat('dd-MM-yyyy').format(date),
                    ),
                  ),
                );
              }
            },
          ),
          SizedBox(height: 10),
          CheckboxListTile.adaptive(
            dense: true,
            value: multipleStatePractice.value,
            checkboxScaleFactor: 1.5,
            onChanged: (value) {
              multipleStatePractice.value = value!;
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: Text('Are you licensed to practice in multiple states or countries?'),
          ),
          SizedBox(height: 10),
          CheckboxListTile.adaptive(
            dense: true,
            value: boardCertified.value,
            checkboxScaleFactor: 1.5,
            onChanged: (value) {
              boardCertified.value = value!;
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: Text('Are you board-certified?'),
          ),
        ],
      ),
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
