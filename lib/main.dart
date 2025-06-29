import 'package:customer/common/helper/router/app_routes_config.dart';
import 'package:customer/core/config/theme/app_theme.dart';
import 'package:customer/domain/auth/usecases/auth_check_usecase.dart';
import 'package:customer/presentation/splash/bloc/splash_bloc.dart';
import 'package:customer/service_locator.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

late SharedPreferences sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hide status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);

  await dotenv.load(fileName: ".env");
  sharedPref = await SharedPreferences.getInstance();
  setupServiceLocator();
  runApp(DevicePreview(
    builder: (context) {
      return const MyApp();
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SplashBloc(
            authCheckUseCase: sl<AuthCheckUseCase>(),
          ),
        )
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRoutesConfig.router,
        builder: (context, child) {
          if (child == null) return const SizedBox.shrink();
          return child;
        },
      ),
    );
  }
}
