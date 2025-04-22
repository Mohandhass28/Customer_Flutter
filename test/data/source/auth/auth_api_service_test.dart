import 'package:customer/core/error/failures.dart';
import 'package:customer/core/network/dio_client.dart';
import 'package:customer/data/models/auth/send_otp_model/send_otp_model.dart';
import 'package:customer/data/models/auth/verify_otp_model/verify_otp.dart';
import 'package:customer/data/models/auth/verify_otp_model/login_response.dart';
import 'package:customer/data/models/auth/verify_otp_model/user_model.dart';
import 'package:customer/data/source/auth/auth_api_service.dart';
import 'package:customer/domain/auth/entities/send_otp.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_api_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DioClient>(), MockSpec<SharedPreferences>()])
void main() {
  late AuthApiServiceImpl authApiService;
  late MockDioClient mockDioClient;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockDioClient = MockDioClient();
    mockSharedPreferences = MockSharedPreferences();
    authApiService = AuthApiServiceImpl(
      dioClient: mockDioClient,
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('sendOTP', () {
    final loginParams = LoginParams(
      phone: '1234567890',
    );

    final sendOTPResponse = Response(
      data: {
        'status': 1,
        'msg': 'OTP sent successfully',
        'payload': {
          'otp': '123456',
        },
      },
      statusCode: 200,
      requestOptions: RequestOptions(),
    );

    test('should return SendOTP when the call is successful', () async {
      // Arrange
      when(mockDioClient.post(
        endpoint: anyNamed('endpoint'),
        params: anyNamed('params'),
      )).thenAnswer((_) async => sendOTPResponse);

      // Act
      final result = await authApiService.sendOTP(loginParams);

      // Assert
      expect(result, isA<Right<Failure, SendOTP>>());
      verify(mockDioClient.post(
        endpoint: 'customer/sendOtp',
        params: loginParams.toJson(),
      ));
    });

    test('should return ServerFailure when the call is unsuccessful', () async {
      // Arrange
      when(mockDioClient.post(
        endpoint: anyNamed('endpoint'),
        params: anyNamed('params'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(),
        response: Response(
          statusCode: 400,
          data: {'message': 'Invalid phone number'},
          requestOptions: RequestOptions(),
        ),
      ));

      // Act
      final result = await authApiService.sendOTP(loginParams);

      // Assert
      expect(result, isA<Left<Failure, SendOTP>>());
      verify(mockDioClient.post(
        endpoint: 'customer/sendOtp',
        params: loginParams.toJson(),
      ));
    });

    test('should return NetworkFailure when there is a network error',
        () async {
      // Arrange
      when(mockDioClient.post(
        endpoint: anyNamed('endpoint'),
        params: anyNamed('params'),
      )).thenThrow(DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(),
      ));

      // Act
      final result = await authApiService.sendOTP(loginParams);

      // Assert
      expect(result, isA<Left<Failure, SendOTP>>());
      expect(
        (result as Left).value,
        isA<NetworkFailure>(),
      );
      verify(mockDioClient.post(
        endpoint: 'customer/sendOtp',
        params: loginParams.toJson(),
      ));
    });
  });

  group('verifyOTP', () {
    final loginParams = LoginParams(
      phone: '1234567890',
      otp: '123456',
    );

    final verifyOTPResponse = Response(
      data: {
        'status': 1,
        'msg': 'Logged in successfully!',
        'payload': {
          'user': {
            'id': 320,
            'name': 'Test User',
            'email': 'test@example.com',
            'email_verified_at': '',
            'phone': '1234567890',
            'gender': 'Male',
            'status': true,
          },
          'token': 'test_token',
          'tokenType': 'Authorization',
        },
      },
      statusCode: 200,
      requestOptions: RequestOptions(),
    );

    test('should return UserModel when the call is successful', () async {
      // Arrange
      when(mockDioClient.post(
        endpoint: anyNamed('endpoint'),
        params: anyNamed('params'),
      )).thenAnswer((_) async => verifyOTPResponse);

      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      // Act
      final result = await authApiService.verifyOTP(loginParams);

      // Assert
      expect(result, isA<Right<Failure, UserModel>>());
      verify(mockDioClient.post(
        endpoint: '/auth/verify-otp',
        params: loginParams.toJson(),
      ));
      verify(mockSharedPreferences.setString('token', 'test_token'));
    });

    test('should return AuthFailure when the call is unsuccessful', () async {
      // Arrange
      when(mockDioClient.post(
        endpoint: anyNamed('endpoint'),
        params: anyNamed('params'),
      )).thenAnswer((_) async => Response(
            data: {
              'status': 0,
              'msg': 'Invalid OTP',
            },
            statusCode: 400,
            requestOptions: RequestOptions(),
          ));

      // Act
      final result = await authApiService.verifyOTP(loginParams);

      // Assert
      expect(result, isA<Left<Failure, UserModel>>());
      expect(
        (result as Left).value,
        isA<AuthFailure>(),
      );
      verify(mockDioClient.post(
        endpoint: '/auth/verify-otp',
        params: loginParams.toJson(),
      ));
      verifyNever(mockSharedPreferences.setString(any, any));
    });

    test('should return NetworkFailure when there is a network error',
        () async {
      // Arrange
      when(mockDioClient.post(
        endpoint: anyNamed('endpoint'),
        params: anyNamed('params'),
      )).thenThrow(DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(),
      ));

      // Act
      final result = await authApiService.verifyOTP(loginParams);

      // Assert
      expect(result, isA<Left<Failure, UserModel>>());
      expect(
        (result as Left).value,
        isA<NetworkFailure>(),
      );
      verify(mockDioClient.post(
        endpoint: '/auth/verify-otp',
        params: loginParams.toJson(),
      ));
      verifyNever(mockSharedPreferences.setString(any, any));
    });
  });

  group('authCheck', () {
    test('should return false when token is null', () async {
      // Arrange
      when(mockSharedPreferences.getString('token')).thenReturn(null);

      // Act
      final result = await authApiService.authCheck();

      // Assert
      expect(result, equals(const Right<Failure, bool>(false)));
      verify(mockSharedPreferences.getString('token'));
      verifyNever(mockDioClient.get(endpoint: anyNamed('endpoint')));
    });

    test('should return false when token is empty', () async {
      // Arrange
      when(mockSharedPreferences.getString('token')).thenReturn('');

      // Act
      final result = await authApiService.authCheck();

      // Assert
      expect(result, equals(const Right<Failure, bool>(false)));
      verify(mockSharedPreferences.getString('token'));
      verifyNever(mockDioClient.get(endpoint: anyNamed('endpoint')));
    });

    test('should return true when token is valid', () async {
      // Arrange
      when(mockSharedPreferences.getString('token')).thenReturn('valid_token');
      when(mockDioClient.get(endpoint: anyNamed('endpoint')))
          .thenAnswer((_) async => Response(
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      // Act
      final result = await authApiService.authCheck();

      // Assert
      expect(result, equals(const Right<Failure, bool>(true)));
      verify(mockSharedPreferences.getString('token'));
      verify(mockDioClient.get(endpoint: '/auth/check'));
    });

    test('should return false when token is invalid', () async {
      // Arrange
      when(mockSharedPreferences.getString('token'))
          .thenReturn('invalid_token');
      when(mockDioClient.get(endpoint: anyNamed('endpoint')))
          .thenAnswer((_) async => Response(
                statusCode: 401,
                requestOptions: RequestOptions(),
              ));
      when(mockSharedPreferences.remove('token')).thenAnswer((_) async => true);

      // Act
      final result = await authApiService.authCheck();

      // Assert
      expect(result, equals(const Right<Failure, bool>(false)));
      verify(mockSharedPreferences.getString('token'));
      verify(mockDioClient.get(endpoint: '/auth/check'));
      verify(mockSharedPreferences.remove('token'));
    });

    test('should return false when server returns 401', () async {
      // Arrange
      when(mockSharedPreferences.getString('token'))
          .thenReturn('expired_token');
      when(mockDioClient.get(endpoint: anyNamed('endpoint')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(),
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(),
        ),
      ));
      when(mockSharedPreferences.remove('token')).thenAnswer((_) async => true);

      // Act
      final result = await authApiService.authCheck();

      // Assert
      expect(result, equals(const Right<Failure, bool>(false)));
      verify(mockSharedPreferences.getString('token'));
      verify(mockDioClient.get(endpoint: '/auth/check'));
      verify(mockSharedPreferences.remove('token'));
    });

    test('should return true when there is a network error but token exists',
        () async {
      // Arrange
      when(mockSharedPreferences.getString('token')).thenReturn('valid_token');
      when(mockDioClient.get(endpoint: anyNamed('endpoint')))
          .thenThrow(DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(),
      ));

      // Act
      final result = await authApiService.authCheck();

      // Assert
      expect(result, equals(const Right<Failure, bool>(true)));
      verify(mockSharedPreferences.getString('token'));
      verify(mockDioClient.get(endpoint: '/auth/check'));
      verifyNever(mockSharedPreferences.remove('token'));
    });

    test('should return ServerFailure when an unexpected error occurs',
        () async {
      // Arrange
      when(mockSharedPreferences.getString('token')).thenReturn('valid_token');
      when(mockDioClient.get(endpoint: anyNamed('endpoint')))
          .thenThrow(Exception('Unexpected error'));

      // Act
      final result = await authApiService.authCheck();

      // Assert
      expect(result, isA<Left<Failure, bool>>());
      expect(
        (result as Left).value,
        isA<ServerFailure>(),
      );
      verify(mockSharedPreferences.getString('token'));
      verify(mockDioClient.get(endpoint: '/auth/check'));
    });
  });
}
