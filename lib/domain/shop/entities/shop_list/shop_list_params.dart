class ShopListParams {
  final String searchValue;
  final String type;
  final double latitude;
  final double longitude;

  const ShopListParams({
    this.searchValue = '',
    this.type = '',
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'search_val': searchValue,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  ShopListParams copyWith({
    String? searchValue,
    String? type,
    double? latitude,
    double? longitude,
  }) {
    return ShopListParams(
      searchValue: searchValue ?? this.searchValue,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
