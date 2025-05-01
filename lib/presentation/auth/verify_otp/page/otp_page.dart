import 'dart:async';

import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/core/utils/index.dart';
import 'package:customer/domain/auth/usecases/login_usecase.dart';
import 'package:customer/presentation/auth/login/bloc/login_bloc.dart';
import 'package:customer/presentation/auth/login/widget/Button/index.dart';
import 'package:customer/presentation/auth/verify_otp/bloc/verify_otp_bloc.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/auth/send_otp_model/send_otp_model.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required String number, SendOTPModel? sendOTPModel})
      : number = number,
        sendOTPModel = sendOTPModel;

  final String number;
  final SendOTPModel? sendOTPModel;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String otp = "";
  Timer? _countdownTimer;
  final _sendOtpdebounce = Duration(seconds: 60);
  int _remainingSeconds = 0;

  late LoginBloc _loginBloc;

  void _resendOTP() {
    // Reset the countdown
    _remainingSeconds = _sendOtpdebounce.inSeconds;

    _loginBloc.add(
      sendOTPEvent(
        number: widget.number,
      ),
    );

    _startCountdownTimer();
  }

  void _startCountdownTimer() {
    // Cancel existing timer if any
    _countdownTimer?.cancel();

    // Create a periodic timer that fires every second
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _countdownTimer?.cancel();
          _countdownTimer = null;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(sendOTPUseCase: sl<SendOTPUseCase>());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AlertMessage.show(
        context,
        title: 'OTP Sent',
        message: 'Test OTP: ${widget.sendOTPModel?.otp}',
        onOkPressed: () {},
        onCancelPressed: () {},
      );
    });
  }

  @override
  void dispose() {
    // Clean up timers when the widget is disposed
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: _loginBloc,
          ),
          BlocProvider(
            create: (context) => VerifyOtpBloc(
              verifyOTPUseCase: sl<VerifyOTPUseCase>(),
            ),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state.status == LoginStatus.failure) {
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
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height - 100,
                        left: 10,
                        right: 10,
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
                if (state.status == LoginStatus.success) {
                  AlertMessage.show(
                    context,
                    title: 'OTP Sent',
                    message: 'Test OTP: ${state.sendOTPModel?.otp}',
                    onOkPressed: () {},
                    onCancelPressed: () {},
                  );
                }
              },
            ),
          ],
          child: BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
            listener: (context, state) {
              if (state.status == VerifyOtpStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'OTP verified successfully',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height - 100,
                      left: 10,
                      right: 10,
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
                // Use GoRouter for navigation with path
                context.replace('/home');
              }
              if (state.status == VerifyOtpStatus.failure) {
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
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height - 100,
                      left: 10,
                      right: 10,
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 1.0],
                    colors: [
                      Color.fromRGBO(0, 102, 10, 1),
                      Color.fromRGBO(0, 102, 52, 0.74),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                      ),
                      Text(
                        "Enter OTP",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: "Enter the OTP sent to ",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              recognizer: null,
                            ),
                            TextSpan(
                              text: widget.number,
                              style: TextStyle(
                                color: AppColor.textColor,
                              ),
                              recognizer: null,
                            ),
                            TextSpan(
                              text: " Edit",
                              style: TextStyle(
                                color: AppColor.richTextColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.pop();
                                },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                      ),
                      OtpTextField(
                        numberOfFields: 4,
                        onCodeChanged: (String code) {},
                        onSubmit: (String verificationCode) {
                          setState(() {
                            otp = verificationCode;
                          });
                        },
                        cursorColor: AppColor.secondaryColor,
                        enabledBorderColor: Colors.white,
                        focusedBorderColor: AppColor.secondaryColor,
                        autoFocus: true,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: "Didn't get it?",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              recognizer: null,
                            ),
                            TextSpan(
                              text: _remainingSeconds > 0
                                  ? " ${_remainingSeconds}s"
                                  : "Resend",
                              style: TextStyle(
                                color: AppColor.richTextColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  if (_remainingSeconds <= 0) {
                                    _resendOTP();
                                  }
                                },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 200),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0, right: 0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "By joining Ordalane you agree with our",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                recognizer: null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0, right: 0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
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
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                      ),
                      ButtonComponent(
                        text: "Verify OTP",
                        onPressedEvent: () {
                          if (otp.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please enter OTP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height - 100,
                                  left: 10,
                                  right: 10,
                                ),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            return;
                          }
                          context.read<VerifyOtpBloc>().add(
                                VerifyOtpEvent(
                                  number: widget.number,
                                  otp: otp,
                                ),
                              );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
