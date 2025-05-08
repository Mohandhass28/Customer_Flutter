import 'package:customer/domain/auth/usecases/login_usecase.dart';
import 'package:customer/presentation/active_order/page/active_order_page.dart';
import 'package:customer/presentation/auth/login/bloc/login_bloc.dart';
import 'package:customer/presentation/auth/login/page/number_page.dart';
import 'package:customer/presentation/auth/verify_otp/bloc/verify_otp_bloc.dart';
import 'package:customer/presentation/auth/verify_otp/page/otp_page.dart';
import 'package:customer/presentation/billing/page/blling_page.dart';
import 'package:customer/presentation/billing/page/coupons/coupons_page.dart';
import 'package:customer/presentation/cart_details/page/cart_page.dart';
import 'package:customer/presentation/orders_details/page/info_page.dart';
import 'package:customer/presentation/orders_details/page/order_details_page.dart';
import 'package:customer/presentation/profile/pages/about/page/about_page.dart';
import 'package:customer/presentation/profile/pages/account_details/page/account_datails.dart';
import 'package:customer/presentation/profile/pages/address_book/page/address_book_map_page.dart';
import 'package:customer/presentation/profile/pages/address_book/page/address_book_page.dart';
import 'package:customer/presentation/profile/pages/address_book/page/save_address_page.dart';
import 'package:customer/presentation/profile/pages/help/page/help_page.dart';
import 'package:customer/presentation/profile/pages/notification/page/notifications_page.dart';
import 'package:customer/presentation/profile/pages/past_orders/page/past_orders_page.dart';
import 'package:customer/presentation/profile/pages/profile.dart';
import 'package:customer/presentation/profile/pages/user_details/user_details_page.dart';
import 'package:customer/presentation/profile/pages/wallet/page/add_money_page/add_money_page.dart';
import 'package:customer/presentation/profile/pages/wallet/page/add_money_page/payment_mode_page.dart';
import 'package:customer/presentation/profile/pages/wallet/page/wallet_page.dart';
import 'package:customer/presentation/profile/pages/wallet/page/withdraw_page/withdraw_page.dart';
import 'package:customer/presentation/profile/pages/wallet/page/withdraw_page/withdraw_payment_mode_page.dart';
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
import '../../../main.dart';
import '../../../presentation/tabs/page/home/page/home_page.dart';

class AppRoutesConfig {
  // Create navigator keys for the root navigator and the shell navigator
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  // List of paths that don't require authentication
  static final List<String> _publicPaths = [
    '/',
    '/login',
    '/otp',
  ];

  static final router = GoRouter(
    initialLocation: '/',
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true, // Enable logging for debugging
    // Add redirect to handle initial navigation and authentication
    redirect: (context, state) {
      // Check if the current path is public (doesn't require auth)
      final isPublicPath = _publicPaths.contains(state.matchedLocation);

      // If it's the splash page, let it handle its own navigation
      if (state.matchedLocation == '/') {
        return null;
      }

      // Get token and number from shared preferences directly
      final token = sharedPref.getString('token');
      final number = sharedPref.getString('number');
      // User is authenticated only if both token and number exist
      final isAuthenticated = token != null &&
          token.isNotEmpty &&
          number != null &&
          number.isNotEmpty;

      // If user is not authenticated and trying to access a protected route,
      // redirect to login
      if (!isAuthenticated && !isPublicPath) {
        return '/login';
      }

      // If user is authenticated and trying to access login or otp,
      // redirect to home
      if (isAuthenticated &&
          (state.matchedLocation == '/login' ||
              state.matchedLocation == '/otp')) {
        return '/home';
      }

      // No redirect needed
      return null;
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
        builder: (context, state) {
          final shopId = state.extra as Map<String, dynamic>;
          return ShopDetails(
            shopId: shopId['shopId'],
          );
        },
      ),
      GoRoute(
        name: 'cart',
        path: '/cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        name: 'user-details',
        path: '/user-details',
        builder: (context, state) => const UserDetailsPage(),
      ),
      GoRoute(
        name: 'notifications',
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        name: 'past-orders',
        path: '/past-orders',
        builder: (context, state) => const PastOrdersPage(),
      ),
      GoRoute(
        name: 'help',
        path: '/help',
        builder: (context, state) => const HelpPage(),
      ),
      GoRoute(
        name: 'wallet',
        path: '/wallet',
        builder: (context, state) => const WalletPage(),
      ),
      GoRoute(
        name: 'address-details',
        path: '/address-details',
        builder: (context, state) => const AccountDatails(),
      ),
      GoRoute(
        name: 'about',
        path: '/about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        name: 'billing',
        path: '/billing',
        builder: (context, state) => const BllingPage(),
      ),
      GoRoute(
        name: 'order-details',
        path: '/order-details',
        builder: (context, state) => const OrderDetailsPage(),
      ),
      GoRoute(
        name: 'info',
        path: '/info',
        builder: (context, state) => const InfoPage(),
      ),
      GoRoute(
        name: 'active-order',
        path: '/active-order',
        builder: (context, state) => const ActiveOrderPage(),
      ),
      GoRoute(
        name: 'coupons',
        path: '/coupons',
        builder: (context, state) => const CouponsPage(),
      ),
      GoRoute(
        name: 'add-money',
        path: '/add-money',
        builder: (context, state) => const AddMoneyPage(),
      ),
      GoRoute(
        name: 'withdraw-money',
        path: '/withdraw-money',
        builder: (context, state) => const WithdrawPage(),
      ),
      GoRoute(
        name: 'add-money-payment-mode',
        path: '/add-money-payment-mode',
        builder: (context, state) => const PaymentModePage(),
      ),
      GoRoute(
        name: 'withdraw-money-payment-mode',
        path: '/withdraw-money-payment-mode',
        builder: (context, state) => const WithdrawPaymentModePage(),
      ),
    ],
  );
}
