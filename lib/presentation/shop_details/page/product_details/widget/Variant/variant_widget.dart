import 'package:customer/common/models/cart/variant_add_cart.dart';
import 'package:customer/core/bloc/cart_list_bloc/bloc/cart_list_bloc.dart';
import 'package:customer/data/models/product/product_details/index.dart';
import 'package:customer/presentation/shop_details/page/product_details/bloc/product_details/product_details_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Add_Controller/add_controller.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Variant/bloc/variant_bloc.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VariantWidget extends StatefulWidget {
  const VariantWidget({super.key, required this.variant});

  final ProductVariantModel variant;

  @override
  State<VariantWidget> createState() => _VariantWidgetState();
}

class _VariantWidgetState extends State<VariantWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productDetailsBloc = context.read<ProductDetailsBloc>();

    return BlocBuilder<VariantBloc, VariantState>(
      builder: (context, state) {
        final variantItem = state.variantList.firstWhere(
          (element) => element.id == widget.variant.id,
          orElse: () => VariantAddCartModel(id: widget.variant.id, quantity: 0),
        );
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 8,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      widget.variant.image,
                      fit: BoxFit.contain,
                      height: 60,
                      width: 60,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/Seller_logo.png",
                          height: 60,
                          width: 60,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                  Text(
                    productDetailsBloc.state.productDetails?.productData
                            .productDetails.name ??
                        "",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.variant.unit,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                widget.variant.price,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AddController(
                id: widget.variant.id,
                quantity: variantItem.quantity,
                incrementOnPress: () {
                  context.read<VariantBloc>().add(
                        IncreaseVariantEvent(
                          price: double.parse(widget.variant.price).round(),
                          variantAddCartModel: variantItem.copyWith(
                            id: widget.variant.id,
                            quantity: variantItem.quantity,
                          ),
                        ),
                      );
                  productDetailsBloc.add(
                    UpdateTotalPriceEvent(
                      totalPrice: productDetailsBloc.state.totalPrice +
                          double.parse(widget.variant.price),
                    ),
                  );
                },
                decrementOnPress: () {
                  context.read<VariantBloc>().add(
                        DecreaseVariantEvent(
                          price: double.parse(widget.variant.price).round(),
                          variantAddCartModel: variantItem.copyWith(
                            id: widget.variant.id,
                            quantity: variantItem.quantity,
                          ),
                        ),
                      );
                  if (variantItem.quantity > 0) {
                    productDetailsBloc.add(
                      UpdateTotalPriceEvent(
                        totalPrice: productDetailsBloc.state.totalPrice -
                            double.parse(widget.variant.price),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
