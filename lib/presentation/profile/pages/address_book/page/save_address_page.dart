import 'package:customer/data/models/address/create_address_model.dart';
import 'package:customer/domain/address/entities/create_address_entity.dart';
import 'package:customer/presentation/profile/pages/address_book/bloc/address_book_bloc.dart';
import 'package:customer/presentation/profile/pages/address_book/widget/text_field/custom_textfield.dart';
import 'package:customer/presentation/profile/pages/address_book/widget/type_tabs/type_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../domain/address/usecases/get_adderss_list_usecase.dart';
import '../../../../../service_locator.dart';

class SaveAddressPage extends StatefulWidget {
  const SaveAddressPage({
    super.key,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  final String address;
  final double latitude;
  final double longitude;

  @override
  State<SaveAddressPage> createState() => _SaveAddressPageState();
}

class _SaveAddressPageState extends State<SaveAddressPage> {
  final TextEditingController recivers_Controller = TextEditingController();
  final TextEditingController contact_Controller = TextEditingController();
  final TextEditingController address_Controller = TextEditingController();
  final TextEditingController area_Controller = TextEditingController();
  final _fromKey = GlobalKey<FormState>();
  String selectedType = "Home";
  @override
  void initState() {
    super.initState();
    address_Controller.text = widget.address;
    print("${widget.latitude} ${widget.longitude} Lat Long");
  }

  @override
  void dispose() {
    recivers_Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Enter Address Details",
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
        create: (context) => AddressBookBloc(
          addressusace: sl<AddressListUseCase>(),
        ),
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
            return Form(
              key: _fromKey,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TypeTabs(
                            initialTab: selectedType,
                            onTabChanged: (String newTab) {
                              setState(() {
                                selectedType = newTab;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomTextfield(
                            controller: recivers_Controller,
                            hinttext: "Recivers Name",
                            labeltext: "Enter Recivers Name",
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomTextfield(
                            controller: contact_Controller,
                            hinttext: "Recivers Contact",
                            labeltext: "Enter Recivers Contact",
                          ),
                          Text("May be used to assist delivery"),
                          SizedBox(
                            height: 20,
                          ),
                          CustomTextfield(
                            controller: address_Controller,
                            hinttext: "",
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomTextfield(
                            controller: area_Controller,
                            hinttext: "",
                            labeltext: "Area / Sector / Location",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_fromKey.currentState!.validate()) {
                          context.read<AddressBookBloc>().add(
                                CreateAddressEvent(
                                  createAddressEntity: CreateAddressModel(
                                    type: selectedType,
                                    receiverName: recivers_Controller.text,
                                    receiverContact:
                                        int.parse(contact_Controller.text),
                                    address: address_Controller.text,
                                    latitude: widget.latitude.toString(),
                                    longitude: widget.longitude.toString(),
                                    areaSector: area_Controller.text,
                                    isDefault: 1,
                                  ),
                                ),
                              );
                          if (state.status == AddressBookStatus.success) {
                            context.pop();
                            context.pop();
                          }
                        }
                      },
                      child: Text(
                        "Save Address",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
