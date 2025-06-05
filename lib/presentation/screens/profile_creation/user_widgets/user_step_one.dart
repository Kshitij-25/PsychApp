import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/user_profile_data/user_profile_model.dart';
import '../../../notifiers/profile_creation_notifier.dart';

class UserStepOne extends StatelessWidget {
  const UserStepOne({
    super.key,
    required this.dobCont,
    required this.userEmail,
    required this.formState,
    required this.profileForm,
    required this.fullNameCont,
    required this.uploadImageTap,
    required this.profileFormKey,
    required this.contactNumberCont,
    required this.addressController,
  });

  final String? userEmail;
  final void Function()? uploadImageTap;
  final ValueNotifier<GlobalKey<FormState>> profileFormKey;
  final UserProfileFormNotifier profileForm;
  final UserProfileModel formState;
  final TextEditingController fullNameCont;
  final TextEditingController dobCont;
  final TextEditingController contactNumberCont;
  final TextEditingController addressController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: profileFormKey.value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(context, 'Personal Information'),
          const SizedBox(height: 20),

          Center(
            child: GestureDetector(
              onTap: uploadImageTap,
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage: formState.profilePicUrl?.startsWith('http') ?? false
                    ? CachedNetworkImageProvider(formState.profilePicUrl!) // ✅ Use NetworkImage for S3 URLs
                    : formState.profilePicUrl?.isNotEmpty ?? false
                        ? FileImage(File(formState.profilePicUrl!)) as ImageProvider // ✅ Use FileImage for local files
                        : null,
                child: (formState.profilePicUrl?.isEmpty ?? true)
                    ? const Icon(
                        CupertinoIcons.camera_fill,
                        size: 30,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: userEmail,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: fullNameCont,
            decoration: const InputDecoration(
              labelText: 'Full Name*',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            onChanged: (value) => profileForm.updateField(formState.copyWith(fullName: value)),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: dobCont,
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            textInputAction: TextInputAction.next,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your date of birth';
              }
              return null;
            },
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              dobCont.text = DateFormat('dd-MM-yyyy').format(date!);
              profileForm.updateField(formState.copyWith(dateOfBirth: date));
            },
          ),
          const SizedBox(height: 10),
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
            onChanged: (value) => profileForm.updateField(formState.copyWith(genderIdentity: value)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your gender';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
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
            onChanged: (value) {
              profileForm.updateField(formState.copyWith(preferredPronouns: value));
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your preferred pronouns';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: contactNumberCont,
            decoration: const InputDecoration(
              labelText: 'Contact Number*',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
            onChanged: (value) => profileForm.updateField(formState.copyWith(phoneNumber: value)),
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
            onChanged: (value) => profileForm.updateField(formState.copyWith(location: value)),
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
