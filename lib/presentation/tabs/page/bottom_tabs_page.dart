import 'package:customer/presentation/tabs/page/grocery/page/grocery_page.dart';
import 'package:customer/presentation/tabs/page/home/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'food/page/food_page.dart';

class BottomTabsPage extends StatefulWidget {
  final Widget child;
  const BottomTabsPage({super.key, required this.child});

  @override
  State<BottomTabsPage> createState() => _BottomTabsPageState();
}

class _BottomTabsPageState extends State<BottomTabsPage> {
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

    // Debug information about current location and index
    // print('Current location: $location, Current index: $currentIndex');

    return Scaffold(
      body: widget.child,
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
