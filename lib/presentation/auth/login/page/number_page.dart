import 'package:customer/presentation/auth/login/bloc/login_bloc.dart';
import 'package:customer/presentation/auth/login/widget/Button/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberPage extends StatefulWidget {
  const NumberPage({super.key});

  @override
  State<NumberPage> createState() => _NumberPageState();
}

class _NumberPageState extends State<NumberPage> {
  final TextEditingController _numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.sendOTPModel?.message ?? 'Unknown error'),
            ),
          );
        }
        if (state.status == LoginStatus.failure) {
          print(state.errorMessage);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Unknown error'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, .6],
                colors: [
                  Color.fromRGBO(0, 102, 10, 1),
                  Color.fromRGBO(0, 102, 52, 0.74),
                ],
              )),
              alignment: Alignment.center,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 100,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Lets start with phone",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Enter your phone number to verify",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 100,
                            right: 100,
                            top: 20,
                          ),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _numberController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              cursorColor: Colors.white,
                              cursorWidth: 2,
                              decoration: InputDecoration(
                                prefixText: "+91",
                                prefixStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                                focusColor: Colors.white,
                                hintText: "",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.4,
                                  ),
                                ),
                                border: MaterialStateUnderlineInputBorder
                                    .resolveWith((states) {
                                  return UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1.4,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 130),
                        Padding(
                          padding: const EdgeInsets.only(left: 70, right: 70),
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "By joining Ordalane you agree with our",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    recognizer: null,
                                  ),
                                  TextSpan(
                                    text: " Terms and Conditions ",
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 212, 1, 1),
                                      fontSize: 14,
                                    ),
                                    recognizer: null,
                                  ),
                                  TextSpan(
                                    text: "and",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    recognizer: null,
                                  ),
                                  TextSpan(
                                    text: " Privacy Policy",
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 212, 1, 1),
                                      fontSize: 14,
                                    ),
                                    recognizer: null,
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(height: 20),
                        ButtonComponent(
                          onPressedEvent: () {
                            context.read<LoginBloc>().add(
                                  sendOTPEvent(
                                    number: _numberController.text,
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
