import 'package:customer/common/models/cart/option_add_cart.dart';
import 'package:customer/common/models/cart/variant_add_cart.dart';
import 'package:customer/common/widgets/expandable_text.dart';
import 'package:customer/core/bloc/cart_list_bloc/bloc/cart_list_bloc.dart';
import 'package:customer/core/config/assets/app_images.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/core/refresh_services/bill_summary_refresh_service.dart';
import 'package:customer/core/refresh_services/cart_refresh_service.dart';
import 'package:customer/core/refresh_services/cart_visibility_service.dart';
import 'package:customer/data/models/product/product_details/index.dart';
import 'package:customer/domain/cart/entities/add_to_cart/add_to_cart_params.dart';
import 'package:customer/domain/cart/usecases/add_to_cart_usecase.dart';
import 'package:customer/domain/cart/usecases/modify_cart_usecase.dart';
import 'package:customer/domain/product/entities/product_details_params.dart';
import 'package:customer/domain/product/usecases/product_details_usecase.dart';
import 'package:customer/presentation/cart_details/bloc/cart_details_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/bloc/product_details/product_details_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Add_Controller/add_controller.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Option/bloc/option_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Option/options_widget.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Product_controller/product_controller.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Variant/bloc/variant_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Variant/variant_widget.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class _ProductDetailsPopup extends StatefulWidget {
  const _ProductDetailsPopup();

  @override
  State<_ProductDetailsPopup> createState() => ProductDetails();
}

class ProductDetails extends State<_ProductDetailsPopup> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  void showAddToCartBottomSheet(
    BuildContext context, {
    required int productId,
  }) {
    final VariantBloc variantBloc = VariantBloc();
    final OptionBloc optionBloc = OptionBloc();
    final ProductDetailsBloc productDetailsBloc = ProductDetailsBloc(
      productDetailsUsecase: sl<ProductDetailsUsecase>(),
    );
    final AddToCartBloc addToCartBloc = AddToCartBloc(
      addToCartUsecase: sl<AddToCartUsecase>(),
    );
    final CartDetailsBloc cartDetailsBloc = CartDetailsBloc(
      modifyCartUsecase: sl<ModifyCartUsecase>(),
    );

    final CartListBloc cartListBloc = sl<CartListBloc>();

    int quantity = 0;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true, // Make it expandable
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        // Add a dispose callback when the bottom sheet is closed
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!Navigator.of(context).canPop()) {
            // This ensures the bloc is closed if the bottom sheet is dismissed by tapping outside
            Future.delayed(Duration.zero, () {
              if (!context.mounted) cartDetailsBloc.close();
            });
          }
        });
        return DraggableScrollableSheet(
          initialChildSize: 0.7, // Initial height (70% of screen)
          minChildSize: 0.5, // Minimum height (50% of screen)
          maxChildSize: 0.95, // Maximum height (95% of screen)
          expand: false,
          builder: (context, scrollController) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: productDetailsBloc
                    ..add(
                      GetProductDetailsEvent(
                        params: ProductDetailsParams(
                          productId: productId,
                        ),
                      ),
                    ),
                ),
                BlocProvider.value(
                  value: variantBloc,
                ),
                BlocProvider.value(
                  value: optionBloc,
                ),
                BlocProvider.value(
                  value: addToCartBloc,
                ),
                BlocProvider.value(
                  value: cartDetailsBloc,
                ),
                BlocProvider.value(
                  value: cartListBloc,
                ),
              ],
              child: MultiBlocListener(
                listeners: [
                  BlocListener<ProductDetailsBloc, ProductDetailsState>(
                    listener: (context, state) {
                      if (state.status == ProductDetailsStatus.success) {
                        state.productDetails?.productData.productVariants
                            .forEach(
                          (variant) {
                            variantBloc.add(
                              AddVariantEvent(
                                variantAddCartModel: VariantAddCartModel(
                                  id: variant.id,
                                  quantity: quentityForVariant(variant),
                                ),
                              ),
                            );
                          },
                        );
                        state.productDetails?.productData.productOptions
                            .forEach(
                          (option) {
                            optionBloc.add(
                              AddOptionEvent(
                                optionAddCartModel: OptionAddCartModel(
                                  id: option.id,
                                  quantity:
                                      quentityForOption(option, productId),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                  BlocListener<CartListBloc, CartListState>(
                    listener: (context, state) {},
                  ),
                  BlocListener<AddToCartBloc, AddToCartState>(
                    listener: (context, state) {
                      if (state.status == AddToCartStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.addToCartResponse?.msg ?? 'Unknown error',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        sl<CartRefreshService>().refreshCart();
                        sl<BillSummaryRefreshService>().refreshBillSummary();

                        cartDetailsBloc.close();
                        return;
                      }
                      if (state.status == AddToCartStatus.failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.errorMessage ?? 'Unknown error',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        cartDetailsBloc.close();
                        return;
                      }

                      cartDetailsBloc.close();
                    },
                  ),
                ],
                child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                  builder: (context, state) {
                    if (state.status == ProductDetailsStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state.status == ProductDetailsStatus.failure) {
                      return Center(
                        child: Text(state.errorMessage ?? "Unknown error"),
                      );
                    }
                    if (state.productDetails == null) {
                      return const Center(
                        child: Text("No product details found"),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            controller: scrollController,
                            children: [
                              // Drag handle
                              const SizedBox(height: 10),
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              // Product header
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      constraints: const BoxConstraints(
                                        maxHeight: 60,
                                        maxWidth: 60,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.network(
                                        state.productDetails?.productData
                                                .productDetails.image ??
                                            "",
                                        fit: BoxFit.contain,
                                        height: 60,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            AppImages.Seller_logo,
                                            fit: BoxFit.contain,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        state.productDetails?.productData
                                                .productDetails.name ??
                                            "",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Price
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      "${state.productDetails?.productData.productDetails.unit ?? ""}${(double.tryParse(state.productDetails?.productData.productDetails.price ?? "0") ?? 0).toInt()}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    constraints: const BoxConstraints(
                                      maxWidth: 55,
                                      minHeight: 25,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      ),
                                      color: AppColor.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          size: 20,
                                        ),
                                        Text(
                                          "${state.productDetails?.productData.avgRating}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    " (${state.productDetails?.productData.totalCount})",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "₹ ${state.productDetails?.productData.productDetails.price ?? ""}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const Divider(height: 32),
                              // Variants section
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Quantity",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: const [
                                        Text(
                                          "Required",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                    const Text("Select any 1 option"),
                                    const SizedBox(height: 16),
                                    BlocBuilder<CartListBloc, CartListState>(
                                      builder: (context, cartListState) {
                                        if (cartListState.status ==
                                            CartListStatus.loading) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        if (cartListState.status ==
                                            CartListStatus.failure) {
                                          return Center(
                                            child: Text(
                                              cartListState.errorMessage ??
                                                  "Unknown error",
                                            ),
                                          );
                                        }

                                        // Check if the product exists in the cart
                                        final bool productExists =
                                            cartListState.cartList != null &&
                                                cartListState.cartList!.cartData
                                                    .any(
                                                  (element) =>
                                                      element
                                                          .productDetails.id ==
                                                      productId,
                                                );

                                        // Get product if it exists, otherwise use 0 values
                                        final int productIdFromCart =
                                            productExists &&
                                                    cartListState.cartList !=
                                                        null
                                                ? cartListState
                                                    .cartList!.cartData
                                                    .where(
                                                      (element) =>
                                                          element.productDetails
                                                              .id ==
                                                          productId,
                                                    )
                                                    .first
                                                    .productDetails
                                                    .id
                                                : 0;
                                        quantity = productExists &&
                                                cartListState.cartList != null
                                            ? cartListState.cartList!.cartData
                                                .where(
                                                  (element) =>
                                                      element
                                                          .productDetails.id ==
                                                      productId,
                                                )
                                                .first
                                                .quantity
                                            : 0;
                                        return StatefulBuilder(
                                          builder: (context, setStates) {
                                            return Row(
                                              children: [
                                                // Product image and details
                                                Expanded(
                                                  flex: 3,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 60,
                                                        height: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Image.network(
                                                          productDetailsBloc
                                                                  .state
                                                                  .productDetails
                                                                  ?.productData
                                                                  .productDetails
                                                                  .image ??
                                                              "",
                                                          fit: BoxFit.contain,
                                                          height: 60,
                                                          width: 60,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Image.asset(
                                                              AppImages
                                                                  .Seller_logo,
                                                              height: 60,
                                                              width: 60,
                                                              fit: BoxFit
                                                                  .contain,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              productDetailsBloc
                                                                      .state
                                                                      .productDetails
                                                                      ?.productData
                                                                      .productDetails
                                                                      .name ??
                                                                  "",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              productDetailsBloc
                                                                      .state
                                                                      .productDetails
                                                                      ?.productData
                                                                      .productDetails
                                                                      .unit ??
                                                                  "",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Price
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    "₹${productDetailsBloc.state.productDetails?.productData.productDetails.price ?? ""}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                // Add button
                                                ProductController(
                                                  btnText: "Add",
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                  constraints: BoxConstraints(
                                                    maxHeight: 30,
                                                    maxWidth: 90,
                                                  ),
                                                  productId: productId,
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    ...state.productDetails!.productData
                                        .productVariants
                                        .map(
                                      (e) => BlocProvider.value(
                                        value: variantBloc,
                                        child: VariantWidget(
                                          variant: e as ProductVariantModel,
                                          quantity: quentityForVariant(e),
                                          actualProductId: e.actual_product_id,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ...state.productDetails!.productData
                                        .productOptions
                                        .map(
                                      (e) => BlocProvider.value(
                                        value: optionBloc,
                                        child: OptionsWidget(
                                          productId: productId,
                                          option: e
                                              as ProductOptionModel, // Changed from ProductVariantModel
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedBottomBtn(productId: productId),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  get quentityForVariant => (ProductVariantModel variant) {
        final cartListBloc = sl<CartListBloc>();
        if (cartListBloc.state.cartList != null &&
            cartListBloc.state.cartList!.cartData.isNotEmpty) {
          try {
            // Check if the product exists in the cart
            final bool productExists =
                cartListBloc.state.cartList!.cartData.any(
              (element) =>
                  element.productDetails.id == variant.actual_product_id,
            );

            if (!productExists) {
              return 0;
            }

            final cartItem = cartListBloc.state.cartList!.cartData
                .where((element) =>
                    element.productDetails.id == variant.actual_product_id)
                .first;
            if (cartItem.productVariant.isEmpty) {
              return 0;
            }
            return cartItem.quantity;
          } catch (e) {
            return 0;
          }
        }
        return 0;
      };
  get quentityForOption => (ProductOptionModel option, int productId) {
        final cartListBloc = sl<CartListBloc>();
        if (cartListBloc.state.cartList != null &&
            cartListBloc.state.cartList!.cartData.isNotEmpty) {
          try {
            // Check if the product exists in the cart
            final bool productExists =
                cartListBloc.state.cartList!.cartData.any(
              (element) => element.productDetails.id == productId,
            );

            if (!productExists) {
              return 0;
            }

            final cartItem = cartListBloc.state.cartList!.cartData
                .where((element) => element.productDetails.id == productId)
                .first;

            // Check if the option exists in the product's variants
            final bool optionExists = cartItem.productVariant.any(
              (element) => element.id == option.id,
            );

            if (!optionExists) {
              return 0;
            }

            return cartItem.productVariant
                .where((element) => element.id == option.id)
                .first
                .quantity;
          } catch (e) {
            return 0;
          }
        }
        return 0;
      };
  void showProductDetailsBottomSheet(
    BuildContext context, {
    required int productId,
  }) {
    final ProductDetailsBloc productDetailsBloc = ProductDetailsBloc(
      productDetailsUsecase: sl<ProductDetailsUsecase>(),
    );
    productDetailsBloc.add(
      GetProductDetailsEvent(
        params: ProductDetailsParams(
          productId: productId,
        ),
      ),
    );

    // Hide the bottom cart when the bottom sheet is opened
    sl<CartVisibilityService>().hideCart();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Make it expandable
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8, // Initial height (70% of screen)
          minChildSize: 0.5, // Minimum height (50% of screen)
          maxChildSize: 0.95, // Maximum height (95% of screen)
          expand: false,
          builder: (context, scrollController) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: productDetailsBloc,
                ),
              ],
              child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                builder: (context, state) {
                  if (state.status == ProductDetailsStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                state.productDetails?.productData.productDetails
                                        .image ??
                                    "",
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const CircularProgressIndicator();
                                },
                                fit: BoxFit.fill,
                                height: 300,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/images/Seller_logo.png",
                                    fit: BoxFit.fill,
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 25,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.productDetails?.productData
                                            .productDetails.name ??
                                        "",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "₹ ${state.productDetails?.productData.productDetails.price ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                      "${state.productDetails?.productData.productDetails.qty} ${state.productDetails?.productData.productDetails.unit}"),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        state.productDetails!.productData
                                                    .avgRating >
                                                0
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: const Color.fromARGB(
                                            255, 228, 212, 64),
                                        size: 26,
                                      ),
                                      Icon(
                                        state.productDetails!.productData
                                                    .avgRating >
                                                1
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: const Color.fromARGB(
                                            255, 228, 212, 64),
                                        size: 26,
                                      ),
                                      Icon(
                                        state.productDetails!.productData
                                                    .avgRating >
                                                2
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: const Color.fromARGB(
                                            255, 228, 212, 64),
                                        size: 26,
                                      ),
                                      Icon(
                                        state.productDetails!.productData
                                                    .avgRating >
                                                3
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: const Color.fromARGB(
                                            255, 228, 212, 64),
                                        size: 26,
                                      ),
                                      Icon(
                                        state.productDetails!.productData
                                                    .avgRating >
                                                4
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: const Color.fromARGB(
                                            255, 228, 212, 64),
                                        size: 26,
                                      ),
                                      Text(
                                        "${state.productDetails?.productData.totalCount} Ratings",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  ExpandableText(
                                    text: state.productDetails?.productData
                                            .productDetails.description ??
                                        "",
                                    maxLines: 3,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    expandButtonStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Wrap(
                                    alignment: WrapAlignment.spaceAround,
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      _boxDesign(
                                        context: context,
                                        icon: state
                                                    .productDetails!
                                                    .productData
                                                    .productDetails
                                                    .deliveryMode ==
                                                1
                                            ? Icons.local_shipping
                                            : state
                                                        .productDetails!
                                                        .productData
                                                        .productDetails
                                                        .deliveryMode ==
                                                    2
                                                ? Icons.local_shipping
                                                : Icons.delivery_dining,
                                        title: "Delivery",
                                        subtitle: state
                                                    .productDetails!
                                                    .productData
                                                    .productDetails
                                                    .deliveryMode ==
                                                1
                                            ? "Normal Delivery"
                                            : state
                                                        .productDetails!
                                                        .productData
                                                        .productDetails
                                                        .deliveryMode ==
                                                    2
                                                ? "Heavy Delivery"
                                                : "Quick Delivery",
                                      ),
                                      _boxDesign(
                                        context: context,
                                        icon: Icons.warning_sharp,
                                        title: state
                                                    .productDetails!
                                                    .productData
                                                    .productDetails
                                                    .prdCoverBy ==
                                                3
                                            ? "Guaranty"
                                            : "Warranty",
                                        subtitle:
                                            "${state.productDetails?.productData.productDetails.prdCoverNum == 1 ? "Months" : "Years"} ${state.productDetails?.productData.productDetails.prdCoverDuration}",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    ).then((_) {
      // Show the cart again when the bottom sheet is closed
      sl<CartVisibilityService>().showCart();
    });
  }

  Widget _boxDesign({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String subtitle,
  }) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 100,
        minHeight: 100,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedBottomBtn extends StatefulWidget {
  final int productId;
  const AnimatedBottomBtn({
    super.key,
    required this.productId,
  });

  @override
  State<AnimatedBottomBtn> createState() => _AnimatedBottomBtnState();
}

class _AnimatedBottomBtnState extends State<AnimatedBottomBtn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartListBloc, CartListState>(
      listener: (context, state) {},
      child: BlocBuilder<CartListBloc, CartListState>(
        builder: (context, cartListState) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: Row(
              children: [
                if (cartListState.cartList != null &&
                    cartListState.cartList!.cartData.isNotEmpty)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        border: Border.all(
                          color: const Color.fromARGB(145, 144, 143, 143),
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    context.push('/cart');
                                  },
                                  splashColor: Colors.white.withAlpha(76),
                                  highlightColor: Colors.white.withAlpha(25),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 60,
                                      minWidth: 60,
                                      minHeight: 40,
                                      maxHeight: 40,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  if (cartListState.cartList == null ||
                                      cartListState
                                          .cartList!.cartData.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return Positioned(
                                    right: 0,
                                    top: 0,
                                    child: cartIconWithBadge(
                                      itemCount: cartListState
                                              .cartList?.cartData.length ??
                                          0,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Text(
                              "View Cart",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (cartListState.cartList != null &&
                    cartListState.cartList!.cartData.isNotEmpty)
                  SizedBox(width: 10),
                Expanded(
                  child: ProductController(
                    btnText: "Add to Cart",
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 5,
                    ),
                    constraints: BoxConstraints(
                      maxHeight: 40,
                      maxWidth: MediaQuery.of(context).size.width - 30,
                    ),
                    productId: widget.productId,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget cartIconWithBadge({required int itemCount}) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(300),
        ),
        color: Colors.white,
      ),
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            itemCount.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
