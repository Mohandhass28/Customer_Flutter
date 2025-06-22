import 'package:customer/core/error/failures.dart';
import 'package:customer/data/models/auth/verify_otp_model/user_model.dart';
import 'package:customer/data/models/auth/verify_otp_model/verify_otp.dart';
import 'package:customer/domain/auth/repository/auth.dart';
import 'package:customer/domain/auth/usecases/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'auth_check_usecase_test.mocks.dart';

void main() {
  late VerifyOTPUseCase verifyOTPUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    verifyOTPUseCase = VerifyOTPUseCase(authRepository: mockAuthRepository);
  });

  group('VerifyOTPUseCase', () {
    final params = VerifyOtpParams(
      phone: '1234567890',
      otp: '123456',
    );
    final userModel = UserModel(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
    );

    test('should return User when repository call is successful', () async {
      // Arrange
      when(mockAuthRepository.verifyOTP(any))
          .thenAnswer((_) async => Right(userModel));

      // Act
      final result = await verifyOTPUseCase(params);

      // Assert
      expect(result, equals(Right<Failure, UserModel>(userModel)));
      verify(mockAuthRepository.verifyOTP(params));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthFailure when repository call fails', () async {
      // Arrange
      final failure = AuthFailure(message: 'Invalid OTP');
      when(mockAuthRepository.verifyOTP(any))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await verifyOTPUseCase(params);

      // Assert
      expect(result, equals(Left<Failure, UserModel>(failure)));
      verify(mockAuthRepository.verifyOTP(params));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return NetworkFailure when there is a network error', () async {
      // Arrange
      final failure = NetworkFailure(message: 'Network connection failed');
      when(mockAuthRepository.verifyOTP(any))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await verifyOTPUseCase(params);

      // Assert
      expect(result, equals(Left<Failure, UserModel>(failure)));
      verify(mockAuthRepository.verifyOTP(params));
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
