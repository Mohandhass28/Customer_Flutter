import 'package:customer/common/models/cart/option_add_cart.dart';
import 'package:customer/common/models/cart/variant_add_cart.dart';
import 'package:customer/core/bloc/cart_list_bloc/bloc/cart_list_bloc.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/core/services/bill_summary_refresh_service.dart';
import 'package:customer/core/services/cart_refresh_service.dart';
import 'package:customer/data/models/cart/cart_list/cart_data_model.dart';
import 'package:customer/domain/cart/entities/add_to_cart/add_to_cart_params.dart';
import 'package:customer/domain/cart/usecases/cart_details_usecase.dart';
import 'package:customer/domain/cart/usecases/modify_cart_usecase.dart';
import 'package:customer/presentation/cart_details/bloc/cart_details_bloc.dart';
import 'package:customer/presentation/cart_details/widget/bill_summary/bill_summary.dart';
import 'package:customer/presentation/cart_details/widget/bill_summary/bloc/bill_summary_bloc.dart';
import 'package:customer/presentation/shop_details/page/product_details/widget/Add_Controller/add_controller.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late BillSummaryBloc _billSummaryBloc;
  late CartDetailsBloc _cartDetailsBloc;

  @override
  void initState() {
    super.initState();
    _billSummaryBloc = BillSummaryBloc(
      cartDetailsUsecase: sl<CartDetailsUsecase>(),
    );
    _billSummaryBloc.add(GetBillSummaryEvent());

    _cartDetailsBloc = CartDetailsBloc(
      modifyCartUsecase: sl<ModifyCartUsecase>(),
    );
  }

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
          BlocProvider.value(
            value: _billSummaryBloc,
          ),
          BlocProvider.value(
            value: _cartDetailsBloc,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<CartDetailsBloc, CartDetailsState>(
              listener: (context, state) {
                if (state.status == CartDetailsStatus.success) {
                  sl<BillSummaryRefreshService>().refreshBillSummary();
                  sl<CartRefreshService>().refreshCart();
                }
              },
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                                    .map((productList) =>
                                        productList.productVariant)
                                    .toList()
                                    .map(
                                  (variantList) {
                                    return Column(
                                      children: variantList
                                          .map(
                                            (varian) => Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 20),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            varian.variantName
                                                                    .isNotEmpty
                                                                ? varian
                                                                    .variantName
                                                                : "No name",
                                                          ),
                                                          Text(
                                                            "₹${varian.price}",
                                                          ),
                                                        ],
                                                      ),
                                                      AddController(
                                                        decrementOnPress: () {
                                                          _cartDetailsBloc.add(
                                                            ModifyCartEvent(
                                                              params:
                                                                  AddToCartParams(
                                                                productId: varian
                                                                    .productId,
                                                                variantAddCartModel: [
                                                                  VariantAddCartModel(
                                                                      id: varian
                                                                          .id,
                                                                      quantity: varian.quantity >
                                                                              0
                                                                          ? varian.quantity -
                                                                              1
                                                                          : 0),
                                                                ],
                                                                optionAddCartModel: [],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        incrementOnPress: () {
                                                          _cartDetailsBloc.add(
                                                            ModifyCartEvent(
                                                              params:
                                                                  AddToCartParams(
                                                                productId: varian
                                                                    .productId,
                                                                variantAddCartModel: [
                                                                  VariantAddCartModel(
                                                                    id: varian
                                                                        .id,
                                                                    quantity:
                                                                        varian.quantity +
                                                                            1,
                                                                  ),
                                                                ],
                                                                optionAddCartModel: [],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        id: varian.id,
                                                        quantity:
                                                            varian.quantity,
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
                                    .map(
                                      (productList) {
                                        return productList.productOptions;
                                      },
                                    )
                                    .toList()
                                    .map(
                                      (optionsList) {
                                        return Column(
                                          children: optionsList.map(
                                            (options) {
                                              final parentProductList = state
                                                  .cartList!.cartData
                                                  .firstWhere(
                                                (product) => product
                                                    .productOptions
                                                    .any((o) =>
                                                        o.id ==
                                                        optionsList.first.id),
                                                orElse: () => state
                                                    .cartList!
                                                    .cartData
                                                    .first as CartDataModel,
                                              );
                                              final product_Id =
                                                  parentProductList
                                                      .productDetails.id;
                                              return Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 20),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              options.name
                                                                      .isNotEmpty
                                                                  ? options.name
                                                                  : "No name",
                                                            ),
                                                            Text(
                                                              "₹${options.price}",
                                                            ),
                                                          ],
                                                        ),
                                                        AddController(
                                                          id: options.id,
                                                          quantity:
                                                              options.quantity,
                                                          decrementOnPress: () {
                                                            _cartDetailsBloc
                                                                .add(
                                                              ModifyCartEvent(
                                                                params:
                                                                    AddToCartParams(
                                                                  productId:
                                                                      product_Id,
                                                                  variantAddCartModel: [],
                                                                  optionAddCartModel: [
                                                                    OptionAddCartModel(
                                                                      id: options
                                                                          .id,
                                                                      quantity: options.quantity >
                                                                              0
                                                                          ? options.quantity -
                                                                              1
                                                                          : 0,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          incrementOnPress: () {
                                                            _cartDetailsBloc
                                                                .add(
                                                              ModifyCartEvent(
                                                                params:
                                                                    AddToCartParams(
                                                                  productId:
                                                                      product_Id,
                                                                  variantAddCartModel: [],
                                                                  optionAddCartModel: [
                                                                    OptionAddCartModel(
                                                                      id: options
                                                                          .id,
                                                                      quantity:
                                                                          options.quantity +
                                                                              1,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ).toList(),
                                        );
                                      },
                                    )
                                    .toList(),
                                BlocProvider.value(
                                  value: _billSummaryBloc,
                                  child: BillSummary(),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                          minHeight: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border(
                                            left: BorderSide(
                                              color: const Color.fromARGB(
                                                  179, 193, 194, 193),
                                              width: 1,
                                              style: BorderStyle.solid,
                                            ),
                                            right: BorderSide(
                                              color: const Color.fromARGB(
                                                  179, 193, 194, 193),
                                              width: 1,
                                              style: BorderStyle.solid,
                                            ),
                                            top: BorderSide(
                                              color: const Color.fromARGB(
                                                  179, 193, 194, 193),
                                              width: 1,
                                              style: BorderStyle.solid,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            top: 5,
                                            bottom: 5,
                                          ),
                                          child: Row(
                                            spacing: 10,
                                            children: [
                                              Text(
                                                "+",
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColor.primaryColor,
                                                ),
                                              ),
                                              Text(
                                                "You saved ₹15 off on delivery",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color.fromARGB(
                                                      255, 28, 28, 28),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                          minHeight: 44,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border(
                                            left: BorderSide(
                                              color: const Color.fromARGB(
                                                  179, 193, 194, 193),
                                              width: 1,
                                              style: BorderStyle.solid,
                                            ),
                                            right: BorderSide(
                                              color: const Color.fromARGB(
                                                  179, 193, 194, 193),
                                              width: 1,
                                              style: BorderStyle.solid,
                                            ),
                                            top: BorderSide(
                                              color: const Color.fromARGB(
                                                  179, 193, 194, 193),
                                              width: 1,
                                              style: BorderStyle.solid,
                                            ),
                                          ),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            context.push('/coupons');
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                              top: 5,
                                              bottom: 5,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  spacing: 10,
                                                  children: [
                                                    Icon(Icons.payment,
                                                        size: 20),
                                                    Text(
                                                      "View all pyment coupons",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 28, 28, 28),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 16,
                                                  color: const Color.fromARGB(
                                                      255, 132, 132, 132),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                187, 193, 194, 193),
                                            width: 1,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            top: 5,
                                            bottom: 5,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      spacing: 10,
                                                      children: [
                                                        Icon(
                                                          Icons.point_of_sale,
                                                          size: 20,
                                                          color: const Color
                                                              .fromARGB(255,
                                                              105, 105, 105),
                                                        ),
                                                        Text(
                                                          "Apply referral code if any",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: const Color
                                                                .fromARGB(255,
                                                                28, 28, 28),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 16,
                                                      color:
                                                          const Color.fromARGB(
                                                        255,
                                                        132,
                                                        132,
                                                        132,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5,
                                                ),
                                                child: TextField(
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                  ),
                                                  decoration: InputDecoration(
                                                    constraints: BoxConstraints(
                                                      maxHeight: 35,
                                                      minHeight: 35,
                                                    ),
                                                    hintText: "Enter your code",
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 0,
                                                    ),
                                                    hintStyle: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              108,
                                                              108,
                                                              108),
                                                      fontSize: 13,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        6,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        6,
                                                      ),
                                                      borderSide: BorderSide(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 193, 194, 193),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        6,
                                                      ),
                                                      borderSide: BorderSide(
                                                        color: AppColor
                                                            .primaryColor,
                                                        width: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _showBottomSheetForAddress();
                                        },
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxHeight: 60,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border(
                                              left: BorderSide(
                                                color: const Color.fromARGB(
                                                    179, 193, 194, 193),
                                                width: 1,
                                                style: BorderStyle.solid,
                                              ),
                                              right: BorderSide(
                                                color: const Color.fromARGB(
                                                    179, 193, 194, 193),
                                                width: 1,
                                                style: BorderStyle.solid,
                                              ),
                                              top: BorderSide(
                                                color: const Color.fromARGB(
                                                    179, 193, 194, 193),
                                                width: 1,
                                                style: BorderStyle.solid,
                                              ),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Row(
                                                    spacing: 10,
                                                    children: [
                                                      Icon(
                                                        Icons.home_outlined,
                                                        size: 20,
                                                        color: Colors.black,
                                                      ),
                                                      Text(
                                                        "Delivery at home \nPlease select address",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _showBottomSheetForContact();
                                        },
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxHeight: 55,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border(
                                              left: BorderSide(
                                                color: const Color.fromARGB(
                                                    179, 193, 194, 193),
                                                width: 1,
                                                style: BorderStyle.solid,
                                              ),
                                              right: BorderSide(
                                                color: const Color.fromARGB(
                                                    179, 193, 194, 193),
                                                width: 1,
                                                style: BorderStyle.solid,
                                              ),
                                              top: BorderSide(
                                                color: const Color.fromARGB(
                                                    179, 193, 194, 193),
                                                width: 1,
                                                style: BorderStyle.solid,
                                              ),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Row(
                                                    spacing: 10,
                                                    children: [
                                                      Icon(
                                                        Icons.phone_outlined,
                                                        size: 20,
                                                        color: Colors.black,
                                                      ),
                                                      Text(
                                                        "+91993337889",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<BillSummaryBloc, BillSummaryState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          AppColor.primaryColor,
                        ),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (state.status == BillSummaryStatus.loading) return;
                        context.push('/billing');
                      },
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 100),
                        opacity:
                            state.status == BillSummaryStatus.loading ? 0.5 : 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                BlocProvider.value(
                                  value: _billSummaryBloc,
                                  child: BlocBuilder<BillSummaryBloc,
                                      BillSummaryState>(
                                    builder: (context, state) {
                                      return Text(
                                        _billSummaryBloc.state.cartDetails
                                                    ?.cartDetails.finalAmount !=
                                                null
                                            ? "₹${_billSummaryBloc.state.cartDetails?.cartDetails.finalAmount}"
                                            : "₹0",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Place Order",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Active Delivery Partners:0",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showBottomSheetForContact() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Center(
            child: Text('This is the bottom sheet content'),
          ),
        );
      },
    );
  }

  _showBottomSheetForAddress() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Center(
            child: Text('This is the bottom sheet content'),
          ),
        );
      },
    );
  }
}
