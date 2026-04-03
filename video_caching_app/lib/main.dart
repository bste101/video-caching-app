import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/observers/app_bloc_observer.dart';
import 'core/di/injection.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await dotenv.load(fileName: ".env");

  final lineChannelId = dotenv.get('LINE_CHANNEL_ID' , fallback: '');
  if (lineChannelId.isNotEmpty) {
    await LineSDK.instance.setup(lineChannelId);
  }

  await setupLocator();

  Bloc.observer = const AppBlocObserver();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, 
    ),
  );

  runApp(const App());
}
