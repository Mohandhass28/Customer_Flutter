import 'package:customer/core/bloc/cart_list_bloc/bloc/cart_list_bloc.dart';
import 'package:customer/presentation/cart_details/widget/bill_summary/bloc/bill_summary_bloc.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BottomCart extends StatefulWidget {
  const BottomCart({super.key});

  @override
  State<BottomCart> createState() => _BottomCartState();
}

class _BottomCartState extends State<BottomCart> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: sl<CartListBloc>(),
        ),
        BlocProvider.value(
          value: sl<BillSummaryBloc>()
            ..add(
              GetBillSummaryEvent(),
            ),
        ),
      ],
      child: BlocBuilder<CartListBloc, CartListState>(
        builder: (context, CartListstate) {
          if (CartListstate.status == CartListStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (CartListstate.cartList != null &&
              CartListstate.cartList!.cartData.isNotEmpty) {
            return Material(
              color: const Color.fromARGB(0, 255, 0, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.2, 1],
                      colors: const [
                        Color(0xFF016735),
                        Color(0xFF539472),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: InkWell(
                    onTap: () {
                      context.push('/cart');
                    },
                    splashColor: Colors.white.withAlpha(76),
                    highlightColor: Colors.white.withAlpha(25),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: BlocBuilder<BillSummaryBloc, BillSummaryState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${state.cartDetails?.productDetails.length ?? 0} Items",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  "₹${state.cartDetails?.cartDetails.finalAmount ?? 0} View Cart",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
