import 'dart:async';

import 'package:customer/domain/shop/entities/shop_list/shop_list_params.dart';
import 'package:customer/domain/shop/usecases/shop_list_usecase.dart';
import 'package:customer/presentation/tabs/page/home/bloc/home_bloc.dart';
import 'package:customer/presentation/tabs/widget/Carousel_slider_widget/Carousel_slider_widget.dart';
import 'package:customer/presentation/tabs/widget/Categories_card/Categories_card.dart';
import 'package:customer/presentation/tabs/widget/header/header_widget.dart';
import 'package:customer/presentation/tabs/widget/recommendedOrFavoriteTab/recommendedOrFavoriteTab.dart';
import 'package:customer/presentation/tabs/widget/recommended_card/recommended_card_page.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widget/ListAndMap/list_map_page.dart';

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

  String activeTab = "Recommended";

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
    _homeBloc = HomeBloc(shopListUsecase: sl<ShopListUsecase>());
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
    return BlocProvider.value(
      value: _homeBloc
        ..add(
          GetShopListEvent(
            params: ShopListParams(
                type: "food", //food, grocery
                latitude: 22.584761,
                searchValue: "",
                longitude: 88.473778),
          ),
        ),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  HeaderWidget(),
                  SizedBox(height: 15),
                  CarouselSliderWidget(),
                  SizedBox(height: 15),
                  // Stack(
                  //   children: [
                  //     ListMapPage(),
                  //     Positioned(
                  //       top: 20,
                  //       left: 20,
                  //       right: 20,
                  //       child: TextField(
                  //         controller: _searchController,
                  //         decoration: InputDecoration(
                  //           hintText: 'Search here...',
                  //           prefixIcon: Icon(Icons.search),
                  //           suffixIcon: IconButton(
                  //             icon: Icon(Icons.clear),
                  //             onPressed: () {
                  //               // Clear search text
                  //             },
                  //           ),
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //             borderSide: BorderSide(color: Colors.white),
                  //           ),
                  //           enabledBorder: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //             borderSide: BorderSide(color: Colors.white),
                  //           ),
                  //           focusedBorder: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //             borderSide: BorderSide(color: Colors.blue),
                  //           ),
                  //           filled: true,
                  //           fillColor: Colors.white,
                  //           contentPadding: EdgeInsets.symmetric(
                  //             horizontal: 9,
                  //             vertical: 12,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 10),
                  Text("For You"),
                  Recommendedorfavoritetab(
                      activeTab: activeTab, onTabChanged: _onTabChanged),
                  SizedBox(height: 30),
                  Container(
                    height: 150, // Adjust this height based on your needs
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.shopList?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (state.shopList![index].isWishlist == 0 &&
                            activeTab == "Favorites") {
                          return Container();
                        }
                        return Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: RecommendedCardPage(
                            shopListModel: state.shopList![index],
                            homeBloc: _homeBloc,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Text("Categories"),
                  SizedBox(height: 30),
                  Text("What's on your mind?"),
                  SizedBox(height: 30),
                  CategoriesCard(),
                  SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
