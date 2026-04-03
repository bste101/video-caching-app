import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.googleSignInRequested() = GoogleSignInRequested;
  const factory AuthEvent.appleSignInRequested() = AppleSignInRequested;
  const factory AuthEvent.lineSignInRequested() = LineSignInRequested;
  const factory AuthEvent.logoutRequested() = LogoutRequested;
  const factory AuthEvent.authCheckRequested() = AuthCheckRequested;
}
