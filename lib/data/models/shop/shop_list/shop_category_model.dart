class ShopCategoryModel {
  final int id;
  final String name;
  final String? image;

  ShopCategoryModel({
    required this.id,
    required this.name,
    this.image,
  });

  factory ShopCategoryModel.fromJson(Map<String, dynamic> json) {
    return ShopCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}