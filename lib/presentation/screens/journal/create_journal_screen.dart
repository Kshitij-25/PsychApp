import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/firebase_models/journal_entry.dart';
import '../../notifiers/journal_notifier.dart';

class CreateJournalScreen extends StatefulHookConsumerWidget {
  static const routeName = '/createJournalScreen';
  const CreateJournalScreen({
    super.key,
    this.existingNote,
  });

  final JournalEntry? existingNote;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateJournalScreenState();
}

class _CreateJournalScreenState extends ConsumerState<CreateJournalScreen> {
  late QuillController quillController;

  @override
  void initState() {
    super.initState();

    // Initialize the QuillController with existing note content or a blank document
    quillController = widget.existingNote != null
        ? QuillController(
            document: Document()..insert(0, widget.existingNote!.content ?? ''),
            selection: TextSelection.collapsed(offset: 0),
          )
        : QuillController.basic();
  }

  @override
  void dispose() {
    quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final titleController = useTextEditingController(text: widget.existingNote?.title ?? '');

    // final quillController = useMemoized(() => widget.existingNote != null
    //     ? QuillController(
    //         document: Document.fromJson(jsonDecode(widget.existingNote!.content!) as List<dynamic>), selection: TextSelection.collapsed(offset: 0))
    //     : QuillController.basic());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        actions: [
          TextButton(
            child: Text('Done'),
            style: TextButton.styleFrom(
              enableFeedback: true,
              splashFactory: NoSplash.splashFactory,
              overlayColor: Colors.transparent,
            ),
            onPressed: () async {
              final plainText = quillController.document.toPlainText().trim();
              final firstSentence = plainText.split('.').first.trim();
              final subtitle = plainText.split('.').length > 1 ? plainText.split('.').sublist(1).join('.').trim() : '';
              final now = DateTime.now();

              if (plainText.isEmpty) {
                context.pop();
                return;
              }

              try {
                final journal = widget.existingNote?.copyWith(
                      title: firstSentence,
                      subTitle: subtitle.isNotEmpty ? subtitle : null,
                      content: plainText,
                      updatedAt: now,
                    ) ??
                    JournalEntry(
                      title: firstSentence,
                      subTitle: subtitle.isNotEmpty ? subtitle : null,
                      content: plainText,
                      createdAt: now,
                      updatedAt: now,
                      isPinned: false,
                    );

                if (widget.existingNote == null) {
                  await ref.read(journalProvider.notifier).addJournal(journal);
                } else {
                  await ref.read(journalProvider.notifier).updateJournal(journal.id!, journal);
                }

                if (mounted) context.pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to save journal: ${e.toString()}')),
                );
              }
            },
          ),
        ],
        centerTitle: true,
        // title: // Quill Toolbar
        //     QuillToolbar.simple(
        //   controller: quillController,
        //   configurations: QuillSimpleToolbarConfigurations(
        //     showAlignmentButtons: false,
        //     showListBullets: false,
        //     showColorButton: false,
        //     showBackgroundColorButton: false,
        //     showBoldButton: false,
        //     showCenterAlignment: false,
        //     showClearFormat: false,
        //     showClipboardCopy: false,
        //     showClipboardCut: false,
        //     showClipboardPaste: false,
        //     showCodeBlock: false,
        //     showDirection: false,
        //     showDividers: false,
        //     showFontFamily: false,
        //     showFontSize: false,
        //     showHeaderStyle: false,
        //     showIndent: false,
        //     showInlineCode: false,
        //     showItalicButton: false,
        //     showJustifyAlignment: false,
        //     showLeftAlignment: false,
        //     showLineHeightButton: false,
        //     showLink: false,
        //     showListCheck: false,
        //     showListNumbers: false,
        //     showQuote: false,
        //     showRightAlignment: false,
        //     showSearchButton: false,
        //     showSmallButton: false,
        //     showStrikeThrough: false,
        //     showSubscript: false,
        //     showSuperscript: false,
        //     showUnderLineButton: false,
        //     multiRowsDisplay: false,
        //   ),
        // ),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
          //   child: TextField(
          //     controller: titleController,
          //     decoration: InputDecoration(
          //       hintText: 'Title',
          //       border: InputBorder.none,
          //     ),
          //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          //   ),
          // ),

          // // Quill Editor
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
          //     child: QuillEditor(
          //       controller: quillController,
          //       focusNode: FocusNode(),
          //       scrollController: ScrollController(),
          //       configurations: QuillEditorConfigurations(
          //         onTapOutside: (event, focusNode) {
          //           focusNode.unfocus();
          //         },
          //         scrollable: true,
          //         disableClipboard: true,
          //         placeholder: 'Start writing your thoughts here..',
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
