import 'package:customer/core/config/theme/app_theme.dart';
import 'package:customer/domain/auth/usecases/auth_check_usecase.dart';
import 'package:customer/presentation/splash/bloc/splash_bloc.dart';
import 'package:customer/presentation/splash/page/splash_page.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  sharedPref = await SharedPreferences.getInstance();
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(
        authCheckUseCase: sl<AuthCheckUseCase>(),
      )..add(AppStartEvent()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
      ),
    );
  }
}
