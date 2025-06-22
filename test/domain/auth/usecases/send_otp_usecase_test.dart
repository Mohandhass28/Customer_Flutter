import 'package:customer/core/error/failures.dart';
import 'package:customer/data/models/auth/send_otp_model/send_otp_model.dart';
import 'package:customer/data/models/auth/send_otp_model/send_otp_params.dart';
import 'package:customer/domain/auth/repository/auth.dart';
import 'package:customer/domain/auth/usecases/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'auth_check_usecase_test.mocks.dart';

void main() {
  late SendOTPUseCase sendOTPUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    sendOTPUseCase = SendOTPUseCase(authRepository: mockAuthRepository);
  });

  group('SendOTPUseCase', () {
    final params = SendOTPParams(number: '1234567890');
    final sendOTPModel = SendOTPModel(
      status: 1,
      message: 'OTP sent successfully',
      otp: 123456,
    );

    test('should return SendOTP when repository call is successful', () async {
      // Arrange
      when(mockAuthRepository.sendOTP(any))
          .thenAnswer((_) async => Right(sendOTPModel));

      // Act
      final result = await sendOTPUseCase(params);

      // Assert
      expect(result, equals(Right<Failure, SendOTPModel>(sendOTPModel)));
      verify(mockAuthRepository.sendOTP(params));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ServerFailure when repository call fails', () async {
      // Arrange
      final failure = ServerFailure(message: 'Failed to send OTP');
      when(mockAuthRepository.sendOTP(any))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await sendOTPUseCase(params);

      // Assert
      expect(result, equals(Left<Failure, SendOTPModel>(failure)));
      verify(mockAuthRepository.sendOTP(params));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return NetworkFailure when there is a network error', () async {
      // Arrange
      final failure = NetworkFailure(message: 'Network connection failed');
      when(mockAuthRepository.sendOTP(any))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await sendOTPUseCase(params);

      // Assert
      expect(result, equals(Left<Failure, SendOTPModel>(failure)));
      verify(mockAuthRepository.sendOTP(params));
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
