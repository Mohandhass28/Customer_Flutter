import 'dart:async';

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
  final _searchDebounce = Duration(milliseconds: 3000);
  Timer? _debounceTimer;
  bool mapPan = false;

  void _setInterval() {
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(_searchDebounce, () {
      setState(() {
        mapPan = false;
      });
    });
  }

  void _increaseMapHeight() {
    setState(() {
      mapPan = true;
    });
    _setInterval();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: mapPan ? 600 : 400,
      ),
      child: Stack(
        children: [
          shopMap ? MapPage(onMapPan: _increaseMapHeight) : _shopCardList(),
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
                      style: TextButton.styleFrom(),
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
                      style: TextButton.styleFrom(),
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
    return Container(
      margin: EdgeInsets.only(top: 60),
      child: SizedBox(
        height: 400,
        child: ListViewWidget(),
      ),
    );
  }
}
