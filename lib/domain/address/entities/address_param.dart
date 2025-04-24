class AddressParam {
  final String searchValue;

  AddressParam({
    required this.searchValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'search_val': searchValue,
    };
  }
}
