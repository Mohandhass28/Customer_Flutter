import 'package:customer/common/models/cart/variant_add_cart.dart';
import 'package:customer/common/models/index.dart';
import 'package:customer/core/bloc/cart_list_bloc/bloc/cart_list_bloc.dart';
import 'package:customer/core/config/assets/app_images.dart';
import 'package:customer/data/models/product/product_details/index.dart';
import 'package:customer/domain/cart/usecases/cart_list_usecase.dart';
import 'package:customer/presentation/shop_details/page/product_details/bloc/product_details/product_details_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Add_Controller/add_controller.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Option/bloc/option_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Option_Controller/option_Controller.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OptionsWidget extends StatefulWidget {
  const OptionsWidget({
    super.key,
    required this.option,
    required this.productId,
  });
  final ProductOptionModel option;
  final int productId;

  @override
  State<OptionsWidget> createState() => _OptionsWidgetState();
}

class _OptionsWidgetState extends State<OptionsWidget> {
  late CartListBloc _cartListBloc;
  late int quantity;

  @override
  void initState() {
    super.initState();
    _cartListBloc = CartListBloc(
      cartListUsecase: sl<CartListUsecase>(),
    );

    // Safely get the quantity with null checks and error handling
    quantity = 0; // Default value

    try {
      if (_cartListBloc.state.cartList != null &&
          _cartListBloc.state.cartList!.cartData.isNotEmpty) {
        // Find products matching the product ID
        final matchingProducts = _cartListBloc.state.cartList!.cartData
            .where((element) => element.productDetails.id == widget.productId)
            .toList();

        if (matchingProducts.isNotEmpty) {
          // Find options matching the option ID
          final matchingOptions = matchingProducts.first.productOptions
              .where((element) => element.id == widget.option.id)
              .toList();

          if (matchingOptions.isNotEmpty) {
            quantity = matchingOptions.first.quantity;
          }
        }
      }
    } catch (e) {
      // Keep default quantity of 0
      // Consider implementing proper logging here
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OptionBloc, OptionState>(
      builder: (context, state) {
        // Get option from state if available, otherwise use default
        state.optionList.firstWhere(
          (element) => element.id == widget.option.id,
          orElse: () =>
              OptionAddCartModel(id: widget.option.id, quantity: quantity),
        );
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      widget.option.image,
                      fit: BoxFit.contain,
                      height: 60,
                      width: 60,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppImages.Seller_logo,
                          height: 60,
                          width: 60,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.option.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.option.unit,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                widget.option.price,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 80, // Increased width to prevent overflow
                child: OptionController(
                  productId: widget.productId,
                  constraints: BoxConstraints(
                    maxHeight: 30,
                    maxWidth: 80, // Increased width
                  ),
                  optionId: widget.option.id,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
