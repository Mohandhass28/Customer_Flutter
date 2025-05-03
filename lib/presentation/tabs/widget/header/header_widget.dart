import 'package:customer/core/bloc/default_address_header/bloc/address_header_bloc.dart';
import 'package:customer/core/config/assets/app_images.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/core/refresh_services/address/address_refresh_service.dart';
import 'package:customer/data/models/address/create_address_model.dart';
import 'package:customer/domain/address/entities/create_address_entity.dart';
import 'package:customer/domain/address/usecases/get_adderss_list_usecase.dart';
import 'package:customer/domain/address/usecases/get_default_address_usecase.dart';
import 'package:customer/presentation/tabs/bloc/tabs_bloc.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  bool _isLoadingAddress = false;
  LatLng? _currentPosition;
  late TabsBloc _tabsBloc;
  bool isCalled = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _tabsBloc = TabsBloc(addressusace: sl<AddressListUseCase>());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    // Request location permission
    final status = await Permission.location.request();

    if (status.isGranted) {
      try {
        // Get current position
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
        });
      } catch (e) {
        print("Error getting location: $e");
      }
    } else {
      print("Location permission denied");
    }
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    String addressText = "";
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      print('Placemarks: $placemarks');

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Use null-aware operators to prevent null issues
        String address = '${place.street ?? ''}, '
            '${place.subLocality ?? ''}, '
            '${place.locality ?? ''}, '
            '${place.administrativeArea ?? ''}, '
            '${place.country ?? ''}';

        print('Address: $address');
        addressText = address;
        _isLoadingAddress = false;
      } else {
        print('No placemarks found for this location.');
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('StackTrace: $stackTrace');
      addressText = "Unknown Address";
      _isLoadingAddress = false;
    }
    return addressText;
  }

  Future<void> setDefaultAddress() async {
    if (_currentPosition != null) {
      final address = await getAddressFromLatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      _tabsBloc.add(
        setDefaultAddressEvent(
          params: CreateAddressModel(
            type: "Home",
            receiverName: "Customer",
            receiverContact: 1234123412,
            address: address,
            latitude: _currentPosition!.latitude.toString(),
            longitude: _currentPosition!.longitude.toString(),
            areaSector: "Home",
            isDefault: 1,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressHeaderBloc(
        getDfaultusecase: sl<GetDefaultAddressUseCase>(),
      )..add(AddressHeaderEvent()),
      child: BlocConsumer<AddressHeaderBloc, AddressHeaderState>(
        listener: (context, state) {
          if (state.status == AddressHeaderStatus.success) {}
          if (state.status == AddressHeaderStatus.failure) {}
        },
        builder: (context, state) {
          debugPrint("Address state: ${state.address}");
          debugPrint("state: ${state.status}");
          if (state.address == null && !isCalled) {
            setDefaultAddress();
            isCalled = true;
          }

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
                  maxHeight: 90,
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
                          maxLines: 2,
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
