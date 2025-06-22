import 'package:customer/data/models/auth/send_otp_model/send_otp_model.dart';
import 'package:customer/domain/auth/usecases/login_usecase.dart';
import 'package:customer/presentation/auth/login/bloc/login_bloc.dart';
import 'package:customer/presentation/auth/login/page/number_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SendOTPUseCase>(), MockSpec<NavigatorObserver>()])
void main() {
  late MockSendOTPUseCase mockSendOTPUseCase;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockSendOTPUseCase = MockSendOTPUseCase();
    mockNavigatorObserver = MockNavigatorObserver();
  });

  Widget createTestableWidget() {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SizedBox(),
        ),
        GoRoute(
          path: '/otp',
          builder: (context, state) => const SizedBox(),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) {
        return BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            sendOTPUseCase: mockSendOTPUseCase,
          ),
          child: const NumberPage(),
        );
      },
    );
  }

  testWidgets('NumberPage should render correctly',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(createTestableWidget());

    // Assert
    expect(find.text('Lets start with phone'), findsOneWidget);
    expect(find.text('Enter your phone number to verify'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('Should show error when phone number is empty',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(createTestableWidget());

    // Act
    await tester.tap(find.text('Next'));
    await tester.pump();

    // Assert
    expect(find.text('Please enter your phone number'), findsOneWidget);
  });

  testWidgets('Should show error when phone number is less than 10 digits',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(createTestableWidget());

    // Act
    await tester.enterText(find.byType(TextFormField), '123456');
    await tester.tap(find.text('Next'));
    await tester.pump();

    // Assert
    expect(find.text('Please enter a valid phone number'), findsOneWidget);
  });

  testWidgets('Should call SendOTPUseCase when valid phone number is entered',
      (WidgetTester tester) async {
    // Arrange
    final sendOTPModel = SendOTPModel(
      status: 1,
      message: 'OTP sent successfully',
      otp: 123456,
    );
    when(mockSendOTPUseCase(any)).thenAnswer((_) async => Right(sendOTPModel));

    await tester.pumpWidget(createTestableWidget());

    // Act
    await tester.enterText(find.byType(TextFormField), '1234567890');
    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pump(
        const Duration(milliseconds: 300)); // Wait for the bloc to process

    // Assert
    verify(mockSendOTPUseCase.call(any)).called(1);
  });
}
