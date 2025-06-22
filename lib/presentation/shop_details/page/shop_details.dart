import 'package:customer/common/widgets/bottom_Cart/bottom_cart.dart';
import 'package:customer/core/bloc/cart_list_bloc/bloc/cart_list_bloc.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/data/models/shop/shop_details/shop_details_model.dart';
import 'package:customer/domain/cart/usecases/cart_list_usecase.dart';
import 'package:customer/domain/shop/entities/shop_details/shop_details_params.dart';
import 'package:customer/domain/shop/usecases/shop_list_usecase.dart';
import 'package:customer/presentation/cart_details/widget/bill_summary/bloc/bill_summary_bloc.dart';
import 'package:customer/presentation/shop_details/bloc/shop_details_bloc.dart';
import 'package:customer/presentation/shop_details/widget/shop_card/shop_card.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ShopDetails extends StatefulWidget {
  final int shopId;
  const ShopDetails({super.key, required this.shopId});

  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShopDetailsBloc>(
          create: (context) => ShopDetailsBloc(
            shopDetailsUsecase: sl<ShopDetailsUsecase>(),
          )..add(
              GetShopDetailsEvent(
                params: ShopDetailsParams(
                  shopId: widget.shopId,
                  latitude: 22.584761,
                  longitude: 88.473778,
                ),
              ),
            ),
        ),
      ],
      child: BlocConsumer<ShopDetailsBloc, ShopDetailsState>(
        listener: (context, state) {
          debugPrint(
              'Shop details status: ${state.shopDetails?.shopData.shopDetails.isOpen}');
          if (state.status == ShopDetailsStatus.failure) {
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
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ShopDetailsStatus.loading) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                title: Text("Loading Shop Details"),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Loading shop details..."),
                  ],
                ),
              ),
            );
          }

          if (state.status == ShopDetailsStatus.failure) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                title: Text("Error"),
              ),
              body: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Failed to load shop details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        state.errorMessage ?? "Unknown error",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ShopDetailsBloc>().add(
                                GetShopDetailsEvent(
                                  params: ShopDetailsParams(
                                    shopId: widget.shopId,
                                    latitude: 22.584761,
                                    longitude: 88.473778,
                                  ),
                                ),
                              );
                        },
                        child: Text(
                          "Retry",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (state.status == ShopDetailsStatus.success &&
              state.shopDetails?.shopData.shopDetails.isOpen == false) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                title: Text("Shop is closed"),
              ),
              body: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Shop is closed now! Please try again later",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        state.errorMessage ?? "Shop is closed",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ShopDetailsBloc>().add(
                                GetShopDetailsEvent(
                                  params: ShopDetailsParams(
                                    shopId: widget.shopId,
                                    latitude: 22.584761,
                                    longitude: 88.473778,
                                  ),
                                ),
                              );
                        },
                        child: Text(
                          "Retry",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(200),
              child: Container(
                color: Colors.white,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button and shop name
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 8.0, right: 16.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.pop();
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  state.shopDetails?.shopData.shopDetails
                                          .shopName ??
                                      "",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            // Empty SizedBox to balance the back button
                            const SizedBox(width: 24),
                          ],
                        ),
                      ),

                      // Categories
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            state.shopDetails?.shopData.productCategory
                                    .toString()
                                    .split("[")[1]
                                    .split("]")[0] ??
                                "",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),

                      // Rating and reviews
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      state.shopDetails?.shopData.avgRating
                                              .toString() ??
                                          "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Icon(
                                      Icons.star,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${state.shopDetails?.shopData.totalCount ?? "0"} Ratings',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Time and distance
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${state.shopDetails?.shopData.deliveryTime ?? 0} minutes • ${state.shopDetails?.shopData.distance ?? 0} km',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  state.shopDetails?.shopData.userDetails
                                          .name ??
                                      "",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    spacing: 6,
                                    children: [
                                      Text(
                                        state.shopDetails?.shopData
                                                .totalCount ??
                                            "",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "Review",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  child: const Text(
                                    'Write a Review',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Recommended",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: state.shopDetails?.shopData.productList
                                      .isNotEmpty ==
                                  true
                              ? ListView.builder(
                                  itemCount: state
                                      .shopDetails?.shopData.productList.length,
                                  shrinkWrap: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final product = state.shopDetails?.shopData
                                        .productList[index];
                                    if (product != null) {
                                      return ShopCard(
                                        productDetails: product as ProductModel,
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                )
                              : const Center(
                                  child: Text("No products available"),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                BottomCart(),
              ],
            ),
          );
        },
      ),
    );
  }
}
