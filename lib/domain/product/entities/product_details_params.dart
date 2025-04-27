class ProductDetailsParams {
  final int productId;

  const ProductDetailsParams({
    required this.productId,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
    };
  }
}
