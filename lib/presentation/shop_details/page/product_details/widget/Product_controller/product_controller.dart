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

class ProductController extends StatefulWidget {
  const ProductController({
    super.key,
    required this.padding,
    required this.constraints,
    required this.productId,
    required this.btnText,
    this.borderRadius,
  });
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final int productId;
  final String btnText;
  final BorderRadius? borderRadius;

  @override
  State<ProductController> createState() => _ProductControllerState();
}

class _ProductControllerState extends State<ProductController> {
  late CartDetailsBloc _cartDetailsBloc;

  @override
  void initState() {
    super.initState();
    _cartDetailsBloc = CartDetailsBloc(
      modifyCartUsecase: sl<ModifyCartUsecase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: _cartDetailsBloc,
        ),
        BlocProvider.value(
          value: sl<CartListBloc>(),
        ),
      ],
      child: Container(
        child: BlocBuilder<CartListBloc, CartListState>(
          builder: (context, state) {
            // Check if cartList is null or empty
            if (state.cartList == null || state.cartList!.cartData.isEmpty) {
              return _addToCartButton();
            } else if (state.cartList!.cartData
                .map((element) => element.productDetails.id)
                .contains(widget.productId)) {
              final cartItem = state.cartList!.cartData.firstWhere(
                (element) => element.productDetails.id == widget.productId,
              );
              return _modifyCartButton(cartItem as CartDataModel);
            } else {
              return _addToCartButton();
            }
          },
        ),
      ),
    );
  }

  Widget _addToCartButton() {
    return BlocProvider(
      create: (context) =>
          AddToCartBloc(addToCartUsecase: sl<AddToCartUsecase>()),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: widget.borderRadius,
          splashColor:
              Colors.white.withAlpha(76), // 0.3 opacity converted to alpha
          highlightColor:
              Colors.white.withAlpha(25), // 0.1 opacity converted to alpha
          onTap: () {
            context.read<AddToCartBloc>().add(
                  AddItemToCartEvent(
                    params: AddToCartParams(
                      productId: widget.productId,
                      quantity: 1,
                      variantAddCartModel: [],
                      optionAddCartModel: [],
                    ),
                  ),
                );
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              color: AppColor.primaryColor,
            ),
            child: Container(
              constraints: widget.constraints,
              padding: widget.padding,
              child: Center(
                child: Text(
                  widget.btnText,
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
            borderRadius: widget.borderRadius,
            constraints: widget.constraints,
            decrementOnPress: () {
              _cartDetailsBloc.add(
                ModifyCartEvent(
                  params: AddToCartParams(
                    productId: productList.productDetails.id,
                    variantAddCartModel: _convertToVariantAddCartModel(
                        productList.productVariant),
                    optionAddCartModel: _convertToOptionAddCartModel(
                      productList.productOptions,
                    ),
                    quantity: (state.cartList!.cartData
                            .firstWhere((element) =>
                                element.productDetails.id ==
                                productList.productDetails.id)
                            .quantity) -
                        1,
                  ),
                ),
              );
            },
            incrementOnPress: () {
              _cartDetailsBloc.add(
                ModifyCartEvent(
                  params: AddToCartParams(
                    productId: productList.productDetails.id,
                    variantAddCartModel: _convertToVariantAddCartModel(
                        productList.productVariant),
                    optionAddCartModel: _convertToOptionAddCartModel(
                      productList.productOptions,
                    ),
                    quantity: (state.cartList!.cartData
                            .firstWhere((element) =>
                                element.productDetails.id ==
                                productList.productDetails.id)
                            .quantity) +
                        1,
                  ),
                ),
              );
            },
            id: 0,
            quantity: state.cartList!.cartData
                .firstWhere((element) =>
                    element.productDetails.id == productList.productDetails.id)
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
