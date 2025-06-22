import 'package:customer/core/error/failures.dart';
import 'package:customer/data/models/auth/send_otp_model/send_otp_model.dart';
import 'package:customer/data/models/auth/send_otp_model/send_otp_params.dart';
import 'package:customer/data/models/auth/verify_otp_model/user_model.dart';
import 'package:customer/data/models/auth/verify_otp_model/verify_otp.dart';
import 'package:customer/data/repository/auth/auth.dart';
import 'package:customer/data/source/auth/auth_api_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthApiService>()])
void main() {
  late AuthRepositoryImpl authRepository;
  late MockAuthApiService mockAuthApiService;

  setUp(() {
    mockAuthApiService = MockAuthApiService();
    authRepository = AuthRepositoryImpl(authApiService: mockAuthApiService);
  });

  group('sendOTP', () {
    final params = SendOTPParams(number: '1234567890');
    final sendOTPModel = SendOTPModel(
      status: 1,
      message: 'OTP sent successfully',
      otp: 123456,
    );

    test('should return SendOTP when API call is successful', () async {
      // Arrange
      when(mockAuthApiService.sendOTP(any))
          .thenAnswer((_) async => Right(sendOTPModel));

      // Act
      final result = await authRepository.sendOTP(params);

      // Assert
      expect(result, equals(Right<Failure, SendOTPModel>(sendOTPModel)));
      verify(mockAuthApiService.sendOTP(params));
      verifyNoMoreInteractions(mockAuthApiService);
    });

    test('should return failure when API call fails', () async {
      // Arrange
      final failure = ServerFailure(message: 'Failed to send OTP');
      when(mockAuthApiService.sendOTP(any))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await authRepository.sendOTP(params);

      // Assert
      expect(result, equals(Left<Failure, SendOTPModel>(failure)));
      verify(mockAuthApiService.sendOTP(params));
      verifyNoMoreInteractions(mockAuthApiService);
    });
  });

  group('verifyOTP', () {
    final params = VerifyOtpParams(
      phone: '1234567890',
      otp: '123456',
    );
    final userModel = UserModel(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
    );

    test('should return User when API call is successful', () async {
      // Arrange
      when(mockAuthApiService.verifyOTP(any))
          .thenAnswer((_) async => Right(userModel));

      // Act
      final result = await authRepository.verifyOTP(params);

      // Assert
      expect(result, equals(Right<Failure, UserModel>(userModel)));
      verify(mockAuthApiService.verifyOTP(params));
      verifyNoMoreInteractions(mockAuthApiService);
    });

    test('should return failure when API call fails', () async {
      // Arrange
      final failure = AuthFailure(message: 'Invalid OTP');
      when(mockAuthApiService.verifyOTP(any))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await authRepository.verifyOTP(params);

      // Assert
      expect(result, equals(Left<Failure, UserModel>(failure)));
      verify(mockAuthApiService.verifyOTP(params));
      verifyNoMoreInteractions(mockAuthApiService);
    });
  });

  group('authCheck', () {
    test('should return true when API call is successful', () async {
      // Arrange
      when(mockAuthApiService.authCheck())
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await authRepository.authCheck();

      // Assert
      expect(result, equals(const Right<Failure, bool>(true)));
      verify(mockAuthApiService.authCheck());
      verifyNoMoreInteractions(mockAuthApiService);
    });

    test('should return false when API call returns false', () async {
      // Arrange
      when(mockAuthApiService.authCheck())
          .thenAnswer((_) async => const Right(false));

      // Act
      final result = await authRepository.authCheck();

      // Assert
      expect(result, equals(const Right<Failure, bool>(false)));
      verify(mockAuthApiService.authCheck());
      verifyNoMoreInteractions(mockAuthApiService);
    });

    test('should return failure when API call fails', () async {
      // Arrange
      final failure = AuthFailure(message: 'Authentication failed');
      when(mockAuthApiService.authCheck())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await authRepository.authCheck();

      // Assert
      expect(result, equals(Left<Failure, bool>(failure)));
      verify(mockAuthApiService.authCheck());
      verifyNoMoreInteractions(mockAuthApiService);
    });
  });

  group('logout', () {
    test('should return true when API call is successful', () async {
      // Arrange
      when(mockAuthApiService.logout())
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await authRepository.logout();

      // Assert
      expect(result, equals(const Right<Failure, bool>(true)));
      verify(mockAuthApiService.logout());
      verifyNoMoreInteractions(mockAuthApiService);
    });

    test('should return failure when API call fails', () async {
      // Arrange
      final failure = ServerFailure(message: 'Logout failed');
      when(mockAuthApiService.logout())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await authRepository.logout();

      // Assert
      expect(result, equals(Left<Failure, bool>(failure)));
      verify(mockAuthApiService.logout());
      verifyNoMoreInteractions(mockAuthApiService);
    });
  });
}
