import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'config/theme/app_theme.dart';
import 'core/repositories/auth_repository.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/shared/screens/welcome_screen.dart';
import 'features/auth/screens/role_selection_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/reset_password_screen.dart';
import 'features/auth/screens/job_preference_screen.dart';
import 'features/auth/screens/profile_setup_screen.dart';
import 'features/auth/screens/profile_confirm_screen.dart';
// Các màn hình Home
import 'features/job_seeker/home/home_screen.dart';
import 'features/job_seeker/home/notification_screen.dart';
import 'features/job_seeker/home/tips_list_screen.dart';
import 'features/job_seeker/home/tips_detail_screen.dart';
import 'features/job_seeker/home/job_search_screen.dart';
import 'features/job_seeker/home/job_detail_screen.dart';
import 'features/job_seeker/home/upload_resume_screen.dart';
import 'features/job_seeker/home/job_recommendation_screen.dart';
// Các màn hình Applications
import 'features/job_seeker/applications/applications_screen.dart';
import 'features/job_seeker/applications/application_detail_screen.dart';
// Các màn hình Saved Jobs
import 'features/job_seeker/saved_jobs/saved_jobs_screen.dart';
// Các màn hình Chat
import 'features/job_seeker/chat/chat_box_screen.dart';
import 'features/job_seeker/chat/chat_detail_screen.dart';
// Các màn hình Profile
import 'features/job_seeker/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authRepository: AuthRepository()),
      child: MaterialApp.router(
        title: 'Gawean - Job Finder',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      ),
    );
  }
}

// Cấu hình GoRouter
final _router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/select-role',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/job-preference',
      builder: (context, state) => const JobPreferenceScreen(),
    ),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/profile-confirm',
      builder: (context, state) => const ProfileConfirmScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/tips-list',
      builder: (context, state) => const TipsListScreen(),
    ),
    GoRoute(
      path: '/tips-detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return TipsDetailScreen(
          tipData: extra ?? {},
        );
      },
    ),
    GoRoute(
      path: '/job-search',
      builder: (context, state) => const JobSearchScreen(),
    ),
    GoRoute(
      path: '/job-recommendation',
      builder: (context, state) => const JobRecommendationScreen(),
    ),
    GoRoute(
      path: '/job-detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return JobDetailScreen(
          jobData: extra,
        );
      },
    ),
    GoRoute(
      path: '/upload-resume',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return UploadResumeScreen(
          jobData: extra,
        );
      },
    ),
    GoRoute(
      path: '/applications',
      builder: (context, state) => const ApplicationsScreen(),
    ),
    GoRoute(
      path: '/application-detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ApplicationDetailScreen(
          applicationData: extra ?? {},
        );
      },
    ),
    GoRoute(
      path: '/saved-jobs',
      builder: (context, state) => const SavedJobsScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatBoxScreen(),
    ),
    GoRoute(
      path: '/chat-detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ChatDetailScreen(
          chatData: extra ?? {},
        );
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
