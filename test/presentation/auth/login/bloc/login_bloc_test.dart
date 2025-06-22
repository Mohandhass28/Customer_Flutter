import 'package:bloc_test/bloc_test.dart';
import 'package:customer/core/error/failures.dart';
import 'package:customer/data/models/auth/send_otp_model/send_otp_model.dart';
import 'package:customer/data/models/auth/send_otp_model/send_otp_params.dart';
import 'package:customer/domain/auth/usecases/login_usecase.dart';
import 'package:customer/presentation/auth/login/bloc/login_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SendOTPUseCase>()])
void main() {
  late LoginBloc loginBloc;
  late MockSendOTPUseCase mockSendOTPUseCase;

  setUp(() {
    mockSendOTPUseCase = MockSendOTPUseCase();
    loginBloc = LoginBloc(sendOTPUseCase: mockSendOTPUseCase);
  });

  tearDown(() {
    loginBloc.close();
  });

  test('initial state should be LoginState with status initial', () {
    // Assert
    expect(loginBloc.state.status, equals(LoginStatus.initial));
    expect(loginBloc.state.errorMessage, isNull);
    expect(loginBloc.state.sendOTPModel, isNull);
  });

  group('sendOTPEvent', () {
    final phoneNumber = '1234567890';
    final sendOTPModel = SendOTPModel(
      status: 1,
      message: 'OTP sent successfully',
      otp: 123456,
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [loading, success] when OTP is sent successfully',
      build: () {
        when(mockSendOTPUseCase(any))
            .thenAnswer((_) async => Right(sendOTPModel));
        return loginBloc;
      },
      act: (bloc) => bloc.add(sendOTPEvent(number: phoneNumber)),
      expect: () => [
        isA<LoginState>()
            .having((state) => state.status, 'status', LoginStatus.loading),
        isA<LoginState>()
            .having((state) => state.status, 'status', LoginStatus.success)
            .having((state) => state.sendOTPModel, 'sendOTPModel', sendOTPModel)
      ],
      verify: (_) {
        verify(mockSendOTPUseCase.call(any)).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [loading, failure] when OTP sending fails',
      build: () {
        final failure = ServerFailure(message: 'Failed to send OTP');
        when(mockSendOTPUseCase(any)).thenAnswer((_) async => Left(failure));
        return loginBloc;
      },
      act: (bloc) => bloc.add(sendOTPEvent(number: phoneNumber)),
      expect: () => [
        isA<LoginState>()
            .having((state) => state.status, 'status', LoginStatus.loading),
        isA<LoginState>()
            .having((state) => state.status, 'status', LoginStatus.failure)
            .having((state) => state.errorMessage, 'errorMessage',
                'Failed to send OTP')
      ],
      verify: (_) {
        verify(mockSendOTPUseCase.call(any)).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [loading, failure] when network error occurs',
      build: () {
        final failure = NetworkFailure(message: 'Network connection failed');
        when(mockSendOTPUseCase(any)).thenAnswer((_) async => Left(failure));
        return loginBloc;
      },
      act: (bloc) => bloc.add(sendOTPEvent(number: phoneNumber)),
      expect: () => [
        isA<LoginState>()
            .having((state) => state.status, 'status', LoginStatus.loading),
        isA<LoginState>()
            .having((state) => state.status, 'status', LoginStatus.failure)
            .having((state) => state.errorMessage, 'errorMessage',
                'Network connection failed')
      ],
      verify: (_) {
        verify(mockSendOTPUseCase.call(any)).called(1);
      },
    );
  });
}
