import 'package:equatable/equatable.dart';

/// Các sự kiện cho Profile screen
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Sự kiện load thông tin profile
class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

/// Sự kiện refresh profile
class RefreshProfile extends ProfileEvent {
  const RefreshProfile();
}

/// Sự kiện cập nhật profile
class UpdateProfile extends ProfileEvent {
  final String? name;
  final String? email;
  final String? phone;
  final String? location;
  final String? bio;
  final String? avatar;

  const UpdateProfile({
    this.name,
    this.email,
    this.phone,
    this.location,
    this.bio,
    this.avatar,
  });

  @override
  List<Object?> get props => [name, email, phone, location, bio, avatar];
}

/// Sự kiện toggle notification
class ToggleNotification extends ProfileEvent {
  final String notificationType;
  final bool value;

  const ToggleNotification({
    required this.notificationType,
    required this.value,
  });

  @override
  List<Object?> get props => [notificationType, value];
}

/// Sự kiện toggle dark mode
class ToggleDarkMode extends ProfileEvent {
  final bool isDarkMode;

  const ToggleDarkMode(this.isDarkMode);

  @override
  List<Object?> get props => [isDarkMode];
}

/// Sự kiện đổi mật khẩu
class ChangePassword extends ProfileEvent {
  final String oldPassword;
  final String newPassword;

  const ChangePassword({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

/// Sự kiện logout
class Logout extends ProfileEvent {
  const Logout();
}

/// Sự kiện xóa tài khoản
class DeleteAccount extends ProfileEvent {
  const DeleteAccount();
}

/// Sự kiện cập nhật language
class UpdateLanguage extends ProfileEvent {
  final String language;

  const UpdateLanguage(this.language);

  @override
  List<Object?> get props => [language];
}
