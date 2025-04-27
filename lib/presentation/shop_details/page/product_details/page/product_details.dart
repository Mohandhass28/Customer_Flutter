import 'package:customer/common/models/cart/option_add_cart.dart';
import 'package:customer/common/models/cart/variant_add_cart.dart';
import 'package:customer/data/models/product/product_details/index.dart';
import 'package:customer/domain/product/entities/product_details_params.dart';
import 'package:customer/domain/product/usecases/product_details_usecase.dart';
import 'package:customer/presentation/shop_details/page/product_details/bloc/product_details_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Option/bloc/option_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Option/options_widget.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Variant/bloc/variant_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Variant/variant_widget.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  static void showAddToCartBottomSheet(
    BuildContext context, {
    required int productId,
  }) {
    final VariantBloc variantBloc = VariantBloc();
    final OptionBloc optionBloc = OptionBloc();
    final ProductDetailsBloc productDetailsBloc = ProductDetailsBloc(
      productDetailsUsecase: sl<ProductDetailsUsecase>(),
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Make it expandable
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
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
                                  quantity: 0,
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
                                  quantity: 0,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                  BlocListener<VariantBloc, VariantState>(
                    listener: (context, state) {},
                  ),
                  BlocListener<OptionBloc, OptionState>(
                    listener: (context, state) {},
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
                            padding: const EdgeInsets.all(16),
                            children: [
                              // Drag handle
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
                              Row(
                                children: [
                                  Container(
                                    height: 120,
                                    width: 120,
                                    constraints: const BoxConstraints(
                                      maxHeight: 120,
                                      maxWidth: 120,
                                    ),
                                    child: Image.network(
                                      state.productDetails?.productData
                                              .productDetails.image ??
                                          "",
                                      fit: BoxFit.contain,
                                      height: 120,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          "assets/images/Seller_logo.png",
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
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 32),
                              // Variants section
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
                              ...state
                                  .productDetails!.productData.productVariants
                                  .map(
                                (e) => BlocProvider.value(
                                  value: variantBloc,
                                  child: VariantWidget(
                                    variant: e as ProductVariantModel,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...state
                                  .productDetails!.productData.productOptions
                                  .map(
                                (e) => BlocProvider.value(
                                  value: optionBloc,
                                  child: OptionsWidget(
                                    option: e
                                        as ProductOptionModel, // Changed from ProductVariantModel
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              "Add Item ₹${state.totalPrice}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
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

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
