import 'package:customer/common/models/cart/variant_add_cart.dart';
import 'package:customer/data/models/product/product_details/index.dart';
import 'package:customer/presentation/shop_details/page/product_details/bloc/product_details_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Add_Controller/add_controller.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Variant/bloc/variant_bloc.dart';
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
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      widget.variant.image,
                      fit: BoxFit.fill,
                      height: 100,
                      width: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/Seller_logo.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.variant.unit,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                widget.variant.price,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
