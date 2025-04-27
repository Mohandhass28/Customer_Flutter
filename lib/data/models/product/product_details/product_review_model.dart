import 'package:customer/domain/product/entities/product_details/product_review_entity.dart';

class ProductReviewModel extends ProductReviewEntity {
  const ProductReviewModel({
    required super.id,
    required super.productId,
    required super.userId,
    required super.review,
    required super.rating,
    required super.createdAt,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      review: json['review'] ?? '',
      rating: json['rating'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'review': review,
      'rating': rating,
      'created_at': createdAt,
    };
  }
}
