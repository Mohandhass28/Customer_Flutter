import 'package:customer/core/bloc/cart_list_bloc/bloc/cart_list_bloc.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/data/models/favourites_product_list/fav_product_list_response_model.dart';
import 'package:customer/data/models/favourites_product_list/fav_product_model.dart';
import 'package:customer/presentation/shop_details/page/product_details/page/product_details.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavProductCart extends StatefulWidget {
  const FavProductCart({super.key, required this.product});

  final FavProductModel product;

  @override
  State<FavProductCart> createState() => _FavProductCartState();
}

class _FavProductCartState extends State<FavProductCart> {
  bool _productInCart = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: sl<CartListBloc>(),
        ),
      ],
      child: Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          constraints: BoxConstraints(
            maxWidth: 160,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                  height: 120,
                  child: Image(
                    image: NetworkImage(widget.product.image),
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/CarouselImg.png',
                        fit: BoxFit.cover,
                      );
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          widget.product.prdAvgRating > 0
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color.fromARGB(255, 226, 204, 7),
                        ),
                        Icon(
                          widget.product.prdAvgRating > 1
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color.fromARGB(255, 226, 204, 7),
                        ),
                        Icon(
                          widget.product.prdAvgRating > 2
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color.fromARGB(255, 226, 204, 7),
                        ),
                        Icon(
                          widget.product.prdAvgRating > 3
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color.fromARGB(255, 226, 204, 7),
                        ),
                        Icon(
                          widget.product.prdAvgRating > 4
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color.fromARGB(255, 226, 204, 7),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "₹ 108/kg",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Add button
                    BlocBuilder<CartListBloc, CartListState>(
                      builder: (context, state) {
                        int count = 0;
                        if (state.cartList!.cartData.isEmpty) {
                          _productInCart = false;
                        } else if (state.cartList!.cartData
                            .map((element) => element.productDetails.id)
                            .contains(widget.product.id)) {
                          _productInCart = true;
                          count = state.cartList!.cartData
                              .firstWhere(
                                (element) =>
                                    element.productDetails.id ==
                                    widget.product.id,
                              )
                              .productVariant
                              .fold<int>(
                                0,
                                (previousValue, element) =>
                                    previousValue + element.quantity,
                              );

                          count = count +
                              state.cartList!.cartData
                                  .firstWhere(
                                    (element) =>
                                        element.productDetails.id ==
                                        widget.product.id,
                                  )
                                  .productOptions
                                  .fold<int>(
                                    0,
                                    (previousValue, element) =>
                                        previousValue + element.quantity,
                                  );
                        } else {
                          _productInCart = false;
                        }
                        if (_productInCart) {
                          return Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: TextButton(
                              style: ButtonStyle(
                                minimumSize: WidgetStateProperty.all<Size>(
                                  Size(double.infinity, 34),
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                backgroundColor: WidgetStateProperty.all<Color>(
                                  Color(0xFFA4F4AB),
                                ),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: BorderSide(
                                      color: AppColor.primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                ProductDetails().showAddToCartBottomSheet(
                                  context,
                                  productId: widget.product.id,
                                );
                              },
                              child: Text(
                                count.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }
                        return TextButton(
                          onPressed: () {
                            ProductDetails().showAddToCartBottomSheet(
                              context,
                              productId: widget.product.id,
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(50, 24),
                            side: BorderSide(
                              color: AppColor.primaryColor,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            "Add",
                            style: TextStyle(
                              color: AppColor.primaryColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
