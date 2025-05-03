import 'package:customer/core/bloc/cart_list_bloc/bloc/cart_list_bloc.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/core/refresh_services/cart_refresh_service.dart';
import 'package:customer/domain/cart/usecases/cart_list_usecase.dart';
import 'package:customer/presentation/cart_details/widget/bill_summary/bloc/bill_summary_bloc.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<CartRefreshService>().refreshCart();
    });
  }

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
          BlocProvider.value(
            value: sl<CartListBloc>(),
          ),
          BlocProvider.value(
            value: sl<BillSummaryBloc>()
              ..add(
                GetBillSummaryEvent(),
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
                        width: double.infinity,
                        height: 50,
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
                            BlocBuilder<BillSummaryBloc, BillSummaryState>(
                              builder: (context, bstate) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "₹${bstate.cartDetails?.cartDetails.finalAmount ?? 0}",
                                    style: TextStyle(
                                      color: AppColor.textColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      context.push('/active-order');
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40,
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Active Order",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
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
          onTap: (index) {
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
      ),
    );
  }
}
