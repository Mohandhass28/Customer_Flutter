class WishListParams {
  final int shopId;

  const WishListParams({
    required this.shopId,
  });

  Map<String, dynamic> toJson() {
    return {
      'shop_id': shopId,
    };
  }
}
