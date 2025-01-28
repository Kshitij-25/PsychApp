import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'journal_entry.freezed.dart';
part 'journal_entry.g.dart';

@freezed
@HiveType(typeId: 0)
class JournalEntry with _$JournalEntry {
  factory JournalEntry({
    @HiveField(0) final String? id,
    @HiveField(1) final String? title,
    @HiveField(2) final DateTime? createdAt,
    @HiveField(3) final DateTime? updatedAt,
    @HiveField(4) final String? content,
    @HiveField(5) final bool? isPinned,
    @HiveField(6) final String? subTitle,
  }) = _JournalEntry;

  factory JournalEntry.fromJson(Map<String, dynamic> json) => _$JournalEntryFromJson(json);
}
