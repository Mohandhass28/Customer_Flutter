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

class _AddressBookPageState extends State<AddressBookPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    // Debounce search to avoid too many API calls
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<AddressBookBloc>().add(
              GetAddressListEvent(
                addressParam: AddressParam(
                  searchVlaue: _searchController.text,
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
      body: BlocProvider(
        create: (context) {
          return AddressBookBloc(addressusace: sl<GetAddressListUseCase>())
            ..add(
              GetAddressListEvent(
                addressParam: AddressParam(
                  searchVlaue: _searchController.text,
                ),
              ),
            );
        },
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
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == AddressBookStatus.loading) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search here...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
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
                      // The listener will handle the search
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 17),
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      ),
                      onPressed: () {
                        context.push('/address-book-map');
                      },
                      label: Text(
                        "Add New Address",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      icon: Icon(
                        Icons.location_searching,
                        color: AppColor.secondaryColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: state.addressList.isEmpty
                      ? Center(
                          child: Text(
                            state.status == AddressBookStatus.success
                                ? "No addresses found"
                                : "",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.addressList.length,
                          itemBuilder: (context, index) {
                            final address = state.addressList[index];
                            return Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ListTile(
                                title: Text(
                                  address.receiverName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  if (widget.fromHome) {
                                    context.read<AddressBookBloc>().add(
                                          SetDefaultAddressEvent(
                                            addressId: address.id,
                                          ),
                                        );
                                    if (state.status ==
                                        AddressBookStatus.success) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Default address set successfully',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
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
    );
  }
}
