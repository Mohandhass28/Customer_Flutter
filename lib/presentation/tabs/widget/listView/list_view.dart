import 'package:customer/core/config/assets/app_images.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/data/models/shop/shop_list/shop_list_model.dart';
import 'package:customer/presentation/tabs/page/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ListViewWidget extends StatefulWidget {
  const ListViewWidget({super.key});

  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: state.shopList?.length ?? 0,
          itemBuilder: (context, index) {
            return buildShopCard(state.shopList![index]);
          },
        );
      },
    );
  }

  Widget _buildImage(String bannerImage) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.green.shade800,
        borderRadius: BorderRadius.circular(4),
      ),
      child: bannerImage.isEmpty
          ? Image.asset(
              AppImages.Seller_logo,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            )
          : Image.network(
              bannerImage,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  AppImages.Seller_logo,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                );
              },
            ),
    );
  }

  Widget buildShopCard(ShopListModel shopListModel) {
    return GestureDetector(
      onTap: () {
        context.push('/shop-details', extra: {
          'shopId': shopListModel.id,
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildImage(shopListModel.bannerImage),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shopListModel.shopName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              shopListModel.avgRating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shopListModel.productCategory
                        .toString()
                        .split("[")[1]
                        .split("]")[0],
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${shopListModel.distance} ${shopListModel.distanceIn}",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
