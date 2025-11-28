class ApiConstants {
  // Base URL - Change this to your backend URL
  // localhost for Web/iOS, 10.0.2.2 for Android Emulator
  static const String baseUrl = 'http://localhost:5000/api';
  static const String serverUrl = 'http://localhost:5000';
  
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String googleAuth = '/auth/google';
  static const String facebookAuth = '/auth/facebook';
  
  // User Endpoints
  static const String currentUser = '/users/me';
  static const String profile = '/users/me'; // Alias for currentUser
  static const String updateProfile = '/users/me';
  static const String changePassword = '/users/me/password';
  static const String uploadAvatar = '/users/me/avatar';
  static const String uploadCv = '/users/me/cv';
  
  // Job Endpoints
  static const String jobs = '/jobs';
  static const String jobDetail = '/jobs'; // + /{id}
  static const String featuredJobs = '/jobs/featured';
  static const String recentJobs = '/jobs/recent';
  static const String recommendedJobs = '/jobs/recommended';
  static const String savedJobs = '/jobs/saved';
  static const String saveJob = '/jobs'; // + /{id}/save
  static const String unsaveJob = '/jobs'; // + /{id}/unsave
  
  // Company Endpoints
  static const String companies = '/companies';
  static const String companyDetail = '/companies'; // + /{id}
  static const String companyJobs = '/companies'; // + /{id}/jobs
  
  // Application Endpoints
  static const String applications = '/applications';
  static const String applicationDetail = '/applications'; // + /{id}
  static const String applyJob = '/applications';
  static const String withdrawApplication = '/applications'; // + /{id}
  
  // Category Endpoints
  static const String categories = '/categories';
  static const String categoryJobs = '/categories'; // + /{id}/jobs
  
  // Notification Endpoints
  static const String notifications = '/notifications';
  static const String readNotification = '/notifications'; // + /{id}/read
  static const String readAllNotifications = '/notifications/read-all';
  
  // Search Endpoints
  static const String searchJobs = '/search/jobs';
  static const String searchCompanies = '/search/companies';
  
  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
