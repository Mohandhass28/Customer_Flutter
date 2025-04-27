import 'package:equatable/equatable.dart';
import 'product_details_entity.dart';
import 'product_variant_entity.dart';
import 'product_option_entity.dart';
import 'product_review_entity.dart';

class ProductDataEntity extends Equatable {
  final ProductDetailsEntity productDetails;
  final List<dynamic> productImages;
  final List<ProductVariantEntity> productVariants;
  final List<ProductOptionEntity> productOptions;
  final int avgRating;
  final String totalCount;
  final List<ProductReviewEntity> productReviews;
  final String prdTagName;
  final int isWhistlist;

  const ProductDataEntity({
    required this.productDetails,
    required this.productImages,
    required this.productVariants,
    required this.productOptions,
    required this.avgRating,
    required this.totalCount,
    required this.productReviews,
    required this.prdTagName,
    required this.isWhistlist,
  });

  @override
  List<Object?> get props => [
        productDetails,
        productImages,
        productVariants,
        productOptions,
        avgRating,
        totalCount,
        productReviews,
        prdTagName,
        isWhistlist,
      ];
}
