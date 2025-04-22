import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/presentation/tabs/widget/listView/list_view.dart';
import 'package:customer/presentation/tabs/widget/map/map_page.dart';
import 'package:flutter/material.dart';

class ListMapPage extends StatefulWidget {
  const ListMapPage({super.key});

  @override
  State<ListMapPage> createState() => _ListMapPageState();
}

class _ListMapPageState extends State<ListMapPage> {
  bool shopMap = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 400,
      ),
      child: Stack(
        children: [
          shopMap ? MapPage() : _shopCardList(),
          Positioned(
            bottom: 40,
            right: 40,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: shopMap
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          shopMap = false;
                        });
                      },
                      child: Text(
                        "Shop List",
                        style: TextStyle(
                          color: AppColor.primaryColor,
                        ),
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          shopMap = true;
                        });
                      },
                      child: Text(
                        "Shop Map",
                        style: TextStyle(
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shopCardList() {
    return SingleChildScrollView(
      child: ListViewWidget(),
    );
  }
}
