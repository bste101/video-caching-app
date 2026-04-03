import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_caching_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:video_caching_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:video_caching_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:video_caching_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:video_caching_app/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:video_caching_app/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final googleServerClientId = dotenv.get('GOOGLE_SERVER_CLIENT_ID', fallback: '');

  final googleSignIn = GoogleSignIn.instance;
  if (googleServerClientId.isNotEmpty) {
    await googleSignIn.initialize(serverClientId: googleServerClientId);
  } else {
    await googleSignIn.initialize();
  }

  // External
  locator.registerLazySingleton<GetStorage>(() => GetStorage());
  locator.registerSingletonAsync<GoogleSignIn>(() async => googleSignIn);
  locator.registerLazySingleton<Dio>(() => Dio());

  // Data Sources
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(googleSignIn: locator(), dio: locator()),
  );
  locator.registerLazySingleton<FeedRemoteDataSource>(
    () => FeedRemoteDataSourceImpl(locator()),
  );

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: locator(), storage: locator()),
  );

  // BLoCs
  locator.registerFactory(() => AuthBloc(locator()));
  locator.registerFactory(() => FeedBloc(locator()));
}
