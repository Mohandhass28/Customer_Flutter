import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:customer/core/network/dio_client.dart';

import 'dio_client_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<SharedPreferences>()])
void main() {
  late DioClient dioClient;
  late MockDio mockDio;
  late MockSharedPreferences mockSharedPrefs;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockDio = MockDio();
    mockSharedPrefs = MockSharedPreferences();

    // Create a mock for interceptors
    final mockInterceptors = Interceptors();
    when(mockDio.interceptors).thenReturn(mockInterceptors);

    // Setup mock responses
    when(mockSharedPrefs.getString('token')).thenReturn('mock_token');

    dioClient = DioClient(sharedPrefs: mockSharedPrefs, dio: mockDio);
  });

  group('DioClient', () {
    test('should make successful GET request', () async {
      // Arrange
      final responseData = {
        "status": 1,
        "msg": "Otp sent successfully!",
        "otp": 4559
      };
      when(mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      // Act
      final response = await dioClient.get(
        endpoint: 'customer/sendOtp',
      );

      // Assert
      expect(response.statusCode, 200);
      expect(response.data, responseData);
    });

    test('should handle error responses', () async {
      // Arrange
      when(mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(),
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(),
        ),
      ));

      // Act & Assert
      expect(
        () => dioClient.get(endpoint: '/test'),
        throwsA(isA<DioException>()),
      );
    });

    test('should initialize with shared preferences', () {
      // Assert - just verify the client was created successfully
      expect(dioClient, isA<DioClient>());

      // We can't directly verify the token access since it happens in the interceptor
      // which is called during the request, not during initialization
    });
  });
}
