import 'package:customer/core/bloc/cart_list_bloc/bloc/cart_list_bloc.dart';
import 'package:customer/core/config/assets/app_images.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/data/models/shop/shop_details/shop_details_model.dart';
import 'package:customer/domain/product/entities/product_details_params.dart';
import 'package:customer/domain/product/usecases/product_details_usecase.dart';
import 'package:customer/presentation/shop_details/page/product_details/bloc/product_details/product_details_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/page/product_details.dart';
import 'package:customer/common/widgets/expandable_text.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopCard extends StatefulWidget {
  const ShopCard({super.key, required this.productDetails});
  final ProductModel productDetails;

  @override
  State<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
  late final ProductDetailsBloc productDetailsBloc;
  bool _productInCart = false;

  @override
  void initState() {
    super.initState();
    productDetailsBloc = ProductDetailsBloc(
      productDetailsUsecase: sl<ProductDetailsUsecase>(),
    );
    productDetailsBloc.add(
      GetProductDetailsEvent(
        params: ProductDetailsParams(
          productId: widget.productDetails.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: productDetailsBloc,
        ),
        BlocProvider.value(
          value: sl<CartListBloc>(),
        ),
      ],
      child: Card(
        elevation: 2,
        margin: EdgeInsets.only(top: 20, bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product details (left side)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.productDetails.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "₹${widget.productDetails.price}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                      builder: (context, state) {
                        return Text(
                          "${state.productDetails?.productData.productDetails.qty} ${state.productDetails?.productData.productDetails.unit}",
                        );
                      },
                    ),
                    SizedBox(height: 4),

                    // Star rating
                    Row(
                      children: [
                        for (int i = 0; i < 5; i++)
                          Icon(
                            widget.productDetails.prdAvgRating > i
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color.fromARGB(255, 228, 212, 64),
                            size: 18,
                          ),
                        SizedBox(width: 4),
                        Text(
                          "${widget.productDetails.prdAvgRating} Rating",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Description
                    ExpandableText(
                      text: widget.productDetails.description,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      expandButtonStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                      builder: (context, productDetail) {
                        if (productDetail.status ==
                            ProductDetailsStatus.failure) {
                          return Center(
                              child: Text(productDetail.errorMessage ??
                                  "Unknown error"));
                        }
                        if (productDetail.productDetails == null) {
                          return Center(
                              child: Text("No product details found"));
                        }
                        return Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.favorite,
                              color: productDetail.productDetails?.productData
                                          .isWhistlist ==
                                      1
                                  ? AppColor.primaryColor
                                  : Colors.grey,
                              size: 16,
                            ),
                            onPressed: () {
                              productDetailsBloc.add(
                                WishProductListEvent(
                                  productId: widget.productDetails.id,
                                  isWishlist: productDetail.productDetails!
                                              .productData.isWhistlist ==
                                          1
                                      ? 0
                                      : 1,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Product image and add button (right side)
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Product image with add button
                  Stack(
                    children: [
                      // Product image
                      BlocProvider.value(
                        value: productDetailsBloc,
                        child: GestureDetector(
                          onTap: () {
                            ProductDetails().showProductDetailsBottomSheet(
                              context,
                              productId: widget.productDetails.id,
                            );
                          },
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _buildProductImage(),
                            ),
                          ),
                        ),
                      ),

                      // Add button
                      BlocBuilder<CartListBloc, CartListState>(
                        builder: (context, state) {
                          int count = 0;
                          if (state.cartList!.cartData.isEmpty) {
                            _productInCart = false;
                          } else if (state.cartList!.cartData
                              .map((element) => element.productDetails.id)
                              .contains(widget.productDetails.id)) {
                            _productInCart = true;
                            count = state.cartList!.cartData
                                .firstWhere(
                                  (element) =>
                                      element.productDetails.id ==
                                      widget.productDetails.id,
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
                                          widget.productDetails.id,
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
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
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
                                    productId: widget.productDetails.id,
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
                          return Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: TextButton.icon(
                              icon: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 15,
                              ),
                              iconAlignment: IconAlignment.end,
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
                                  productId: widget.productDetails.id,
                                );
                              },
                              label: Text(
                                "Add",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // Customizable text
                  SizedBox(height: 8),
                  Text(
                    "Customisable",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    if (kReleaseMode) {
      // In release mode, try to load the image with error handling
      try {
        return Image.network(
          widget.productDetails.image,
          fit: BoxFit.cover,
          width: 110,
          height: 110,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Error loading image: $error');
            return Image.asset(
              AppImages.Seller_logo,
              fit: BoxFit.cover,
              width: 110,
              height: 110,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        );
      } catch (e) {
        debugPrint('Exception loading image: $e');
        return Image.asset(
          AppImages.Seller_logo,
          fit: BoxFit.cover,
          width: 110,
          height: 110,
        );
      }
    } else {
      // In debug mode, use the normal approach
      return Image.network(
        widget.productDetails.image,
        fit: BoxFit.cover,
        width: 110,
        height: 110,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            AppImages.Seller_logo,
            fit: BoxFit.cover,
          );
        },
      );
    }
  }
}
