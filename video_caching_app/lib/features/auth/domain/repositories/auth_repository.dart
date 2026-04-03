import 'package:fpdart/fpdart.dart';
import 'package:video_caching_app/core/error/failure.dart';
import 'package:video_caching_app/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signInWithGoogle();
  Future<Either<Failure, UserModel>> signInWithApple();
  Future<Either<Failure, UserModel>> signInWithLine();
  Future<bool> isAuthenticated();
  Future<UserModel?> getUser();
  Future<void> logout();
}
