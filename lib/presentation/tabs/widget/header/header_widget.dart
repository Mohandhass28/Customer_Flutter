import 'dart:async';

import 'package:customer/core/bloc/default_address_header/bloc/address_header_bloc.dart';
import 'package:customer/core/config/assets/app_images.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/core/refresh_services/cart_visibility_service.dart';
import 'package:customer/data/models/address/create_address_model.dart';
import 'package:customer/domain/address/usecases/get_adderss_list_usecase.dart';
import 'package:customer/domain/address/usecases/get_default_address_usecase.dart';
import 'package:customer/presentation/profile/pages/user_details/bloc/profile_bloc.dart';
import 'package:customer/presentation/tabs/bloc/tabs_bloc.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HeaderWidget extends StatefulWidget {
  // Use a regular constructor instead of const to allow for UniqueKey
  HeaderWidget({Key? key}) : super(key: UniqueKey());

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget>
    with SingleTickerProviderStateMixin {
  // Removed unused _isLoadingAddress field
  LatLng? _currentPosition;
  late TabsBloc _tabsBloc;
  late ProfileBloc _profileBloc;
  bool isCalled = false;
  late AnimationController _animationController;
  bool _cartVisible = true;
  late StreamSubscription _hideCartSubscription;
  late StreamSubscription _showCartSubscription;
  void _showCart() {
    if (!_cartVisible) {
      _cartVisible = true;
      // Use animateTo instead of forward for more reliable animation
      _animationController.animateTo(1.0,
          duration: const Duration(milliseconds: 200));
    }
  }

  void _hideCart() {
    if (_cartVisible) {
      _cartVisible = false;
      // Use animateTo instead of reverse for more reliable animation
      _animationController.animateTo(0.0,
          duration: const Duration(milliseconds: 200));
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint("initState: Initializing HeaderWidget");
    _getCurrentLocation();
    _tabsBloc = TabsBloc(addressusace: sl<AddressListUseCase>());
    isCalled = false; // Reset isCalled flag
    debugPrint("initState: isCalled set to false");
    _profileBloc = sl<ProfileBloc>()..add(GetProfileEvent());

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 1.0,
      value: 1,
    );

    _showCartSubscription = sl<CartVisibilityService>().showCartStream.listen(
      (event) {
        if (_cartVisible == false) {
          setState(() {
            _showCart();
          });
        }
      },
    );

    _hideCartSubscription = sl<CartVisibilityService>().hideCartStream.listen(
      (event) {
        if (_cartVisible == true) {
          setState(() {
            _hideCart();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    debugPrint("dispose: Disposing HeaderWidget");
    // Clean up resources
    _tabsBloc.close();
    _hideCartSubscription.cancel();
    _showCartSubscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  // Static flag to prevent multiple simultaneous location requests
  static bool _isGettingLocation = false;

  Future<void> _getCurrentLocation() async {
    // Check if we're already getting location
    if (_isGettingLocation) {
      debugPrint("_getCurrentLocation: Already getting location, skipping");
      return;
    }

    _isGettingLocation = true;
    debugPrint("_getCurrentLocation: Starting to get location");

    try {
      // Request location permission
      final status = await Permission.location.request();
      debugPrint(
          "_getCurrentLocation: Permission status: ${status.toString()}");

      if (status.isGranted) {
        try {
          debugPrint(
              "_getCurrentLocation: Permission granted, getting position");
          // Get current position
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          debugPrint(
              "_getCurrentLocation: Position obtained: ${position.latitude}, ${position.longitude}");

          // Check if widget is still mounted before calling setState
          if (mounted) {
            debugPrint(
                "_getCurrentLocation: Widget is mounted, updating state");
            setState(() {
              _currentPosition = LatLng(position.latitude, position.longitude);
            });
            debugPrint("_getCurrentLocation: State updated with position");
          } else {
            debugPrint(
                "_getCurrentLocation: Widget is not mounted, cannot update state");
          }
        } catch (e) {
          debugPrint("_getCurrentLocation: Error getting location: $e");
        }
      } else {
        debugPrint("_getCurrentLocation: Location permission denied");
      }
    } finally {
      // Reset the flag when done
      _isGettingLocation = false;
    }
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    String addressText = "";
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      debugPrint('Placemarks: $placemarks');

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Use null-aware operators to prevent null issues
        String address = '${place.street ?? ''}, '
            '${place.subLocality ?? ''}, '
            '${place.locality ?? ''}, '
            '${place.administrativeArea ?? ''}, '
            '${place.country ?? ''}';

        debugPrint('Address: $address');
        addressText = address;
      } else {
        debugPrint('No placemarks found for this location.');
      }
    } catch (e, stackTrace) {
      debugPrint('Error: $e');
      debugPrint('StackTrace: $stackTrace');
      addressText = "Unknown Address";
    }
    return addressText;
  }

  // Use a static flag to prevent multiple address creations across widget instances
  static bool _addressCreationInProgress = false;

  Future<void> setDefaultAddress() async {
    // Check if widget is still mounted before proceeding
    if (!mounted) {
      debugPrint("setDefaultAddress: Widget not mounted, returning");
      return;
    }

    // Check if address creation is already in progress
    if (_addressCreationInProgress) {
      debugPrint(
          "setDefaultAddress: Address creation already in progress, returning");
      return;
    }

    // Set the flag to prevent duplicate calls
    _addressCreationInProgress = true;

    try {
      debugPrint(
          "setDefaultAddress: Current position is ${_currentPosition != null ? 'available' : 'null'}");

      if (_currentPosition != null) {
        debugPrint("setDefaultAddress: Getting address from lat/lng");
        final address = await getAddressFromLatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );

        // Check again if widget is still mounted after async operation
        if (!mounted) {
          debugPrint(
              "setDefaultAddress: Widget not mounted after async operation, returning");
          return;
        }

        debugPrint("setDefaultAddress: Adding event to TabsBloc");
        _tabsBloc.add(
          setDefaultAddressEvent(
            params: CreateAddressModel(
              type: "Home",
              receiverName: "Customer",
              receiverContact: int.parse(
                  _profileBloc.state.customerDetails?.data.phone ??
                      "1234567789"),
              address: address,
              latitude: _currentPosition!.latitude.toString(),
              longitude: _currentPosition!.longitude.toString(),
              areaSector: "Home",
              isDefault: 1,
            ),
          ),
        );
        debugPrint("setDefaultAddress: Event added to TabsBloc");
      } else {
        debugPrint(
            "setDefaultAddress: Current position is null, cannot add address");
      }
    } finally {
      // Reset the flag after a delay to allow the operation to complete
      Future.delayed(Duration(seconds: 5), () {
        _addressCreationInProgress = false;
        debugPrint("setDefaultAddress: Reset address creation flag");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset(0, 0),
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: SizeTransition(
            sizeFactor: _animationController,
            // axisAlignment: -1.0,
            child: _getheader(context),
          ),
        );
      },
    );
  }

  Widget _getheader(BuildContext context) {
    // Use BlocProvider.value if the bloc is already created elsewhere
    // Or create a new one with a unique ID
    final addressHeaderBloc = AddressHeaderBloc(
      getDfaultusecase: sl<GetDefaultAddressUseCase>(),
    )..add(AddressHeaderEvent());

    return BlocProvider(
      create: (context) => addressHeaderBloc,
      child: BlocConsumer<AddressHeaderBloc, AddressHeaderState>(
        listener: (context, state) {
          if (state.status == AddressHeaderStatus.success) {}
          if (state.status == AddressHeaderStatus.failure) {}
        },
        builder: (context, state) {
          debugPrint("Address state: ${state.address}");
          debugPrint("state: ${state.status}");
          debugPrint(
              "Build method: state.address is ${state.address == null ? 'null' : 'not null'}, isCalled is $isCalled, _currentPosition is ${_currentPosition != null ? 'available' : 'null'}");
          if (state.address == null && !isCalled && _currentPosition != null) {
            debugPrint(
                "Build method: All conditions met, setting isCalled to true and calling setDefaultAddress()");
            isCalled = true;
            // setDefaultAddress();
          } else if (state.address == null && !isCalled) {
            debugPrint(
                "Build method: Address is null and isCalled is false, but _currentPosition is null. Waiting for location...");
          } else {
            debugPrint(
                "Build method: Condition not met, not calling setDefaultAddress()");
          }

          return Column(
            children: [
              Container(
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
                padding: const EdgeInsets.only(
                  left: 14,
                  top: 16,
                  bottom: 16,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to address book from home
                        context.push('/home-address-book');
                      },
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.80,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                            // SizedBox(height: 8),
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
                                  maxLines: 2,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
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
            ],
          );
        },
      ),
    );
  }
}
