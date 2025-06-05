import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/user_profile_data/user_profile_model.dart';
import '../../../shared/constants/hive_helper.dart';
import '../community/community_home.dart';
import '../journal/journal_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';
import '../search/therapist_search_screen.dart';
import 'home_screen.dart';
import 'search_delegate.dart';

// class PsychologistNotifier extends StateNotifier<List<PsychologistModel>> {
//   PsychologistNotifier() : super([]) {
//     fetchPsychologists();
//   }

//   Future<void> fetchPsychologists() async {
//     Future<List<PsychologistModel>> loadPsychologistsData() async {
//       String jsonString = await rootBundle.loadString(Assets.psychologistsData);
//       List<dynamic> jsonResponse = jsonDecode(jsonString);
//       return jsonResponse.map((data) => PsychologistModel.fromJson(data)).toList();
//     }

//     try {
//       final psychologists = await loadPsychologistsData();
//       state = psychologists;
//     } catch (e) {
//       print("Error loading psychologists data: $e");
//     }
//   }
// }

class HomeNavigator extends HookConsumerWidget {
  static const routeName = '/homeNavigator';
  const HomeNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final _pageController = usePageController(initialPage: currentIndex.value);

    final userProfile = useState<UserProfileModel?>(null); // ✅ Store in useState()
    final userLoggedIn = useState<bool?>(false); // ✅ Store in useState()

    Future<void> loadUserProfile() async {
      final profile = await HiveHelper.getUserData();
      final isLoggedIn = await HiveHelper.isLoggedIn();
      userProfile.value = profile; // ✅ Update state, triggers rebuild
      userLoggedIn.value = isLoggedIn;
    }

    useEffect(
      () {
        loadUserProfile();
        return null;
      },
      [],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        centerTitle: false,
        title: Text(
          currentIndex.value == 0
              ? 'Home'
              : currentIndex.value == 1 && userLoggedIn.value == false
                  ? 'Feeds'
                  : currentIndex.value == 1 && userLoggedIn.value == true
                      ? 'Search'
                      : currentIndex.value == 2 && userLoggedIn.value == true
                          ? 'Feeds'
                          : 'Profile',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          if (currentIndex.value == 1)
            Consumer(
              builder: (context, ref, _) {
                final psychologistDataAsync = ref.watch(psychologistStreamProvider);

                return psychologistDataAsync.when(
                  data: (psychologistsData) {
                    return IconButton(
                      tooltip: 'Search',
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: PsychologistSearchDelegate(psychologistsData),
                        );
                      },
                      icon: Icon(CupertinoIcons.search),
                    );
                  },
                  loading: () => IconButton(
                    tooltip: 'Search',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Data is still loading...')),
                      );
                    },
                    icon: Icon(CupertinoIcons.search),
                  ),
                  error: (error, stackTrace) => IconButton(
                    tooltip: 'Search',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error loading data: $error')),
                      );
                    },
                    icon: Icon(CupertinoIcons.search),
                  ),
                );
              },
            ),
          if (currentIndex.value != 3)
            IconButton(
              tooltip: 'Journals',
              onPressed: () {
                context.pushNamed(JournalScreen.routeName);
              },
              icon: Icon(CupertinoIcons.doc_plaintext),
            ),
          if (currentIndex.value == 1 || currentIndex.value == 0)
            IconButton(
              tooltip: 'Notifications',
              onPressed: () async {
                // context.pushNamed(PsychologistProfileCreation.routeName);
                // try {
                //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
                //   final tz.TZDateTime scheduledTime = now.add(Duration(minutes: 1));

                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text("Notification set for ${DateFormat('hh:mm a').format(scheduledTime)}"),
                //     ),
                //   );
                //   await LocalNotificationService().scheduleNotificationForOneMinute();
                // } catch (e) {
                //   print("Error scheduling notification: $e");
                // }
              },
              icon: Icon(CupertinoIcons.bell),
            ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          currentIndex.value = index;
        },
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(),
          if (userLoggedIn.value == true) SearchScreen(),
          CommunityHome(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(
        context,
        currentIndex,
        _pageController,
        userProfile,
        userLoggedIn,
      ),
    );
  }

  Widget _buildBottomNavBar(
    BuildContext context,
    ValueNotifier<int> currentIndex,
    PageController _pageController,
    ValueNotifier<UserProfileModel?> userProfile,
    ValueNotifier<bool?> userLoggedIn,
  ) {
    return BottomNavigationBar(
      currentIndex: currentIndex.value,
      enableFeedback: true,
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.primaryContainer),
      selectedLabelStyle: Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle,
      unselectedLabelStyle: Theme.of(context).bottomNavigationBarTheme.unselectedLabelStyle,
      unselectedIconTheme: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme,
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        _pageController.jumpToPage(index);
        currentIndex.value = index;
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.house_fill),
          label: 'Home',
        ),
        if (userLoggedIn.value == true)
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
          ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.newspaper),
          label: 'Feed',
        ),
        if (userLoggedIn.value != true)
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_fill),
            label: 'Profile',
          ),
        if (userLoggedIn.value == true)
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: currentIndex.value == 3 ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surface,
                ),
                Positioned(
                  top: 3,
                  left: 3,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: userProfile.value?.profilePicUrl != null && userProfile.value?.profilePicUrl != ""
                        ? CachedNetworkImageProvider(
                            userProfile.value?.profilePicUrl ?? '',
                            cacheKey: userProfile.value?.profilePicUrl,
                          )
                        : null,
                    backgroundColor: Colors.white,
                    child: userProfile.value?.profilePicUrl == null && userProfile.value?.profilePicUrl == ""
                        ? Icon(CupertinoIcons.person)
                        : SizedBox.shrink(),
                  ),
                ),
              ],
            ),
            label: 'Profile',
          ),
      ],
    );
  }
}
