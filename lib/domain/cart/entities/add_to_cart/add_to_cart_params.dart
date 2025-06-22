import 'package:customer/common/models/cart/option_add_cart.dart';
import 'package:customer/common/models/cart/variant_add_cart.dart';

class AddToCartParams {
  final int productId;
  final List<VariantAddCartModel> variantAddCartModel;
  final List<OptionAddCartModel> optionAddCartModel;
  final int quantity;

  const AddToCartParams({
    required this.productId,
    required this.variantAddCartModel,
    required this.optionAddCartModel,
    this.quantity = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'variant_id': variantAddCartModel.map((e) => e.toJson()).toList(),
      'option_id': optionAddCartModel.map((e) => e.toJson()).toList(),
      'quantity': quantity,
    };
  }
}
