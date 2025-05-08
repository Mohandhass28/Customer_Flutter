import 'package:customer/common/models/cart/variant_add_cart.dart';
import 'package:customer/common/models/index.dart';
import 'package:customer/data/models/product/product_details/index.dart';
import 'package:customer/presentation/shop_details/page/product_details/bloc/product_details/product_details_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Add_Controller/add_controller.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Option/bloc/option_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OptionsWidget extends StatefulWidget {
  const OptionsWidget({super.key, required this.option});
  final ProductOptionModel option; // Changed from ProductVariantModel

  @override
  State<OptionsWidget> createState() => _OptionsWidgetState();
}

class _OptionsWidgetState extends State<OptionsWidget> {
  @override
  Widget build(BuildContext context) {
    final productDetailsBloc = context.read<ProductDetailsBloc>();
    return BlocBuilder<OptionBloc, OptionState>(
      builder: (context, state) {
        final optionItem = state.optionList.firstWhere(
          (element) => element.id == widget.option.id,
          orElse: () => OptionAddCartModel(id: widget.option.id, quantity: 0),
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
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      widget.option.image,
                      fit: BoxFit.contain,
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
              AddController(
                id: widget.option.id,
                quantity: optionItem.quantity,
                incrementOnPress: () {
                  context.read<OptionBloc>().add(
                        IncreaseOptionEvent(
                          price: double.parse(widget.option.price).round(),
                          optionAddCartModel: optionItem.copyWith(
                            id: widget.option.id,
                            quantity: optionItem.quantity,
                          ),
                        ),
                      );
                  productDetailsBloc.add(
                    UpdateTotalPriceEvent(
                      totalPrice: productDetailsBloc.state.totalPrice +
                          double.parse(widget.option.price),
                    ),
                  );
                },
                decrementOnPress: () {
                  context.read<OptionBloc>().add(
                        DecreaseOptionEvent(
                          price: double.parse(widget.option.price).round(),
                          optionAddCartModel: optionItem.copyWith(
                            id: widget.option.id,
                            quantity: optionItem.quantity,
                          ),
                        ),
                      );
                  if (optionItem.quantity > 0) {
                    productDetailsBloc.add(
                      UpdateTotalPriceEvent(
                        totalPrice: productDetailsBloc.state.totalPrice -
                            double.parse(widget.option.price),
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
