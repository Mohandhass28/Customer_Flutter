import 'package:customer/core/refresh_services/cart_refresh_service.dart';
import 'package:customer/domain/cart/usecases/cart_details_usecase.dart';
import 'package:customer/presentation/cart_details/widget/bill_summary/bloc/bill_summary_bloc.dart';
import 'package:customer/presentation/cart_details/widget/bill_summary/widget/shimmer_bill_summary.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillSummary extends StatefulWidget {
  const BillSummary({super.key});

  @override
  State<BillSummary> createState() => _BillSummaryState();
}

class _BillSummaryState extends State<BillSummary> {
  bool showDeliveryFee = false;
  bool showOtherCharges = false;
  bool showTaxes = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<CartRefreshService>().refreshCart();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _taxes(BillSummaryState state, BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Taxes",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            IconButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(
                  EdgeInsets.zero,
                ),
              ),
              icon: Icon(
                showDeliveryFee ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                size: 28,
                color: const Color.fromARGB(186, 52, 51, 51),
              ),
              onPressed: () {
                setState(() {
                  showTaxes = !showTaxes;
                });
              },
            ),
          ],
        ),
        if (showTaxes)
          Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.payments_outlined),
                    Text(
                      "CGST",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Text(
                  state.cartDetails!.cartDetails.cgstTotal.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.payments_outlined),
                    Text(
                      "SGST",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Text(
                  state.cartDetails!.cartDetails.sgstTotal.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.payments_outlined),
                    Text(
                      "SESS",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Text(
                  state.cartDetails!.cartDetails.cessTotal.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ]),
      ],
    );
  }

  Widget _deliveryFee(BillSummaryState state, BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.fire_truck_rounded,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Delivery Fee for ${state.cartDetails!.cartDetails.deliveryDistanceHeavyProducts} km with heavy Vehicle",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(
            state.cartDetails!.cartDetails.deliveryFeesHeavyProducts.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.delivery_dining,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Delivery Fee for ${state.cartDetails!.cartDetails.deliveryDistanceNormalProducts} km with normal Vehicle",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(
            state.cartDetails!.cartDetails.deliveryFeesNormalProducts
                .toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _otherCharges(BillSummaryState state, BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 10,
              children: [
                Icon(Icons.mobile_screen_share_outlined),
                Text(
                  "Platform charges",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Text(
              state.cartDetails!.cartDetails.platformFees.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 10,
              children: [
                Icon(Icons.money),
                Text(
                  "Payment Gateway charges",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Text(
              state.cartDetails!.cartDetails.paymentGatewayCharges.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<BillSummaryBloc>(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<BillSummaryBloc, BillSummaryState>(
            builder: (context, state) {
              if (state.status == BillSummaryStatus.loading) {
                // Return the shimmer effect when loading
                return ShimmerEffect(
                  child: ShimmerBillSummary(),
                );
              }
              if (state.status == BillSummaryStatus.failure) {
                return Center(
                  child: Text(state.errorMessage ?? "Unknown error"),
                );
              }
              if (state.cartDetails == null) {
                return Center(
                  child: Text("No cart details found"),
                );
              }
              // Return the actual content when loaded
              return Padding(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bill Summary",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                            ),
                            Text(
                              "Item Total",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          state.cartDetails!.cartDetails.itemTotal.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "Delivery Fee",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets>(
                              EdgeInsets.zero,
                            ),
                          ),
                          icon: Icon(
                            showDeliveryFee
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            size: 28,
                            color: const Color.fromARGB(186, 52, 51, 51),
                          ),
                          onPressed: () {
                            setState(() {
                              showDeliveryFee = !showDeliveryFee;
                            });
                          },
                        ),
                      ],
                    ),
                    if (showDeliveryFee) _deliveryFee(state, context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text("Tax and other charges"),
                            IconButton(
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all<EdgeInsets>(
                                  EdgeInsets.zero,
                                ),
                              ),
                              icon: Icon(
                                showDeliveryFee
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                size: 28,
                                color: const Color.fromARGB(186, 52, 51, 51),
                              ),
                              onPressed: () {
                                setState(() {
                                  showOtherCharges = !showOtherCharges;
                                });
                              },
                            ),
                          ],
                        ),
                        Text(
                          state.cartDetails!.cartDetails.gstTotal.toString(),
                        ),
                      ],
                    ),
                    if (showOtherCharges) _otherCharges(state, context),
                    if (showOtherCharges) _taxes(state, context),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Grand Total",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          state.cartDetails!.cartDetails.finalAmount.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Simple shimmer effect wrapper
class ShimmerEffect extends StatefulWidget {
  final Widget child;

  const ShimmerEffect({Key? key, required this.child}) : super(key: key);

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: const [0.1, 0.3, 0.4],
              begin: Alignment(_animation.value - 1, -0.5),
              end: Alignment(_animation.value + 1, 0.5),
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
