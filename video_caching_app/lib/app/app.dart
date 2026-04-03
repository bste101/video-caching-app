import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_caching_app/app/app_router.dart';
import 'package:video_caching_app/core/di/injection.dart';
import 'package:video_caching_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:video_caching_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:video_caching_app/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:video_caching_app/features/feed/presentation/bloc/feed_event.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<AuthBloc>()..add(const AuthEvent.authCheckRequested())),
        BlocProvider(create: (_) => locator<FeedBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Video Caching App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
