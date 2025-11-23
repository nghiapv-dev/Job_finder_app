import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/utils/storage_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthGoogleLoginRequested>(_onGoogleLoginRequested);
    on<AuthFacebookLoginRequested>(_onFacebookLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await authRepository.login(
        email: event.email,
        password: event.password,
      );

      // Dữ liệu trả về từ repository bây giờ là một Map chứa 'user' và 'token'
      final user = result['user'];
      final token = result['token'];

      // Kiểm tra null trước khi sử dụng
      if (user != null && token != null) {
        await StorageService.saveToken(token);
        await StorageService.saveUser(user.toString()); // Cân nhắc dùng jsonEncode

        emit(AuthAuthenticated(
          user: user,
          token: token,
        ));
      } else {
        // Nếu một trong hai là null, coi như đăng nhập thất bại
        emit(const AuthError(message: 'Login response is invalid.'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await authRepository.register(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      );

      await StorageService.saveToken(result['token']);
      await StorageService.saveUser(result['user'].toString());

      emit(AuthAuthenticated(
        user: result['user'],
        token: result['token'],
      ));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onGoogleLoginRequested(
    AuthGoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await authRepository.loginWithGoogle();

      await StorageService.saveToken(result['token']);
      await StorageService.saveUser(result['user'].toString());

      emit(AuthAuthenticated(
        user: result['user'],
        token: result['token'],
      ));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onFacebookLoginRequested(
    AuthFacebookLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await authRepository.loginWithFacebook();

      await StorageService.saveToken(result['token']);
      await StorageService.saveUser(result['user'].toString());

      emit(AuthAuthenticated(
        user: result['user'],
        token: result['token'],
      ));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await authRepository.logout();
      await StorageService.clearAll();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    final isLoggedIn = await StorageService.isLoggedIn();
    if (isLoggedIn) {
      final token = await StorageService.getToken();
      final userJson = await StorageService.getUser();
      
      if (token != null && userJson != null) {
        // Parse user data from JSON
        // You might want to use json_decode here
        emit(AuthAuthenticated(
          user: {}, // Parse from userJson
          token: token,
        ));
      } else {
        emit(const AuthUnauthenticated());
      }
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final message = await authRepository.forgotPassword(email: event.email);
      emit(AuthForgotPasswordSuccess(message: message));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final message = await authRepository.resetPassword(
        email: event.email,
        code: event.code,
        newPassword: event.newPassword,
      );
      emit(AuthResetPasswordSuccess(message: message));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
