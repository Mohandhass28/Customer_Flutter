import 'package:customer/core/bloc/cart_list_bloc/bloc/cart_list_bloc.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/domain/cart/usecases/cart_list_usecase.dart';
import 'package:customer/presentation/tabs/page/grocery/page/grocery_page.dart';
import 'package:customer/presentation/tabs/page/home/page/home_page.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'food/page/food_page.dart';

class BottomTabsPage extends StatefulWidget {
  final Widget child;
  const BottomTabsPage({super.key, required this.child});

  @override
  State<BottomTabsPage> createState() => _BottomTabsPageState();
}

class _BottomTabsPageState extends State<BottomTabsPage> {
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    // Determine the current index based on the location
    final location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    print('Current location: $location');

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
          BlocProvider<CartListBloc>(
            create: (context) => sl<CartListBloc>()
              ..add(
                GetCartListEvent(),
              ),
          ),
        ],
        child: BlocBuilder<CartListBloc, CartListState>(
          builder: (context, state) {
            if (state.status == CartListStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SafeArea(
              child: Column(
                children: [
                  Expanded(child: widget.child),
                  if (state.cartList != null &&
                      state.cartList!.cartData.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        context.push('/cart');
                      },
                      child: Container(
                        width: double
                            .infinity, // Important: Provides width constraint
                        height: 90, // Fixed height instead of constraints
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.2, 1],
                            colors: const [
                              Color(0xFF016735),
                              Color(0xFF539472),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 34, // Fixed height
                              width: 34, // Fixed width
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Icons.shopping_cart,
                                size: 20,
                                color: AppColor.primaryColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Add items to worth ₹100",
                                style: TextStyle(
                                  color: AppColor.richTextColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Use GoRouter's path-based navigation
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
        },
        items: const <BottomNavigationBarItem>[
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
        ],
      ),
    );
  }
}
