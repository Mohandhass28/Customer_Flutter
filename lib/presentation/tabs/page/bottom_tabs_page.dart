import 'package:customer/core/bloc/cart_list_bloc/bloc/cart_list_bloc.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/core/refresh_services/cart_refresh_service.dart';
import 'package:customer/presentation/cart_details/widget/bill_summary/bloc/bill_summary_bloc.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BottomTabsPage extends StatefulWidget {
  final Widget child;
  const BottomTabsPage({super.key, required this.child});

  @override
  State<BottomTabsPage> createState() => _BottomTabsPageState();
}

class _BottomTabsPageState extends State<BottomTabsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<CartRefreshService>().refreshCart();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Memoize the navigation items to avoid rebuilding them
  final List<BottomNavigationBarItem> _navigationItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.local_grocery_store),
      label: 'Grocery',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.food_bank),
      label: 'Food',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Determine the current index based on the location
    final location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;

    if (location == '/home') {
      currentIndex = 0;
    } else if (location == '/grocery') {
      currentIndex = 1;
    } else if (location == '/food') {
      currentIndex = 2;
    }

    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: sl<CartListBloc>(),
          ),
          BlocProvider.value(
            value: sl<BillSummaryBloc>()..add(GetBillSummaryEvent()),
          ),
        ],
        child: BlocBuilder<CartListBloc, CartListState>(
          builder: (context, state) {
            return SafeArea(
              child: widget.child,
            );
          },
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedLabelStyle: TextStyle(fontSize: 12),
            unselectedLabelStyle: TextStyle(fontSize: 12),
          ),
        ),
        child: BottomNavigationBar(
          selectedItemColor: AppColor.primaryColor,
          currentIndex: currentIndex,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 4,
          onTap: _onNavigationTap,
          items: _navigationItems,
        ),
      ),
    );
  }

  // Extract navigation tap handler to a separate method
  void _onNavigationTap(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/grocery');
        break;
      case 2:
        context.go('/food');
        break;
    }
  }
}
