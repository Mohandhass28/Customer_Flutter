import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../../core/config/theme/app_color.dart';
// import 'package:logging/logging.dart'; // Uncomment and add to pubspec.yaml if needed

class AddressBookMapPage extends StatefulWidget {
  const AddressBookMapPage({super.key});

  @override
  State<AddressBookMapPage> createState() => _AddressBookMapPageState();
}

class _AddressBookMapPageState extends State<AddressBookMapPage> {
  // For logging - replace with proper logging when available
  void _log(String message) {
    // ignore: avoid_print
    print(message);
  }

  final TextEditingController _searchController = TextEditingController();
  LatLng? _currentPosition;
  // We'll use the MapController directly to get the center
  final MapController _mapController = MapController();
  // Track the current center of the map
  LatLng _currentMapCenter = LatLng(0, 0);
  // Store the address text
  String _addressText = "Move the map to see the address here";
  bool _isLoadingAddress = false;
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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

        // Move map to current location
        if (_currentPosition != null) {
          _mapController.move(_currentPosition!, 15);
        }
      } catch (e) {
        _log("Error getting location: $e");
      }
    } else {
      _log("Location permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Set Delivery Location",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              _map(),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search here...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColor.secondaryColor),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.secondaryColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withAlpha(26), // Equivalent to opacity 0.1
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        _getCurrentLocation();
                      },
                      icon: Icon(
                        Icons.location_searching,
                        color: AppColor.secondaryColor,
                      ),
                      label: Text(
                        "Use Current Location",
                        style: TextStyle(
                          color: AppColor.secondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 34,
                right: 0,
                top: 0,
                child: Icon(
                  color: AppColor.secondaryColor,
                  Icons.location_on,
                  size: 40,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withAlpha(26), // Equivalent to opacity 0.1
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: _isLoadingAddress
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColor.secondaryColor),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Getting address...",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Address",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColor.secondaryColor),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _addressText,
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final address = _addressText;

                if (address == "Unknown Address" ||
                    address.isEmpty ||
                    address == "Move the map to see the address here") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Could not determine address. Please try again.'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                // Show a loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Saving location...'),
                    duration: Duration(seconds: 1),
                  ),
                );

                // Navigate directly without async gap
                context.push('/save-address', extra: {
                  'address': address,
                  'latitude': _currentMapCenter.latitude,
                  'longitude': _currentMapCenter.longitude,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.secondaryColor,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Confirm Location',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LatLng getCurrentMapCenter() {
    _currentMapCenter = _mapController.camera.center;
    return _currentMapCenter;
  }

  Future<void> getAddressFromLatLng(double latitude, double longitude) async {
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
        setState(() {
          _addressText = address;
          _isLoadingAddress = false;
        });
      } else {
        print('No placemarks found for this location.');
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('StackTrace: $stackTrace');
      setState(() {
        _addressText = "Unknown Address";
        _isLoadingAddress = false;
      });
    }
    return;
  }

  Widget _map() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          minZoom: 5,
          maxZoom: 18,
          onTap: (tapPosition, point) {
            // Map tapped at point
            _log('Map tapped at: $point');
          },
          initialCenter: _currentPosition ?? const LatLng(0, 0),
          initialZoom: 15,
          onMapEvent: (event) {
            setState(() {
              _currentMapCenter = _mapController.camera.center;
            });

            if (event is MapEventMoveEnd) {
              setState(() {
                _isLoadingAddress = true;
              });

              getAddressFromLatLng(
                _currentMapCenter.latitude,
                _currentMapCenter.longitude,
              );
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.customer.app', // Your app package name
            tileProvider: CancellableNetworkTileProvider(),
          ),
          MarkerLayer(
            markers: [
              if (_currentPosition != null)
                Marker(
                  width: 40.0,
                  height: 40.0,
                  point: _currentPosition!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue
                          .withAlpha(77), // Equivalent to opacity 0.3
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
