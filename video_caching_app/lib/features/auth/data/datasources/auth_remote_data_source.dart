import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:video_caching_app/core/error/exception.dart';
import '../models/auth_response.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> signInWithGoogle();
  Future<AuthResponse> signInWithApple();
  Future<AuthResponse> signInWithLine();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GoogleSignIn _googleSignIn;
  final Dio _dio;

  AuthRemoteDataSourceImpl({
    required GoogleSignIn googleSignIn,
    required Dio dio,
  })  : _googleSignIn = googleSignIn,
        _dio = dio;

  // Base URL for backend - should be moved to config later
  static final String _baseUrl = dotenv.get('API_BASE_URL', fallback: 'http://localhost:8000/api');

  @override
  Future<AuthResponse> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.authenticate();
      if (account == null) {
        throw AuthException(message: 'Sign-in cancelled', provider: 'google');
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;

      return await _loginToBackend('google', idToken!);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(message: 'Google login failed: $e', provider: 'google');
    }
  }

  @override
  Future<AuthResponse> signInWithApple() async {
    try {
      final appleClientId = dotenv.get('APPLE_CLIENT_ID', fallback: '');
      final appleRedirectUri = dotenv.get('APPLE_REDIRECT_URI', fallback: '');

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: appleClientId.isNotEmpty && appleRedirectUri.isNotEmpty
            ? WebAuthenticationOptions(
                clientId: appleClientId,
                redirectUri: Uri.parse(appleRedirectUri),
              )
            : null,
      );

      return await _loginToBackend('apple', credential.identityToken!);
    } catch (e) {
      throw AuthException(message: 'Apple login failed: $e', provider: 'apple');
    }
  }

  @override
  Future<AuthResponse> signInWithLine() async {
    try {
      final result = await LineSDK.instance.login();
      final accessToken = result.accessToken.value;

      return await _loginToBackend('line', accessToken);
    } catch (e) {
      throw AuthException(message: 'Line login failed: $e', provider: 'line');
    }
  }

  Future<AuthResponse> _loginToBackend(String provider, String token) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/login',
        data: {
          'provider': provider,
          'token': token,
        },
      );

      return AuthResponse.fromJson(response.data);
    } catch (e) {
      throw AuthException(message: 'Backend login failed: $e', provider: provider);
    }
  }
}
