import 'dart:async';

import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/domain/address/entities/address_param.dart';
import 'package:customer/presentation/profile/pages/address_book/bloc/address_book_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../domain/address/usecases/get_adderss_list_usecase.dart';
import '../../../../../service_locator.dart';

class AddressBookPage extends StatefulWidget {
  final bool fromHome;
  const AddressBookPage({super.key, this.fromHome = false});

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

// Create a separate widget to wrap the BlocProvider
class AddressBookContent extends StatelessWidget {
  final bool fromHome;
  final TextEditingController searchController;
  final Function() onSearchChanged;
  final Map<int, int> _productOrderMap = {};
  int _orderCounter = 0;

  AddressBookContent({
    super.key,
    required this.fromHome,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search here...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  // The listener will handle the search
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
              // Manually trigger search in parent widget
              onSearchChanged();
            },
          ),
        ),
        Card(
          margin: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: InkWell(
            onTap: () {
              context.push('/address-book-map');
            },
            child: ListTile(
              leading: const Icon(
                Icons.location_on,
                color: AppColor.secondaryColor,
              ),
              title: Text(
                "Add New Address",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: BlocConsumer<AddressBookBloc, AddressList>(
            listener: (context, state) {
              if (state.status == AddressBookStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage ?? 'Unknown error',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    duration: Duration(seconds: 4),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.status == AddressBookStatus.loading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state.status == AddressBookStatus.failure) {
                return Center(child: Text('Error: ${state.errorMessage}'));
              }
              if (state.addressList != null && state.addressList.isNotEmpty) {
                for (var address in state.addressList) {
                  if (!_productOrderMap.containsKey(address.id)) {
                    _productOrderMap[address.id] = _orderCounter++;
                  }
                }
              }

              final sortedAddressList = state.addressList.isNotEmpty
                  ? List.from(state.addressList)
                  : [];
              if (sortedAddressList.isNotEmpty) {
                sortedAddressList.sort((a, b) {
                  final orderA = _productOrderMap[a.id] ?? 999999;
                  final orderB = _productOrderMap[b.id] ?? 999999;
                  return orderA.compareTo(orderB);
                });
              }
              return Column(
                children: [
                  if (state.status == AddressBookStatus.loading)
                    Center(child: CircularProgressIndicator()),
                  Expanded(
                    child: sortedAddressList.isEmpty
                        ? Center(
                            child: Text(
                              state.status == AddressBookStatus.success
                                  ? "No addresses found"
                                  : "",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: sortedAddressList.length,
                            itemBuilder: (context, index) {
                              final address = sortedAddressList[index];
                              return Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: ListTile(
                                  title: Text(
                                    address.receiverName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(address.address),
                                      Text(address.areaSector),
                                      Text("Phone: ${address.receiverContact}"),
                                    ],
                                  ),
                                  trailing: address.isDefault == 1
                                      ? Chip(label: Text("Default"))
                                      : null,
                                  onTap: () {
                                    if (state.status ==
                                        AddressBookStatus.success) {
                                      context.read<AddressBookBloc>().add(
                                            SetDefaultAddressEvent(
                                              addressId: address.id,
                                            ),
                                          );
                                    }
                                    if (state.status ==
                                        AddressBookStatus.success) {
                                      if (fromHome) {
                                        context.pop(address);
                                      }
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AddressBookPageState extends State<AddressBookPage> {
  final TextEditingController _searchController = TextEditingController();
  // Track the last search query and timer
  String _lastSearchQuery = "";
  Timer? _debounceTimer;
  late AddressBookBloc _addressBookBloc;

  @override
  void initState() {
    super.initState();
    _addressBookBloc = AddressBookBloc(addressusace: sl<AddressListUseCase>());
    _addressBookBloc.add(
      GetAddressListEvent(
        addressParam: AddressParam(
          searchValue: "",
        ),
      ),
    );
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final currentQuery = _searchController.text;

    // Cancel previous timer if it exists
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }

    // Set a new timer
    _debounceTimer = Timer(Duration(milliseconds: 300), () {
      if (mounted && (currentQuery != _lastSearchQuery)) {
        _lastSearchQuery = currentQuery;
        // Search triggered for: $currentQuery
        _addressBookBloc.add(
          GetAddressListEvent(
            addressParam: AddressParam(
              searchValue: currentQuery,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounceTimer?.cancel();
    _addressBookBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Enter your area or apartment name",
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
      body: BlocProvider.value(
        value: _addressBookBloc,
        child: AddressBookContent(
          fromHome: widget.fromHome,
          searchController: _searchController,
          onSearchChanged: _onSearchChanged,
        ),
      ),
    );
  }
}
