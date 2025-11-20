import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// BLoC quản lý logic cho Profile screen
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<RefreshProfile>(_onRefreshProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ToggleNotification>(_onToggleNotification);
    on<ToggleDarkMode>(_onToggleDarkMode);
    on<ChangePassword>(_onChangePassword);
    on<Logout>(_onLogout);
    on<DeleteAccount>(_onDeleteAccount);
    on<UpdateLanguage>(_onUpdateLanguage);
  }

  /// Xử lý sự kiện load profile
  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    try {
      // TODO: Gọi API hoặc repository để lấy dữ liệu
      await Future.delayed(const Duration(seconds: 1));

      final profile = _getDummyProfile();
      final notificationSettings = const NotificationSettings();
      final appSettings = const AppSettings();

      emit(ProfileLoaded(
        profile: profile,
        notificationSettings: notificationSettings,
        appSettings: appSettings,
      ));
    } catch (e) {
      emit(ProfileError('Không thể tải dữ liệu: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện refresh profile
  Future<void> _onRefreshProfile(
    RefreshProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final profile = _getDummyProfile();

      if (currentState is ProfileLoaded) {
        emit(currentState.copyWith(profile: profile));
      } else {
        emit(ProfileLoaded(
          profile: profile,
          notificationSettings: const NotificationSettings(),
          appSettings: const AppSettings(),
        ));
      }
    } catch (e) {
      emit(ProfileError('Không thể làm mới dữ liệu: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện update profile
  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    try {
      // TODO: Gọi API để cập nhật profile
      await Future.delayed(const Duration(milliseconds: 800));

      final updatedProfile = currentState.profile.copyWith(
        name: event.name,
        email: event.email,
        phone: event.phone,
        location: event.location,
        bio: event.bio,
        avatar: event.avatar,
      );

      emit(currentState.copyWith(profile: updatedProfile));
      emit(const ProfileUpdated('Cập nhật profile thành công'));
      emit(currentState.copyWith(profile: updatedProfile));
    } catch (e) {
      emit(ProfileError('Không thể cập nhật profile: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện toggle notification
  Future<void> _onToggleNotification(
    ToggleNotification event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    try {
      // TODO: Gọi API để lưu settings
      await Future.delayed(const Duration(milliseconds: 200));

      NotificationSettings updatedSettings;

      switch (event.notificationType) {
        case 'jobAlerts':
          updatedSettings = currentState.notificationSettings.copyWith(
            jobAlerts: event.value,
          );
          break;
        case 'applicationUpdates':
          updatedSettings = currentState.notificationSettings.copyWith(
            applicationUpdates: event.value,
          );
          break;
        case 'messageNotifications':
          updatedSettings = currentState.notificationSettings.copyWith(
            messageNotifications: event.value,
          );
          break;
        case 'emailNotifications':
          updatedSettings = currentState.notificationSettings.copyWith(
            emailNotifications: event.value,
          );
          break;
        case 'pushNotifications':
          updatedSettings = currentState.notificationSettings.copyWith(
            pushNotifications: event.value,
          );
          break;
        default:
          updatedSettings = currentState.notificationSettings;
      }

      emit(currentState.copyWith(notificationSettings: updatedSettings));
    } catch (e) {
      emit(ProfileError('Không thể cập nhật cài đặt: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện toggle dark mode
  Future<void> _onToggleDarkMode(
    ToggleDarkMode event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    try {
      // TODO: Gọi API để lưu settings
      await Future.delayed(const Duration(milliseconds: 200));

      final updatedSettings = currentState.appSettings.copyWith(
        isDarkMode: event.isDarkMode,
      );

      emit(currentState.copyWith(appSettings: updatedSettings));
    } catch (e) {
      emit(ProfileError('Không thể cập nhật cài đặt: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện change password
  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    try {
      // TODO: Gọi API để đổi mật khẩu
      await Future.delayed(const Duration(seconds: 1));

      // Validate old password
      if (event.oldPassword.length < 6) {
        emit(const ProfileError('Mật khẩu cũ không đúng'));
        emit(currentState);
        return;
      }

      // Validate new password
      if (event.newPassword.length < 6) {
        emit(const ProfileError('Mật khẩu mới phải có ít nhất 6 ký tự'));
        emit(currentState);
        return;
      }

      emit(const PasswordChanged('Đổi mật khẩu thành công'));
      emit(currentState);
    } catch (e) {
      emit(ProfileError('Không thể đổi mật khẩu: ${e.toString()}'));
      emit(currentState);
    }
  }

  /// Xử lý sự kiện logout
  Future<void> _onLogout(
    Logout event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // TODO: Gọi API để logout, clear tokens, etc.
      await Future.delayed(const Duration(milliseconds: 500));

      emit(const LogoutSuccess());
    } catch (e) {
      emit(ProfileError('Không thể đăng xuất: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện delete account
  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // TODO: Gọi API để xóa tài khoản
      await Future.delayed(const Duration(seconds: 1));

      emit(const AccountDeleted());
    } catch (e) {
      emit(ProfileError('Không thể xóa tài khoản: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện update language
  Future<void> _onUpdateLanguage(
    UpdateLanguage event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    try {
      // TODO: Gọi API để lưu settings
      await Future.delayed(const Duration(milliseconds: 200));

      final updatedSettings = currentState.appSettings.copyWith(
        language: event.language,
      );

      emit(currentState.copyWith(appSettings: updatedSettings));
      emit(const ProfileUpdated('Đã cập nhật ngôn ngữ'));
      emit(currentState.copyWith(appSettings: updatedSettings));
    } catch (e) {
      emit(ProfileError('Không thể cập nhật ngôn ngữ: ${e.toString()}'));
    }
  }

  /// Dữ liệu mẫu cho profile
  ProfileModel _getDummyProfile() {
    return ProfileModel(
      id: '1',
      name: 'Nguyễn Văn A',
      email: 'nguyenvana@example.com',
      phone: '+84 123 456 789',
      location: 'Hà Nội, Việt Nam',
      bio: 'Kỹ sư phần mềm với 5 năm kinh nghiệm trong phát triển ứng dụng mobile với Flutter.',
      avatar: 'https://ui-avatars.com/api/?name=Nguyen+Van+A&background=3366FF&color=fff',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      appliedJobs: 12,
      savedJobs: 8,
      activeChats: 5,
    );
  }
}
