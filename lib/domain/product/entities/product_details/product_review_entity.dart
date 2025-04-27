import 'package:equatable/equatable.dart';

class ProductReviewEntity extends Equatable {
  // Since the JSON has an empty array for product_reviews,
  // I'm creating a basic structure that can be expanded later
  final int id;
  final int productId;
  final int userId;
  final String review;
  final int rating;
  final String createdAt;

  const ProductReviewEntity({
    required this.id,
    required this.productId,
    required this.userId,
    required this.review,
    required this.rating,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        userId,
        review,
        rating,
        createdAt,
      ];
}
