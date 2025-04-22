import 'package:customer/presentation/tabs/widget/Categories_card/Categories_card.dart';
import 'package:customer/presentation/tabs/widget/header/header_widget.dart';
import 'package:customer/presentation/tabs/widget/listView/list_view.dart';
import 'package:customer/presentation/tabs/widget/recommendedOrFavoriteTab/recommendedOrFavoriteTab.dart';
import 'package:customer/presentation/tabs/widget/recommended_card/recommended_card_page.dart';
import 'package:flutter/material.dart';

import '../../../widget/ListAndMap/list_map_page.dart';
import '../../../widget/map/map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              height: 150, // Adjust this height based on your needs
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
