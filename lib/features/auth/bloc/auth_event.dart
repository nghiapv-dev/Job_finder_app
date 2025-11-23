part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  List<Object?> get props => [email, password, fullName];
}

class AuthGoogleLoginRequested extends AuthEvent {
  const AuthGoogleLoginRequested();
}

class AuthFacebookLoginRequested extends AuthEvent {
  const AuthFacebookLoginRequested();
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthCheckStatus extends AuthEvent {
  const AuthCheckStatus();
}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  const AuthForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;
  final String code;
  final String newPassword;

  const AuthResetPasswordRequested({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, code, newPassword];
}

class AuthRoleSelected extends AuthEvent {
  final String role;

  const AuthRoleSelected(this.role);

  @override
  List<Object?> get props => [role];
}

class AuthProfileUpdateRequested extends AuthEvent {
  final String? fullName;
  final String? dateOfBirth;
  final String? address;
  final String? occupation;
  final String? avatarUrl;

  const AuthProfileUpdateRequested({
    this.fullName,
    this.dateOfBirth,
    this.address,
    this.occupation,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [fullName, dateOfBirth, address, occupation, avatarUrl];
}
