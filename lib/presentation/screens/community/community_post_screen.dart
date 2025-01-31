import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../notifiers/post_notifier.dart';

class CommunityPostScreen extends HookConsumerWidget {
  static const routeName = '/communityPostScreen';
  const CommunityPostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final controller = useTextEditingController();
    final characterCount = useState(0);
    final selectedImage = useState<File?>(null); // Add image state

    Future<void> _pickImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 90,
      );
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    }

    void _removeImage() {
      selectedImage.value = null;
    }

    useEffect(() {
      focusNode.requestFocus();
      controller.addListener(() {
        characterCount.value = controller.text.length;
      });
      return null;
    }, []);

    return GestureDetector(
      onTap: () => focusNode.requestFocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(CupertinoIcons.clear),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: characterCount.value != 0
                  ? () {
                      _postContent(
                        context: context,
                        ref: ref,
                        textContent: controller,
                        characterCount: characterCount,
                        selectedImage: selectedImage,
                      );
                    }
                  : () {},
              child: const Text('Post'),
            )
          ],
        ),
        body: Column(
          children: [
            // Image preview with remove button
            if (selectedImage.value != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          selectedImage.value!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _removeImage,
                      icon: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  focusNode: focusNode,
                  controller: controller,
                  autofocus: true,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Share your thoughts with the community...',
                    border: InputBorder.none,
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            // Custom keyboard toolbar
            SafeArea(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade800)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(CupertinoIcons.camera_fill),
                        onPressed: _pickImage, // Updated to use image picker
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _postContent({
    required BuildContext context,
    required WidgetRef ref,
    required TextEditingController textContent,
    required ValueNotifier<int> characterCount,
    required ValueNotifier<File?> selectedImage,
  }) {
    final createPost = ref.watch(createPostProvider.notifier);

    if (textContent.text.isNotEmpty) {
      createPost.createPost(
        content: textContent.text,
        imageFile: selectedImage.value,
      );
      context.pop();
    }
  }
}
