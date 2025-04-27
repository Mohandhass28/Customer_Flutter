class ShopDetailsParams {
  final int shopId;
  final double latitude;
  final double longitude;

  const ShopDetailsParams({
    required this.shopId,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'shop_id': shopId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
