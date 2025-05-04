import 'package:customer/core/config/assets/app_images.dart';
import 'package:flutter/material.dart';

class CategoriesCard extends StatefulWidget {
  const CategoriesCard({
    super.key,
    required this.id,
    required this.name,
    required this.image,
  });
  final int id;
  final String name;
  final String image;

  @override
  State<CategoriesCard> createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              // Add navigation or action here
              debugPrint("Category ${widget.name} tapped");
            },
            child: Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: widget.image.isNotEmpty
                  ? Image.network(
                      widget.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppImages.categoryplaceholder,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      AppImages.categoryplaceholder,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
