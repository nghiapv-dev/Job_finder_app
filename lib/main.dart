import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'config/theme/app_theme.dart';
import 'core/repositories/auth_repository.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/shared/screens/welcome_screen.dart';
import 'features/shared/screens/welcome_home_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/reset_password_screen.dart';
import 'features/auth/screens/job_preference_screen.dart';
import 'features/auth/screens/profile_setup_screen.dart';
import 'features/auth/screens/profile_confirm_screen.dart';
import 'features/job_seeker/screens/home_screen.dart';
import 'features/job_seeker/screens/notification_screen.dart';
import 'features/job_seeker/screens/tips_list_screen.dart';
import 'features/job_seeker/screens/tips_detail_screen.dart';
import 'features/job_seeker/screens/job_search_screen.dart';
import 'features/job_seeker/screens/job_detail_screen.dart';
import 'features/job_seeker/screens/upload_resume_screen.dart';

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

// GoRouter Configuration
final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/welcome-home',
      builder: (context, state) => const WelcomeHomeScreen(),
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
  ],
);
