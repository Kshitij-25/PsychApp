import 'package:hooks_riverpod/hooks_riverpod.dart';

enum IconType { registerPassword, confirmPassword, loginPassword }

final iconStateProvider = StateNotifierProvider<IconStateNotifier, Map<IconType, bool>>((ref) {
  return IconStateNotifier();
});

class IconStateNotifier extends StateNotifier<Map<IconType, bool>> {
  IconStateNotifier()
      : super({
          IconType.registerPassword: true, // Initially showing eye icon as true
          IconType.confirmPassword: true, // Initially showing heart icon as false
          IconType.loginPassword: true, // Initially showing star icon as false
        });

  void toggleIcon(IconType iconType) {
    state = {
      ...state, // Keep the previous state
      iconType: !state[iconType]!, // Toggle the icon type
    };
  }
}
