class WishListProductParams {
  final int productId;

  const WishListProductParams({
    required this.productId,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
    };
  }
}
