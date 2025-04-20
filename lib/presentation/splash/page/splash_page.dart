import 'package:customer/common/helper/navigation/app_navigation.dart';
import 'package:customer/presentation/home/page/home_page.dart';
import 'package:customer/presentation/login/page/login_page.dart';
import 'package:customer/presentation/splash/bloc/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state.status == SplashStatus.success && state.isAuthenticated) {
            AppNavigation.pushReplacement(context, const HomePage());
          }
          if (state.status == SplashStatus.success && !state.isAuthenticated) {
            AppNavigation.pushReplacement(context, const LoginPage());
          }
        },
        builder: (context, state) {
          return Center(
            child: Text('Loading Page'),
          );
        },
      ),
    );
  }
}
