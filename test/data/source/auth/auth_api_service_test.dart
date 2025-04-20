import 'package:customer/core/error/failures.dart';
import 'package:customer/core/network/dio_client.dart';
import 'package:customer/data/models/auth/verify_otp_model/login_params.dart';
import 'package:customer/data/models/auth/verify_otp_model/user_model.dart';
import 'package:customer/data/source/auth/auth_api_service.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final loginParams = LoginParams(
    email: 'test@example.com',
    password: 'password123',
  );

  final userModel = UserModel(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    token: 'test_token',
  );

  final successResponse = Response(
    data: {
      'success': true,
      'message': 'Login successful',
      'data': {
        'id': '1',
        'name': 'Test User',
        'email': 'test@example.com',
        'token': 'test_token',
      },
    },
    statusCode: 200,
    requestOptions: RequestOptions(),
  );

  final errorResponse = Response(
    data: {
      'success': false,
      'message': 'Invalid credentials',
    },
    statusCode: 401,
    requestOptions: RequestOptions(),
  );

  group('login', () {
    test('should return UserModel when login is successful', () async {
      // Arrange
      when(mockDioClient.post(
        endpoint: anyNamed('endpoint'),
        params: anyNamed('params'),
      )).thenAnswer((_) async => successResponse);

      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      // Act
      final result = await authApiService.login(loginParams);

      // Assert
      expect(result, Right(userModel));
      verify(mockDioClient.post(
        endpoint: '/auth/login',
        params: loginParams.toJson(),
      ));
      verify(mockSharedPreferences.setString('token', 'test_token'));
    });

    test('should return AuthFailure when login fails with error response',
        () async {
      // Arrange
      when(mockDioClient.post(
        endpoint: anyNamed('endpoint'),
        params: anyNamed('params'),
      )).thenAnswer((_) async => errorResponse);

      // Act
      final result = await authApiService.login(loginParams);

      // Assert
      expect(result, Left(AuthFailure(message: 'Invalid credentials')));
      verify(mockDioClient.post(
        endpoint: '/auth/login',
        params: loginParams.toJson(),
      ));
      verifyNever(mockSharedPreferences.setString(any, any));
    });

    test('should return NetworkFailure when there is a connection timeout',
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
      final result = await authApiService.login(loginParams);

      // Assert
      expect(
        result,
        const Left(NetworkFailure(message: 'Network connection failed')),
      );
      verify(mockDioClient.post(
        endpoint: '/auth/login',
        params: loginParams.toJson(),
      ));
      verifyNever(mockSharedPreferences.setString(any, any));
    });

    test('should return ServerFailure when there is a server error', () async {
      // Arrange
      when(mockDioClient.post(
        endpoint: anyNamed('endpoint'),
        params: anyNamed('params'),
      )).thenThrow(DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(),
        response: Response(
          statusCode: 500,
          data: {'message': 'Server error'},
          requestOptions: RequestOptions(),
        ),
      ));

      // Act
      final result = await authApiService.login(loginParams);

      // Assert
      expect(result, const Left(ServerFailure(message: 'Server error')));
      verify(mockDioClient.post(
        endpoint: '/auth/login',
        params: loginParams.toJson(),
      ));
      verifyNever(mockSharedPreferences.setString(any, any));
    });
  });
}
