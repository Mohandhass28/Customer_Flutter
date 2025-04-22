import 'package:flutter/material.dart';

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
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: RecommendedCardPage(),
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
  }
}
