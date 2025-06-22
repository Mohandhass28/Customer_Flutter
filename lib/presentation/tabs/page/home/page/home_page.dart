import 'dart:async';

import 'package:customer/common/widgets/bottom_cart_with_scroll/bottom_cart_with_scroll.dart';
import 'package:customer/core/refresh_services/cart_visibility_service.dart';
import 'package:customer/data/models/favourites_product_list/fav_product_model.dart';
import 'package:customer/domain/favourites_product_list/usecases/get_fav_product_list_usecase.dart';
import 'package:customer/domain/shop/entities/shop_list/shop_list_params.dart';
import 'package:customer/domain/shop/usecases/shop_list_usecase.dart';
import 'package:customer/presentation/tabs/page/home/bloc/home_bloc.dart';
import 'package:customer/presentation/tabs/widget/Carousel_slider_widget/Carousel_slider_widget.dart';
import 'package:customer/presentation/tabs/widget/Categories_card/Categories_card.dart';
import 'package:customer/presentation/tabs/widget/Fav_Product_Card/Fav_Product_Cart.dart';
import 'package:customer/presentation/tabs/widget/header/header_widget.dart';
import 'package:customer/presentation/tabs/widget/product_card/product_cart.dart';
import 'package:customer/presentation/tabs/widget/recommendedOrFavoriteTab/recommendedOrFavoriteTab.dart';
import 'package:customer/presentation/tabs/widget/recommended_card/recommended_card_page.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final _searchDebounce = Duration(milliseconds: 300);
  Timer? _debounceTimer;
  late HomeBloc _homeBloc;

  String activeTab = "Shop";

  void _onTabChanged(String tab) {
    setState(() {
      activeTab = tab;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _debounceTimer?.cancel();
    _homeBloc.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _homeBloc = HomeBloc(
        shopListUsecase: sl<ShopListUsecase>(),
        getFavProductListUsecase: sl<GetFavProductListUsecase>());
  }

  void _onSearchChanged() {
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(
      _searchDebounce,
      () {
        final searchValue = _searchController.text;
        _homeBloc.add(
          GetShopListEvent(
            params: ShopListParams(
              latitude: 22.584761,
              longitude: 88.473778,
              type: "",
              searchValue: searchValue,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // Ignore scroll notifications from carousel or other nested scrollables
            if (notification.depth > 0) {
              return true;
            }

            // Process all scroll update notifications
            if (notification is ScrollUpdateNotification) {
              // We're only using scrollDelta for direction detection

              // Check if we have a meaningful scroll delta
              if (notification.scrollDelta != null &&
                  notification.scrollDelta!.round() > 0) {
                sl<CartVisibilityService>().hideCart();
              } else if (notification.scrollDelta != null &&
                  notification.scrollDelta!.round() < 0) {
                sl<CartVisibilityService>().showCart();
              }
            }

            return false;
          },
          child: Expanded(
            child: _home(context),
          ),
        ),
        BottomCartWithScroll(),
      ],
    );
  }

  Widget _home(BuildContext context) {
    return BlocProvider.value(
      value: _homeBloc
        ..add(
          GetShopListEvent(
            params: ShopListParams(
                type: "", //food, grocery
                latitude: 22.584761,
                searchValue: "",
                longitude: 88.473778),
          ),
        )
        ..add(GetFavProductListEvent()),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          debugPrint(state.shopList?.shopCategoryList.toString());
          return Scaffold(
            body: SingleChildScrollView(
              key: PageStorageKey('home_scroll'),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  // Use a unique key for each HeaderWidget instance
                  HeaderWidget(key: ValueKey('home_header')),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search here...',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: const Color.fromARGB(159, 38, 38, 38)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: const Color.fromARGB(159, 38, 38, 38)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CarouselSliderWidget(),
                  SizedBox(height: 15),

                  Text("For You"),
                  Recommendedorfavoritetab(
                      activeTab: activeTab, onTabChanged: _onTabChanged),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: IntrinsicHeight(
                            child: Row(
                              children: List.generate(
                                state.shopList?.shopList.length ?? 0,
                                (index) {
                                  if (state.shopList!.shopList.isNotEmpty) {
                                    if (state.shopList!.shopList[index]
                                                .isWishlist ==
                                            1 &&
                                        activeTab == "Shop") {
                                      return Padding(
                                        padding: EdgeInsets.only(right: 16),
                                        child: RecommendedCardPage(
                                          shopListModel: state
                                                  .shopList!.shopList[
                                              index], // This is safe because we check itemCount
                                          homeBloc: _homeBloc,
                                        ),
                                      );
                                    }
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: LayoutBuilder(builder: (
                      context,
                      constraints,
                    ) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: IntrinsicHeight(
                          child: Row(
                            children: List.generate(
                              state.favProductList?.data.length ?? 0,
                              (index) {
                                if (state.favProductList!.data.isNotEmpty) {
                                  if (activeTab == "Products") {
                                    return Padding(
                                      padding: EdgeInsets.only(right: 16),
                                      child: FavProductCart(
                                        product: state.favProductList!
                                            .data[index] as FavProductModel,
                                      ),
                                    );
                                  }
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 30),
                  Text("Categories"),
                  SizedBox(height: 30),
                  Text(
                    "What's on your mind?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  // Add Container with constraints to ensure visibility
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Wrap(
                      alignment: WrapAlignment.spaceAround,
                      spacing: 10,
                      runSpacing: 10,
                      children: (state.shopList?.shopCategoryList.isNotEmpty ==
                              true)
                          ? state.shopList!.shopCategoryList.map((category) {
                              return CategoriesCard(
                                id: category.id,
                                name: category.name,
                                image: category.image ?? "",
                              );
                            }).toList()
                          : [
                              // Fallback categories when list is empty or null
                              CategoriesCard(
                                id: 1,
                                name: "Food",
                                image: "",
                              ),
                              CategoriesCard(
                                id: 2,
                                name: "Grocery",
                                image: "",
                              ),
                              CategoriesCard(
                                id: 3,
                                name: "Beverages",
                                image: "",
                              ),
                            ],
                    ),
                  ),

                  SizedBox(height: 30),

                  ...state.shopList?.shopList.map((shop) {
                        return ProductCart(
                          product: shop,
                        );
                      }).toList() ??
                      [],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
