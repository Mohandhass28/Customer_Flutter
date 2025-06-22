import 'package:customer/common/models/cart/option_add_cart.dart';
import 'package:customer/common/models/cart/variant_add_cart.dart';
import 'package:customer/core/bloc/cart_list_bloc/bloc/cart_list_bloc.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/data/models/cart/cart_list/cart_data_model.dart';
import 'package:customer/domain/cart/entities/add_to_cart/add_to_cart_params.dart';
import 'package:customer/domain/cart/entities/cart_list/cart_product_option_entity.dart';
import 'package:customer/domain/cart/entities/cart_list/cart_product_variant_entity.dart';
import 'package:customer/domain/cart/usecases/add_to_cart_usecase.dart';
import 'package:customer/domain/cart/usecases/modify_cart_usecase.dart';
import 'package:customer/presentation/cart_details/bloc/cart_details_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Add_Controller/add_controller.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OptionController extends StatefulWidget {
  final int productId;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final int optionId;

  const OptionController({
    super.key,
    required this.productId,
    this.padding,
    required this.constraints,
    required this.optionId,
  });

  @override
  State<OptionController> createState() => _OptionControllerState();
}

class _OptionControllerState extends State<OptionController> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: sl<CartListBloc>(),
        ),
        BlocProvider.value(
          value: CartDetailsBloc(
            modifyCartUsecase: sl<ModifyCartUsecase>(),
          ),
        ),
      ],
      child: BlocConsumer<CartListBloc, CartListState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<CartListBloc, CartListState>(
            builder: (context, state) {
              // Check if cartList is null or empty
              if (state.cartList == null || state.cartList!.cartData.isEmpty) {
                return _addToCartButton(0);
              }

              // Try to find the product in the cart
              final productInCart = state.cartList!.cartData
                  .where((element) =>
                      element.productDetails.id == widget.productId)
                  .toList();

              // If product is not in cart, return add button
              if (productInCart.isEmpty) {
                return _addToCartButton(0);
              }

              final productQuantity = productInCart.first.quantity;

              // Check if the product has the specific option
              if (productInCart.first.productOptions
                  .any((element) => element.id == widget.optionId)) {
                return _modifyCartButton(productInCart.first as CartDataModel);
              } else {
                return _addToCartButton((productQuantity) ?? 0);
              }
            },
          );
        },
      ),
    );
  }

  Widget _addToCartButton(int productQuantity) {
    return BlocProvider(
      create: (context) =>
          AddToCartBloc(addToCartUsecase: sl<AddToCartUsecase>()),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          splashColor:
              Colors.white.withAlpha(76), // 0.3 opacity converted to alpha
          highlightColor:
              Colors.white.withAlpha(25), // 0.1 opacity converted to alpha
          onTap: () {
            context.read<AddToCartBloc>().add(
                  AddItemToCartEvent(
                    params: AddToCartParams(
                      productId: widget.productId,
                      quantity: productQuantity,
                      variantAddCartModel: [],
                      optionAddCartModel: [
                        OptionAddCartModel(
                          id: widget.optionId,
                          quantity: 1,
                        ),
                      ],
                    ),
                  ),
                );
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColor.primaryColor,
            ),
            child: Container(
              constraints: widget.constraints,
              padding: widget.padding,
              child: Center(
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _modifyCartButton(CartDataModel productList) {
    return Material(
      child: BlocBuilder<CartListBloc, CartListState>(
        builder: (context, state) {
          return AddController(
            borderRadius: BorderRadius.circular(8),
            constraints: widget.constraints,
            decrementOnPress: () {
              context.read<CartDetailsBloc>().add(
                    ModifyCartEvent(
                      params: AddToCartParams(
                        productId: productList.productDetails.id,
                        variantAddCartModel: _convertToVariantAddCartModel(
                            productList.productVariant),
                        optionAddCartModel: _convertToOptionAddCartModel(
                          productList.productOptions,
                        )
                            .map(
                              (option) => option.id == widget.optionId
                                  ? option.copyWith(
                                      quantity: option.quantity - 1)
                                  : option,
                            )
                            .toList(),
                        quantity: ((state.cartList!.cartData
                                .firstWhere((element) =>
                                    element.productDetails.id ==
                                    productList.productDetails.id)
                                .quantity) ??
                            0),
                      ),
                    ),
                  );
            },
            incrementOnPress: () {
              context.read<CartDetailsBloc>().add(
                    ModifyCartEvent(
                      params: AddToCartParams(
                        productId: productList.productDetails.id,
                        variantAddCartModel: _convertToVariantAddCartModel(
                            productList.productVariant),
                        optionAddCartModel: _convertToOptionAddCartModel(
                          productList.productOptions,
                        )
                            .map(
                              (option) => option.id == widget.optionId
                                  ? option.copyWith(
                                      quantity: option.quantity + 1)
                                  : option,
                            )
                            .toList(),
                        quantity: ((state.cartList!.cartData
                                .firstWhere((element) =>
                                    element.productDetails.id ==
                                    productList.productDetails.id)
                                .quantity) ??
                            0),
                      ),
                    ),
                  );
            },
            id: 0,
            quantity: productList.productOptions
                .firstWhere((element) => element.id == widget.optionId)
                .quantity,
          );
        },
      ),
    );
  }

  List<VariantAddCartModel> _convertToVariantAddCartModel(
      List<CartProductVariantEntity> productVariants) {
    return productVariants
        .map((variant) => VariantAddCartModel(
              id: variant.id,
              quantity: variant.quantity,
            ))
        .toList();
  }

  // Convert CartProductOptionEntity list to OptionAddCartModel list
  List<OptionAddCartModel> _convertToOptionAddCartModel(
      List<CartProductOptionEntity> productOptions) {
    return productOptions
        .map((option) => OptionAddCartModel(
              id: option.id,
              quantity: option.quantity,
            ))
        .toList();
  }
}
