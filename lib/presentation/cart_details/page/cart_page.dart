import 'package:customer/core/bloc/cart_list_bloc/bloc/cart_list_bloc.dart';
import 'package:customer/presentation/cart_details/widget/bill_summary/bill_summary.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Add_Controller/add_controller.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: sl<CartListBloc>(),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              BlocBuilder<CartListBloc, CartListState>(
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...state.cartList!.cartData
                          .map((productList) => productList.productVariant)
                          .toList()
                          .map(
                        (variantList) {
                          return Column(
                            children: variantList
                                .map(
                                  (varian) => Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  varian.variantName.isNotEmpty
                                                      ? varian.variantName
                                                      : "No name",
                                                ),
                                                Text(
                                                  "₹${varian.price}",
                                                ),
                                              ],
                                            ),
                                            AddController(
                                              decrementOnPress: () {},
                                              incrementOnPress: () {},
                                              id: varian.id,
                                              quantity: varian.quantity,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ).toList(),
                      ...state.cartList!.cartData
                          .map((productList) => productList.productOptions)
                          .toList()
                          .map(
                        (optionsList) {
                          return Column(
                            children: optionsList
                                .map(
                                  (options) => Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  options.name.isNotEmpty
                                                      ? options.name
                                                      : "No name",
                                                ),
                                                Text(
                                                  "₹${options.price}",
                                                ),
                                              ],
                                            ),
                                            AddController(
                                              decrementOnPress: () {},
                                              incrementOnPress: () {},
                                              id: options.id,
                                              quantity: options.quantity,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ).toList(),
                      BillSummary()
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
