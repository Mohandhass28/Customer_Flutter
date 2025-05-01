import 'package:customer/core/config/assets/app_images.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/data/models/shop/shop_details/shop_details_model.dart';
import 'package:customer/presentation/shop_details/page/product_details/page/product_details.dart';
import 'package:customer/common/widgets/expandable_text.dart';
import 'package:flutter/material.dart';

class ShopCard extends StatefulWidget {
  const ShopCard({super.key, required this.productDetails});
  final ProductModel productDetails;

  @override
  State<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.productDetails.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "\₹${widget.productDetails.price}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            widget.productDetails.prdAvgRating > 0
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color.fromARGB(255, 228, 212, 64),
                            size: 20,
                          ),
                          Icon(
                            widget.productDetails.prdAvgRating > 1
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color.fromARGB(255, 228, 212, 64),
                            size: 20,
                          ),
                          Icon(
                            widget.productDetails.prdAvgRating > 2
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color.fromARGB(255, 228, 212, 64),
                            size: 20,
                          ),
                          Icon(
                            widget.productDetails.prdAvgRating > 3
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color.fromARGB(255, 228, 212, 64),
                            size: 20,
                          ),
                          Icon(
                            widget.productDetails.prdAvgRating > 4
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color.fromARGB(255, 228, 212, 64),
                            size: 20,
                          ),
                        ],
                      ),
                      Text(
                        "${widget.productDetails.prdAvgRating} Rating",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10),
                      ExpandableText(
                        text: widget.productDetails.description,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        expandButtonStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ProductDetails().showProductDetailsBottomSheet(
                              context,
                              productId: widget.productDetails.id,
                            );
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: 110,
                              maxWidth: 110,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                widget.productDetails.image,
                                fit: BoxFit.fill,
                                width: 110,
                                height: 110,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    AppImages.Seller_logo,
                                    fit: BoxFit.fill,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            child: TextButton.icon(
                              icon: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 15,
                              ),
                              iconAlignment: IconAlignment.end,
                              style: ButtonStyle(
                                minimumSize: WidgetStateProperty.all<Size>(
                                  Size(double.infinity, 34),
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                backgroundColor: WidgetStateProperty.all<Color>(
                                  Color(0xFFA4F4AB),
                                ),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: BorderSide(
                                      color: AppColor.primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                ProductDetails().showAddToCartBottomSheet(
                                    context,
                                    productId: widget.productDetails.id);
                              },
                              label: Text(
                                "Add",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Customisable",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
