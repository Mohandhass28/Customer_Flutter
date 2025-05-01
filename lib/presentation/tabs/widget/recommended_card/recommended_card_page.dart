import 'package:customer/core/config/assets/app_images.dart';
import 'package:customer/data/models/shop/shop_list/shop_list_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecommendedCardPage extends StatefulWidget {
  const RecommendedCardPage({super.key, required this.shopListModel});

  final ShopListModel shopListModel;

  @override
  State<RecommendedCardPage> createState() => _RecommendedCardPageState();
}

class _RecommendedCardPageState extends State<RecommendedCardPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/shop-details', extra: {
          'shopId': widget.shopListModel.id,
        });
      },
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 110,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildImage(),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.favorite,
                          color: widget.shopListModel.isWishlist == 1
                              ? Colors.red
                              : Colors.grey,
                          size: 14,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.shopListModel.shopName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              " ${widget.shopListModel.distance} ${widget.shopListModel.distanceIn}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final bannerImage = widget.shopListModel.bannerImage.isNotEmpty
        ? widget.shopListModel.bannerImage
        : widget.shopListModel.logo;

    if (bannerImage.isEmpty) {
      return Image.asset(
        AppImages.Seller_logo,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.store, color: Colors.grey),
          );
        },
      );
    }

    return Image.network(
      bannerImage,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          AppImages.Seller_logo,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(Icons.store, color: Colors.grey),
            );
          },
        );
      },
    );
  }
}
