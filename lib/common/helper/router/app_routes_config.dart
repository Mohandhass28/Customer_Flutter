import 'package:customer/domain/auth/usecases/login_usecase.dart';
import 'package:customer/presentation/auth/login/bloc/login_bloc.dart';
import 'package:customer/presentation/auth/login/page/number_page.dart';
import 'package:customer/presentation/auth/verify_otp/bloc/verify_otp_bloc.dart';
import 'package:customer/presentation/auth/verify_otp/page/otp_page.dart';
import 'package:customer/presentation/profile/pages/address_book/page/address_book_map_page.dart';
import 'package:customer/presentation/profile/pages/address_book/page/address_book_page.dart';
import 'package:customer/presentation/profile/pages/address_book/page/save_address_page.dart';
import 'package:customer/presentation/profile/pages/profile.dart';
import 'package:customer/presentation/shop_details/page/shop_details.dart';
import 'package:customer/presentation/splash/page/splash_page.dart';
import 'package:customer/presentation/tabs/page/bottom_tabs_page.dart';
import 'package:customer/presentation/tabs/page/food/page/food_page.dart';
import 'package:customer/presentation/tabs/page/grocery/page/grocery_page.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/auth/send_otp_model/send_otp_model.dart';
import '../../../presentation/tabs/page/home/page/home_page.dart';

class AppRoutesConfig {
  // Create navigator keys for the root navigator and the shell navigator
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: '/',
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true, // Enable logging for debugging
    // Add redirect to handle initial navigation
    redirect: (BuildContext context, GoRouterState state) {
      // Allow the splash page to handle navigation
      return null; // Let the routes handle navigation
    },
    routes: [
      GoRoute(
        name: 'splash',
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => BlocProvider(
          create: (context) => LoginBloc(
            sendOTPUseCase: sl<SendOTPUseCase>(),
          ),
          child: const NumberPage(),
        ),
      ),
      GoRoute(
        name: 'otp',
        path: '/otp',
        builder: (context, state) {
          final number = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => VerifyOtpBloc(
              verifyOTPUseCase: sl<VerifyOTPUseCase>(),
            ),
            child: OtpPage(
              number: number['number'] as String,
              sendOTPModel: number['sendOTPModel'] as SendOTPModel,
            ),
          );
        },
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state, child) => BottomTabsPage(child: child),
        routes: [
          GoRoute(
            name: 'home',
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            name: 'grocery',
            path: '/grocery',
            builder: (context, state) => const GroceryPage(),
          ),
          GoRoute(
            name: 'food',
            path: '/food',
            builder: (context, state) => const FoodPage(),
          ),
        ],
      ),
      // Additional routes for other pages
      GoRoute(
        name: 'profile',
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        name: 'address-book',
        path: '/address-book',
        builder: (context, state) => const AddressBookPage(),
      ),
      GoRoute(
        name: 'home-address-book',
        path: '/home-address-book',
        builder: (context, state) => AddressBookPage(fromHome: true),
      ),
      GoRoute(
        name: 'address-book-map',
        path: '/address-book-map',
        builder: (context, state) => const AddressBookMapPage(),
      ),
      GoRoute(
        name: 'save-address',
        path: '/save-address',
        builder: (context, state) {
          final address = state.extra as Map<String, dynamic>;
          return SaveAddressPage(
              address: address['address'],
              latitude: address['latitude'],
              longitude: address['longitude']);
        },
      ),
      GoRoute(
        name: 'shop-details',
        path: '/shop-details',
        builder: (context, state) => const ShopDetails(),
      ),
    ],
  );
}
