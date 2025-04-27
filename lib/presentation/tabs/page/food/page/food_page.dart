import 'package:customer/domain/shop/entities/shop_list/shop_list_params.dart';
import 'package:customer/domain/shop/usecases/shop_list_usecase.dart';
import 'package:customer/presentation/tabs/page/home/bloc/home_bloc.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widget/Categories_card/Categories_card.dart';
import '../../../widget/ListAndMap/list_map_page.dart';
import '../../../widget/header/header_widget.dart';
import '../../../widget/recommendedOrFavoriteTab/recommendedOrFavoriteTab.dart';
import '../../../widget/recommended_card/recommended_card_page.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(shopListUsecase: sl<ShopListUsecase>())
        ..add(
          GetShopListEvent(
            params: ShopListParams(
              latitude: 22.584761,
              longitude: 88.473778,
              type: "grocery",
              searchValue: "",
            ),
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
                  ListMapPage(),
                  SizedBox(height: 10),
                  Text("For You"),
                  Recommendedorfavoritetab(),
                  SizedBox(height: 30),
                  Container(
                    height: 150,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.shopList?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: RecommendedCardPage(
                            shopListModel: state.shopList![index],
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
