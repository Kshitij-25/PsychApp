import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:psych_app/data/models/psychologist_model.dart';

import '../../../data/local_data_source/expertise_data.dart' as initialQuestions;
import '../../../shared/constants/firebase_helper.dart';
import '../../notifiers/psychologist_profile_creation_notifier.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/multi_select_widget.dart';
import '../home/psychologist_home_nav.dart';

class PsychologistProfileCreation extends HookConsumerWidget {
  static const routeName = '/psychologistProfileCreation';
  const PsychologistProfileCreation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(psychologistProfileFormProvider);
    final therapistProfileProvider = ref.read(psychologistProfileFormProvider.notifier);
    final _formKey = useState(GlobalKey<FormState>());
    final _scrollController = useScrollController();
    final _isLoading = useState(false);
    final fullNameCont = useTextEditingController();
    final phoneNumberCont = useTextEditingController();
    final dobCont = useTextEditingController();
    final specializationController = useTextEditingController();
    final qualificationController = useTextEditingController();
    final aboutController = useTextEditingController();

    // Set initial email
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        therapistProfileProvider.updateField(formState.copyWith(email: FirebaseHelper.currentUser?.email));
      });
      return null;
    }, []);
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Form(
              key: _formKey.value,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery,
                            maxWidth: 2048,
                            maxHeight: 2048,
                            imageQuality: 90,
                          );
                          if (image != null) {
                            therapistProfileProvider.updateField(formState.copyWith(avatarPath: image.path));
                          }
                        },
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          backgroundImage: formState.avatarPath?.isNotEmpty ?? false
                              ? FileImage(File(formState.avatarPath!))
                              : formState.avatarUrl?.isNotEmpty ?? false
                                  ? NetworkImage(formState.avatarUrl!) as ImageProvider
                                  : null,
                          child: (formState.avatarPath?.isEmpty ?? true) && (formState.avatarUrl?.isEmpty ?? true)
                              ? const Icon(
                                  CupertinoIcons.camera_fill,
                                  size: 30,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, 'Basic Information'),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: FirebaseHelper.currentUser?.email,
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
                      onChanged: (value) => therapistProfileProvider.updateField(
                        formState.copyWith(fullName: value),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phoneNumberCont,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number*',
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
                      onChanged: (value) => therapistProfileProvider.updateField(formState.copyWith(phoneNumber: value)),
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
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        dobCont.text = DateFormat('dd-MM-yyyy').format(date!);
                        therapistProfileProvider.updateField(formState.copyWith(dateOfBirth: date));
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
                      onChanged: (value) => therapistProfileProvider.updateField(
                        formState.copyWith(therapistGender: value),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your gender';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSectionHeader(context, 'Professional Information'),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: specializationController,
                      decoration: const InputDecoration(
                        labelText: 'Specialization*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      onChanged: (value) => therapistProfileProvider.updateField(
                        formState.copyWith(specialization: value),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: qualificationController,
                      decoration: const InputDecoration(
                        labelText: 'Qualification*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      onChanged: (value) => therapistProfileProvider.updateField(
                        formState.copyWith(qualification: value),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: aboutController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'About*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      onChanged: (value) => therapistProfileProvider.updateField(
                        formState.copyWith(about: value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionHeader(context, 'Availability'),
                    const SizedBox(height: 10),
                    _buildAvailabilitySection(context, ref, formState),
                    // const SizedBox(height: 16),
                    // _buildSectionHeader(context, 'Publications'),
                    // const SizedBox(height: 10),
                    // _buildPublicationsList(context, ref, formState),
                    const SizedBox(height: 16),
                    _buildSectionHeader(context, 'Areas of Expertise'),
                    const SizedBox(height: 10),
                    MultiSelectChip(
                      title: 'Expertise',
                      options: initialQuestions.expertise,
                      selectedValues: formState.expertise ?? [],
                      onSelectionChanged: (selectedList) =>
                          ref.read(psychologistProfileFormProvider.notifier).updateField(formState.copyWith(expertise: selectedList)),
                    ),
                    const SizedBox(height: 10),
                    MultiSelectChip(
                      title: 'Relationships',
                      options: initialQuestions.relationships,
                      selectedValues: formState.relationships ?? [],
                      onSelectionChanged: (selectedList) =>
                          ref.read(psychologistProfileFormProvider.notifier).updateField(formState.copyWith(relationships: selectedList)),
                    ),
                    const SizedBox(height: 10),
                    MultiSelectChip(
                      title: 'Work/Study',
                      options: initialQuestions.workAndStudy,
                      selectedValues: formState.workStudy ?? [],
                      onSelectionChanged: (selectedList) =>
                          ref.read(psychologistProfileFormProvider.notifier).updateField(formState.copyWith(workStudy: selectedList)),
                    ),
                    const SizedBox(height: 10),
                    MultiSelectChip(
                      title: 'Happenings in life',
                      options: initialQuestions.happeningsInLife,
                      selectedValues: formState.happeningsInLife ?? [],
                      onSelectionChanged: (selectedList) =>
                          ref.read(psychologistProfileFormProvider.notifier).updateField(formState.copyWith(happeningsInLife: selectedList)),
                    ),
                    const SizedBox(height: 16),
                    CustomElevatedButton(
                      buttonLabel: 'Next',
                      onPressed: _isLoading.value
                          ? null
                          : () async {
                              if (_formKey.value.currentState!.validate()) {
                                _isLoading.value = true;

                                final success = await therapistProfileProvider.submitProfile(FirebaseHelper.currentUserId!);

                                _isLoading.value = false;

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        'Profile created successfully',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Theme.of(context).colorScheme.onTertiaryContainer,
                                            ),
                                      ),
                                      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                                    ),
                                  );
                                  context.goNamed(PsychologistHomeNav.routeName);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        'Error creating profile. Please try again.',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Theme.of(context).colorScheme.onError,
                                            ),
                                      ),
                                      backgroundColor: Theme.of(context).colorScheme.error,
                                    ),
                                  );
                                }
                              }
                            },
                      buttonStyle: ElevatedButton.styleFrom(
                        enableFeedback: true,
                        backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading.value)
          Container(
            color: Colors.black87,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
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

  Widget _buildAvailabilitySection(BuildContext context, WidgetRef ref, PsychologistModel profile) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    final availabilityControllers = Map<String, Map<String, TextEditingController>>.fromEntries(
      days.map((day) {
        // Safely handle empty or invalid availability strings
        String fromTime = '';
        String toTime = '';

        final availabilityStr = profile.availability?[day.toLowerCase()];
        if (availabilityStr != null && availabilityStr != 'Unavailable') {
          final times = availabilityStr.split(' - ');
          if (times.length == 2) {
            fromTime = times[0];
            toTime = times[1];
          }
        }

        return MapEntry(
          day,
          {
            'from': TextEditingController(text: fromTime),
            'to': TextEditingController(text: toTime),
          },
        );
      }),
    );

    Future<TimeOfDay?> _showTimePicker() async {
      return showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      );
    }

    String _formatTime(TimeOfDay time) {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }

    void _updateAvailability(String day) {
      final fromTime = availabilityControllers[day]!['from']!.text.trim();
      final toTime = availabilityControllers[day]!['to']!.text.trim();

      final newAvailability = Map<String, String>.from(profile.availability ?? {});

      if (fromTime.isEmpty && toTime.isEmpty) {
        // Mark as unavailable if no time is selected
        newAvailability[day.toLowerCase()] = 'Unavailable';
      } else {
        // Update with selected time range
        newAvailability[day.toLowerCase()] = '$fromTime - $toTime';
      }

      ref.read(psychologistProfileFormProvider.notifier).updateField(
            profile.copyWith(availability: newAvailability),
          );
    }

    return Column(
      children: days.map((day) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(day, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      readOnly: true,
                      controller: availabilityControllers[day]!['from'],
                      decoration: const InputDecoration(
                        labelText: 'From',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () async {
                        final time = await _showTimePicker();
                        if (time != null) {
                          availabilityControllers[day]!['from']!.text = _formatTime(time);
                          _updateAvailability(day);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      readOnly: true,
                      controller: availabilityControllers[day]!['to'],
                      decoration: const InputDecoration(
                        labelText: 'To',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () async {
                        final time = await _showTimePicker();
                        if (time != null) {
                          availabilityControllers[day]!['to']!.text = _formatTime(time);
                          _updateAvailability(day);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPublicationsList(BuildContext context, WidgetRef ref, PsychologistModel profile) {
    // Ensure publications and publicationsLinks are initialized
    final publications = profile.publications ?? [];
    final publicationsLinks = profile.publicationsLinks ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Generate a list of text fields for publications
        ...List.generate(
          publications.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    initialValue: publications[index],
                    decoration: InputDecoration(
                      labelText: 'Publication ${index + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // Update the specific publication
                      final newPublications = List<String>.from(publications);
                      newPublications[index] = value;
                      ref.read(psychologistProfileFormProvider.notifier).updateField(
                            profile.copyWith(publications: newPublications),
                          );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    initialValue: publicationsLinks.isNotEmpty ? publicationsLinks[index] : '',
                    decoration: InputDecoration(
                      labelText: 'Link ${index + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // Update the specific publication link
                      final newLinks = List<String>.from(publicationsLinks);
                      newLinks[index] = value;
                      ref.read(psychologistProfileFormProvider.notifier).updateField(
                            profile.copyWith(publicationsLinks: newLinks),
                          );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Remove the publication and corresponding link
                    final newPublications = List<String>.from(publications)..removeAt(index);
                    final newLinks = List<String>.from(publicationsLinks)..removeAt(index);
                    ref.read(psychologistProfileFormProvider.notifier).updateField(
                          profile.copyWith(
                            publications: newPublications,
                            publicationsLinks: newLinks,
                          ),
                        );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // Add a new publication and corresponding link
            final newPublications = List<String>.from(publications)..add('');
            final newLinks = List<String>.from(publicationsLinks)..add('');
            ref.read(psychologistProfileFormProvider.notifier).updateField(
                  profile.copyWith(
                    publications: newPublications,
                    publicationsLinks: newLinks,
                  ),
                );
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Publication'),
        ),
      ],
    );
  }
}
