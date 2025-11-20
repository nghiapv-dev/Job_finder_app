import 'package:equatable/equatable.dart';

/// Trạng thái của Profile screen
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái khởi tạo
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// Trạng thái đang tải dữ liệu
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// Trạng thái đã tải profile thành công
class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  final NotificationSettings notificationSettings;
  final AppSettings appSettings;

  const ProfileLoaded({
    required this.profile,
    required this.notificationSettings,
    required this.appSettings,
  });

  @override
  List<Object?> get props => [profile, notificationSettings, appSettings];

  ProfileLoaded copyWith({
    ProfileModel? profile,
    NotificationSettings? notificationSettings,
    AppSettings? appSettings,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      appSettings: appSettings ?? this.appSettings,
    );
  }
}

/// Trạng thái lỗi
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Trạng thái cập nhật thành công
class ProfileUpdated extends ProfileState {
  final String message;

  const ProfileUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

/// Trạng thái đổi mật khẩu thành công
class PasswordChanged extends ProfileState {
  final String message;

  const PasswordChanged(this.message);

  @override
  List<Object?> get props => [message];
}

/// Trạng thái logout thành công
class LogoutSuccess extends ProfileState {
  const LogoutSuccess();
}

/// Trạng thái xóa tài khoản thành công
class AccountDeleted extends ProfileState {
  const AccountDeleted();
}

/// Model cho Profile
class ProfileModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final String bio;
  final String avatar;
  final DateTime createdAt;
  final int appliedJobs;
  final int savedJobs;
  final int activeChats;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.bio,
    required this.avatar,
    required this.createdAt,
    this.appliedJobs = 0,
    this.savedJobs = 0,
    this.activeChats = 0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        location,
        bio,
        avatar,
        createdAt,
        appliedJobs,
        savedJobs,
        activeChats,
      ];

  ProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? bio,
    String? avatar,
    DateTime? createdAt,
    int? appliedJobs,
    int? savedJobs,
    int? activeChats,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      appliedJobs: appliedJobs ?? this.appliedJobs,
      savedJobs: savedJobs ?? this.savedJobs,
      activeChats: activeChats ?? this.activeChats,
    );
  }

  /// Lấy initials từ name
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0].substring(0, 2).toUpperCase();
    }
    return 'NA';
  }

  /// Format membership duration
  String get memberSince {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    final years = difference.inDays ~/ 365;
    final months = (difference.inDays % 365) ~/ 30;

    if (years > 0) {
      return '$years năm';
    } else if (months > 0) {
      return '$months tháng';
    } else {
      return '${difference.inDays} ngày';
    }
  }
}

/// Model cho Notification Settings
class NotificationSettings extends Equatable {
  final bool jobAlerts;
  final bool applicationUpdates;
  final bool messageNotifications;
  final bool emailNotifications;
  final bool pushNotifications;

  const NotificationSettings({
    this.jobAlerts = true,
    this.applicationUpdates = true,
    this.messageNotifications = true,
    this.emailNotifications = false,
    this.pushNotifications = true,
  });

  @override
  List<Object?> get props => [
        jobAlerts,
        applicationUpdates,
        messageNotifications,
        emailNotifications,
        pushNotifications,
      ];

  NotificationSettings copyWith({
    bool? jobAlerts,
    bool? applicationUpdates,
    bool? messageNotifications,
    bool? emailNotifications,
    bool? pushNotifications,
  }) {
    return NotificationSettings(
      jobAlerts: jobAlerts ?? this.jobAlerts,
      applicationUpdates: applicationUpdates ?? this.applicationUpdates,
      messageNotifications: messageNotifications ?? this.messageNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
    );
  }
}

/// Model cho App Settings
class AppSettings extends Equatable {
  final bool isDarkMode;
  final String language;
  final bool autoPlayVideos;
  final bool dataOptimization;

  const AppSettings({
    this.isDarkMode = false,
    this.language = 'vi',
    this.autoPlayVideos = true,
    this.dataOptimization = false,
  });

  @override
  List<Object?> get props => [
        isDarkMode,
        language,
        autoPlayVideos,
        dataOptimization,
      ];

  AppSettings copyWith({
    bool? isDarkMode,
    String? language,
    bool? autoPlayVideos,
    bool? dataOptimization,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      autoPlayVideos: autoPlayVideos ?? this.autoPlayVideos,
      dataOptimization: dataOptimization ?? this.dataOptimization,
    );
  }
}
