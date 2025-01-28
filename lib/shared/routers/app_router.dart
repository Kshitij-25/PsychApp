import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/articles.dart';
import '../../data/models/journal_entry.dart';
import '../../data/models/psychologist_model.dart';
import '../../presentation/screens/appointment/book_appointment_screen.dart';
import '../../presentation/screens/article/article_screen.dart';
import '../../presentation/screens/auth/email_verification_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/chat/inbox_screen.dart';
import '../../presentation/screens/home/home_navigator.dart';
import '../../presentation/screens/home/psychologist_home_nav.dart';
import '../../presentation/screens/journal/create_journal_screen.dart';
import '../../presentation/screens/journal/journal_screen.dart';
import '../../presentation/screens/mood/mood_navigator.dart';
import '../../presentation/screens/notifications/notification_screen.dart';
import '../../presentation/screens/profile/therapist_profile_screen.dart';
import '../../presentation/screens/profile_creation/profile_creation_questions.dart';
import '../../presentation/screens/profile_creation/psychologist_profile_creation.dart';
import '../../presentation/screens/questionnaire/initial_questions_screen.dart';
import '../../presentation/screens/questionnaire/questionnaire_permission_screen.dart';
import '../../presentation/screens/support/support_screen.dart';
import '../../presentation/screens/welcome/landing_screen.dart';
import '../../presentation/screens/welcome/onboarding_screen.dart';
import '../../presentation/screens/welcome/splash_screen.dart';
import '../constants/firebase_helper.dart';

class AppRouter {
  AppRouter._();

  // static Future<String> getUserRole(String uid) async {
  //   DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  //   if (userDoc.exists) {
  //     return userDoc['role']; // 'admin', 'user', etc.
  //   }
  //   return 'user'; // Default role
  // }

  static Future<String?> checkUserRole() async {
    User? user = FirebaseHelper.currentUser;

    if (user != null) {
      String userRole = await FirebaseHelper.getUserRole(user.uid);
      if (userRole == 'user') {
        return HomeNavigator.routeName; // Return the correct route for a user
      } else {
        return PsychologistHomeNav.routeName; // Return the correct route for a psychologist
      }
    }
    return SplashScreen.routeName; // Return null if the user is not logged in
  }

  static late GoRouter router;

  static Future<void> setupRoutes() async {
    final initialRoute = await checkUserRole();
    router = GoRouter(
      debugLogDiagnostics: false,
      initialLocation: initialRoute,
      routes: _routes,
    );
  }

  static final List<GoRoute> _routes = [
    GoRoute(
      name: SplashScreen.routeName,
      path: SplashScreen.routeName,
      builder: (context, state) => const SplashScreen(),
      routes: [],
    ),
    GoRoute(
      name: OnboardingScreen.routeName,
      path: OnboardingScreen.routeName,
      builder: (context, state) => const OnboardingScreen(),
      routes: [],
    ),
    GoRoute(
      name: LandingScreen.routeName,
      path: LandingScreen.routeName,
      builder: (context, state) => LandingScreen(),
      routes: [
        GoRoute(
          name: LoginScreen.routeName,
          path: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
          routes: [
            GoRoute(
              name: ForgotPasswordScreen.routeName,
              path: ForgotPasswordScreen.routeName,
              builder: (context, state) => const ForgotPasswordScreen(),
              routes: [],
            ),
          ],
        ),
        GoRoute(
          name: EmailVerificationScreen.routeName,
          path: EmailVerificationScreen.routeName,
          builder: (context, state) => const EmailVerificationScreen(),
          routes: [
            // GoRoute(
            //   name: OtpScreen.routeName,
            //   path: OtpScreen.routeName,
            //   builder: (context, state) => OtpScreen(
            //     isResetPassword: state.extra is bool ? state.extra as bool : false,
            //   ),
            //   routes: [],
            // ),
            // GoRoute(
            //   name: SetPasswordScreen.routeName,
            //   path: SetPasswordScreen.routeName,
            //   builder: (context, state) => SetPasswordScreen(
            //     isResetPassword: state.extra is bool ? state.extra as bool : false,
            //   ),
            //   routes: [],
            // ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: ProfileCreationQuestions.routeName,
      path: ProfileCreationQuestions.routeName,
      builder: (context, state) => ProfileCreationQuestions(
          // isResetPassword: state.extra is bool ? state.extra as bool : false,
          ),
      routes: [],
    ),
    GoRoute(
      name: PsychologistProfileCreation.routeName,
      path: PsychologistProfileCreation.routeName,
      builder: (context, state) => PsychologistProfileCreation(
          // isResetPassword: state.extra is bool ? state.extra as bool : false,
          ),
      routes: [],
    ),
    GoRoute(
      name: QuestionnairePermissionScreen.routeName,
      path: QuestionnairePermissionScreen.routeName,
      builder: (context, state) => const QuestionnairePermissionScreen(),
      routes: [
        GoRoute(
          name: InitialQuestionsScreen.routeName,
          path: InitialQuestionsScreen.routeName,
          builder: (context, state) => const InitialQuestionsScreen(),
          routes: [],
        ),
      ],
    ),
    GoRoute(
      name: PsychologistHomeNav.routeName,
      path: PsychologistHomeNav.routeName,
      builder: (context, state) => PsychologistHomeNav(),
      routes: [],
    ),
    GoRoute(
      name: HomeNavigator.routeName,
      path: HomeNavigator.routeName,
      builder: (context, state) => const HomeNavigator(),
      routes: [
        GoRoute(
          name: TherapistProfileScreen.routeName,
          path: TherapistProfileScreen.routeName,
          builder: (context, state) => TherapistProfileScreen(
            psychologistsData: state.extra as PsychologistModel,
          ),
          routes: [
            GoRoute(
              name: BookAppointmentScreen.routeName,
              path: BookAppointmentScreen.routeName,
              builder: (context, state) => BookAppointmentScreen(
                psychologistsData: state.extra as PsychologistModel,
              ),
              routes: [],
            ),
          ],
        ),
        GoRoute(
          name: ArticleScreen.routeName,
          path: ArticleScreen.routeName,
          builder: (context, state) => ArticleScreen(
            articleData: state.extra as Article,
          ),
          routes: [],
        ),
        GoRoute(
          name: JournalScreen.routeName,
          path: JournalScreen.routeName,
          builder: (context, state) => JournalScreen(),
          routes: [
            GoRoute(
              name: CreateJournalScreen.routeName,
              path: CreateJournalScreen.routeName,
              builder: (context, state) => CreateJournalScreen(
                existingNote: state.extra as JournalEntry?,
              ),
              routes: [],
            ),
          ],
        ),
        GoRoute(
          name: InboxScreen.routeName,
          path: InboxScreen.routeName,
          builder: (context, state) => InboxScreen(),
          routes: [],
        ),
        GoRoute(
          name: NotificationScreen.routeName,
          path: NotificationScreen.routeName,
          builder: (context, state) => NotificationScreen(),
          routes: [],
        ),
        GoRoute(
          name: SupportScreen.routeName,
          path: SupportScreen.routeName,
          builder: (context, state) => SupportScreen(),
          routes: [],
        ),
        GoRoute(
          name: MoodNavigator.routeName,
          path: MoodNavigator.routeName,
          builder: (context, state) => MoodNavigator(),
          routes: [],
        ),
      ],
    ),
  ];
}
