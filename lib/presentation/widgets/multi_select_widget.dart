import 'package:flutter/material.dart';

class MultiSelectChip extends StatelessWidget {
  final String title;
  final List<String> options;
  final List<String> selectedValues;
  final Function(List<String>) onSelectionChanged;

  const MultiSelectChip({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValues,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options.map((item) {
            final isSelected = selectedValues.contains(item);
            return FilterChip(
              label: Text(item.replaceAll('_', ' ').split(' ').map((word) {
                return word[0].toUpperCase() + word.substring(1).toLowerCase();
              }).join(' ')),
              selected: isSelected,
              showCheckmark: false,
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              visualDensity: VisualDensity.compact,
              onSelected: (selected) {
                final updatedList = List<String>.from(selectedValues);
                if (selected) {
                  updatedList.add(item);
                } else {
                  updatedList.remove(item);
                }
                onSelectionChanged(updatedList);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
