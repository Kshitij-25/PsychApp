import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_entry.freezed.dart';
part 'journal_entry.g.dart';

@freezed
class JournalEntry with _$JournalEntry {
  factory JournalEntry({
    final String? id,
    final String? title,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String? content,
    final bool? isPinned,
    final String? subTitle,
  }) = _JournalEntry;

  factory JournalEntry.fromJson(Map<String, dynamic> json) => _$JournalEntryFromJson(json);
}
