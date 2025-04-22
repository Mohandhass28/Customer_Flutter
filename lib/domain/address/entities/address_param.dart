class AddressParam {
  final String searchVlaue;

  AddressParam({
    required this.searchVlaue,
  });

  Map<String, dynamic> toJson() {
    return {
      'search_val': searchVlaue,
    };
  }
}
