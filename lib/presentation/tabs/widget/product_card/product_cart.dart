import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/data/models/shop/shop_list/shop_list_model.dart';
import 'package:customer/domain/shop/usecases/shop_list_usecase.dart';
import 'package:customer/presentation/tabs/page/home/bloc/home_bloc.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductCart extends StatefulWidget {
  const ProductCart({super.key, required this.product});

  final ShopListModel product;

  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<HomeBloc>(),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return InkWell(
            onTap: () {
              context.push('/shop-details', extra: {
                'shopId': widget.product.id,
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: 240,
                      minWidth: double.infinity,
                    ),
                    child: ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Image(
                        image: NetworkImage(widget.product.logo),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/orderlaneSellerIcon.png",
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.black.withOpacity(0),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(.7),
                            ],
                            stops: [0.0, 0.3, 0.4, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      widget.product.shopName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: IconButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(
                              AddRemoveShopWishlist(
                                shopId: widget.product.id,
                                isWishlist:
                                    widget.product.isWishlist == 1 ? 0 : 1,
                              ),
                            );
                      },
                      icon: widget.product.isWishlist == 1
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                // White border
                                Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                // Filled heart slightly smaller
                                Icon(
                                  Icons.favorite,
                                  color: AppColor.primaryColor,
                                  size: 22,
                                ),
                              ],
                            )
                          : Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InnerShadowCategoryCard extends StatelessWidget {
  final ShopListModel product;

  const InnerShadowCategoryCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // Inner shadow effect using gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.1),
                    ],
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),
            // Your actual CategoriesCard
            ProductCart(
              product: product,
            ),
          ],
        ),
      ),
    );
  }
}
