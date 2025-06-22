import 'dart:async';

import 'package:customer/common/widgets/bottom_Cart/bottom_cart.dart';
import 'package:customer/core/bloc/cart_list_bloc/bloc/cart_list_bloc.dart';
import 'package:customer/core/refresh_services/cart_refresh_service.dart';
import 'package:customer/core/refresh_services/cart_visibility_service.dart';
import 'package:customer/presentation/cart_details/widget/bill_summary/bloc/bill_summary_bloc.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomCartWithScroll extends StatefulWidget {
  const BottomCartWithScroll({super.key});

  @override
  State<BottomCartWithScroll> createState() => _BottomCartWithScrollState();
}

class _BottomCartWithScrollState extends State<BottomCartWithScroll>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _cartVisible = true;
  late StreamSubscription _hideCartSubscription;
  late StreamSubscription _showCartSubscription;
  void _showCart() {
    if (!_cartVisible) {
      _cartVisible = true;
      // Use animateTo instead of forward for more reliable animation
      _animationController.animateTo(1.0,
          duration: const Duration(milliseconds: 200));
    }
  }

  void _hideCart() {
    if (_cartVisible) {
      _cartVisible = false;
      // Use animateTo instead of reverse for more reliable animation
      _animationController.animateTo(0.0,
          duration: const Duration(milliseconds: 200));
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize animation controller with faster animation for better responsiveness
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    // Subscribe to cart visibility service
    _hideCartSubscription =
        sl<CartVisibilityService>().hideCartStream.listen((_) {
      if (_cartVisible == true) {
        setState(() {
          _hideCart();
        });
      }
    });

    _showCartSubscription =
        sl<CartVisibilityService>().showCartStream.listen((_) {
      if (_cartVisible == false) {
        setState(() {
          _showCart();
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<CartRefreshService>().refreshCart();
    });
  }

  // Extract cart summary widget to a separate method
  Widget _buildCartSummary(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Use a combination of size and slide transitions for smoother animation
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1), // Slide from bottom
            end: const Offset(0, 0), // To normal position
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          )),
          child: SizeTransition(
            sizeFactor: _animationController,
            axisAlignment: -1.0, // Bottom-aligned
            child: child,
          ),
        );
      },
      child: const BottomCart(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
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
          if (state.cartList != null && state.cartList!.cartData.isNotEmpty) {
            // Only set the value directly during initialization
            if (!_animationController.isAnimating) {
              _animationController.value = 1.0;
              _cartVisible = true;
            }
          } else {
            // Hide cart if it's empty
            if (!_animationController.isAnimating) {
              _animationController.value = 0.0;
              _cartVisible = false;
            }
          }
          return _buildCartSummary(context);
        },
      ),
    );
  }
}
