import 'package:fpdart/fpdart.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_caching_app/core/error/failure.dart';
import 'package:video_caching_app/core/error/exception.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final GetStorage _storage;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required GetStorage storage,
  }) : _remoteDataSource = remoteDataSource,
       _storage = storage;

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  @override
  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    try {
      final response = await _remoteDataSource.signInWithGoogle();
      await _saveAuthData(response.token, response.user);
      return Right(response.user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInWithApple() async {
    try {
      final response = await _remoteDataSource.signInWithApple();
      await _saveAuthData(response.token, response.user);
      return Right(response.user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInWithLine() async {
    try {
      final response = await _remoteDataSource.signInWithLine();
      await _saveAuthData(response.token, response.user);
      return Right(response.user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return _storage.hasData(_tokenKey);
  }

  @override
  Future<UserModel?> getUser() async {
    final userData = _storage.read(_userKey);
    if (userData != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(userData));
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_userKey);
  }

  Future<void> _saveAuthData(String token, UserModel user) async {
    await _storage.write(_tokenKey, token);
    await _storage.write(_userKey, user.toJson());
  }
}
