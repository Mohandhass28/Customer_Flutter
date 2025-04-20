import 'package:customer/presentation/splash/page/splash_page.dart';
import 'package:go_router/go_router.dart';

class AppRoutesConfig {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => SplashPage(),
      ),
      // GoRoute(
      //   path: '/login',
      //   builder: (context, state) => LoginPage(),
      // ),
      // GoRoute(
      //   path: '/register',
      //   builder: (context, state) => RegisterPage(),
      // ),
      // GoRoute(
      //   path: '/home',
      //   builder: (context, state) => HomePage(),
      // ),
    ],
  );
}
