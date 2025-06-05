import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/professional_profile_data/professional_profile_model.dart';
import '../../../notifiers/psychologist_profile_creation_notifier.dart';

class ProfileInfo extends StatelessWidget {
  ProfileInfo({
    super.key,
    required this.formKey,
    required this.userEmail,
    required this.addressController,
    required this.contactNumberController,
    required this.dobController,
    required this.fullNameController,
    required this.professionalProfileProvider,
    required this.professionalformState,
  });

  final ValueNotifier<GlobalKey<FormState>> formKey;
  final String? userEmail;

  final PsychologistProfileCreationNotifier professionalProfileProvider;
  final ProfessionalProfileModel professionalformState;
  final TextEditingController fullNameController;
  final TextEditingController dobController;
  final TextEditingController contactNumberController;
  final TextEditingController addressController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey.value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(context, 'Personal Information'),
          const SizedBox(height: 20),

          // ✅ Avatar Picker
          Center(
            child: GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  professionalProfileProvider.updateField(
                    professionalformState.copyWith(profileImageUrl: image.path),
                  );
                }
              },
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage: professionalformState.profileImageUrl?.isNotEmpty ?? false
                    ? FileImage(File(professionalformState.profileImageUrl!))
                    : professionalformState.profileImageUrl?.isNotEmpty ?? false
                        ? NetworkImage(professionalformState.profileImageUrl!) as ImageProvider
                        : null,
                child: (professionalformState.profileImageUrl?.isEmpty ?? true) && (professionalformState.profileImageUrl?.isEmpty ?? true)
                    ? const Icon(CupertinoIcons.camera_fill, size: 30)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ✅ Email (Read-only)
          TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            initialValue: userEmail,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Email*',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Full Name
          TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: fullNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name*',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
            onChanged: (value) => professionalProfileProvider.updateField(
              professionalformState.copyWith(fullName: value),
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Date of Birth
          TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: dobController,
            decoration: const InputDecoration(
              labelText: 'Date of Birth*',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your date of birth';
              }
              return null;
            },
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                dobController.text = DateFormat('dd-MM-yyyy').format(date);
                professionalProfileProvider.updateField(
                  professionalformState.copyWith(
                    dateOfBirth: DateFormat('dd-MM-yyyy').format(date),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 10),

          // ✅ Gender Dropdown
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Gender*',
              border: OutlineInputBorder(),
            ),
            items: ['Male', 'Female', 'Non-binary', 'Prefer not to say'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) => professionalProfileProvider.updateField(
              professionalformState.copyWith(genderIdentity: value),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your gender';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),

          // ✅ Preferred Pronouns Dropdown (Corrected Field Mapping)
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Preferred Pronouns*',
              border: OutlineInputBorder(),
            ),
            items: ['he/him/his', 'she/her/hers', 'they/them/theirs', 'Prefer not to specify'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) => professionalProfileProvider.updateField(
              professionalformState.copyWith(preferredPronouns: value),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your preferred pronouns';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),

          // ✅ Contact Number
          TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: contactNumberController,
            decoration: const InputDecoration(
              labelText: 'Contact Number*',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              } else if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) {
                return 'Enter a valid phone number';
              }
              return null;
            },
            onChanged: (value) => professionalProfileProvider.updateField(
              professionalformState.copyWith(contactNumber: value),
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Address Field (Corrected Validator)
          TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: addressController,
            decoration: const InputDecoration(
              labelText: 'Address (City, State, Country)*',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
            onChanged: (value) => professionalProfileProvider.updateField(
              professionalformState.copyWith(address: value),
            ),
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
