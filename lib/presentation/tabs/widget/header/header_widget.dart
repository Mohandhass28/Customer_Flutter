import 'package:customer/core/bloc/default_address_header/bloc/address_header_bloc.dart';
import 'package:customer/core/config/assets/app_images.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/domain/address/usecases/get_default_address_usecase.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressHeaderBloc(
        getDfaultusecase: sl<GetDefaultAddressUseCase>(),
      )..add(AddressHeaderEvent()),
      child: BlocConsumer<AddressHeaderBloc, AddressHeaderState>(
        listener: (context, state) {
          if (state.status == AddressHeaderStatus.success) {}
          if (state.status == AddressHeaderStatus.failure) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(
            //       state.errorMessage ?? 'Unknown error',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 16,
            //       ),
            //     ),
            //     backgroundColor: Colors.red,
            //     behavior: SnackBarBehavior.floating,
            //     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            //     duration: Duration(seconds: 3),
            //   ),
            // );
          }
        },
        builder: (context, state) {
          // Use debugPrint for development logging
          debugPrint("Address state: ${state.address}");
          return Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: 70,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.0, .6],
                    colors: [
                      Color.fromARGB(255, 3, 57, 3),
                      Color.fromARGB(255, 3, 112, 3),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        height: 30,
                        AppImages.TP_logo, // Replace with your logo asset path
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 16),
                      margin: EdgeInsets.only(right: 16),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColor.secondaryColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              context.push('/profile');
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: 80,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.0, .6],
                    colors: [
                      Color.fromARGB(255, 3, 57, 3),
                      Color.fromARGB(255, 3, 112, 3),
                    ],
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to address book from home
                        context.push('/home-address-book');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.maps_home_work,
                            color: AppColor.richTextColor,
                            size: 18,
                          ),
                          Text(
                            state.address == null
                                ? "No Address"
                                : state.address!.type,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: [
                        Text(
                          state.address == null
                              ? "No Address"
                              : state.address!.address,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
