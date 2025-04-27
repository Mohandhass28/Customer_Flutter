import 'package:customer/domain/product/entities/product_details/product_data_entity.dart';
import 'product_details_model.dart';
import 'product_variant_model.dart';
import 'product_option_model.dart';
import 'product_review_model.dart';

class ProductDataModel extends ProductDataEntity {
  const ProductDataModel({
    required super.productDetails,
    required super.productImages,
    required super.productVariants,
    required super.productOptions,
    required super.avgRating,
    required super.totalCount,
    required super.productReviews,
    required super.prdTagName,
    required super.isWhistlist,
  });

  factory ProductDataModel.fromJson(Map<String, dynamic> json) {
    return ProductDataModel(
      productDetails: ProductDetailsModel.fromJson(json['product_details'] ?? {}),
      productImages: json['product_images'] ?? [],
      productVariants: (json['product_variants'] as List?)
              ?.map((variant) => ProductVariantModel.fromJson(variant))
              .toList() ??
          [],
      productOptions: (json['product_options'] as List?)
              ?.map((option) => ProductOptionModel.fromJson(option))
              .toList() ??
          [],
      avgRating: json['avg_rating'] ?? 0,
      totalCount: json['total_count'] ?? '0',
      productReviews: (json['product_reviews'] as List?)
              ?.map((review) => ProductReviewModel.fromJson(review))
              .toList() ??
          [],
      prdTagName: json['prd_tag_name'] ?? '',
      isWhistlist: json['is_whistlist'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_details': (productDetails as ProductDetailsModel).toJson(),
      'product_images': productImages,
      'product_variants': productVariants
          .map((variant) => (variant as ProductVariantModel).toJson())
          .toList(),
      'product_options': productOptions
          .map((option) => (option as ProductOptionModel).toJson())
          .toList(),
      'avg_rating': avgRating,
      'total_count': totalCount,
      'product_reviews': productReviews
          .map((review) => (review as ProductReviewModel).toJson())
          .toList(),
      'prd_tag_name': prdTagName,
      'is_whistlist': isWhistlist,
    };
  }
}
