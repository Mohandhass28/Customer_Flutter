import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:customer/core/network/dio_client.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<SharedPreferences>()])
void main() {
  late DioClient dioClient;
  late MockDio mockDio;
  late MockSharedPreferences mockSharedPrefs;

  setUp(() async {
    mockDio = MockDio();
    mockSharedPrefs = MockSharedPreferences();

    // Setup mock responses
    when(mockSharedPrefs.getString('token')).thenReturn('mock_token');

    dioClient = DioClient(sharedPrefs: mockSharedPrefs);
  });

  group('DioClient', () {
    test('should make successful GET request', () async {
      // Arrange
      final responseData = {'message': 'success'};
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
        endpoint: '/test',
        params: {'key': 'value'},
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

    test('should add authorization header', () async {
      // Arrange
      when(mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: {},
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      // Act
      await dioClient.get(endpoint: '/test');

      // Assert
      verify(mockSharedPrefs.getString('token')).called(1);
      // Verify that the authorization header was set
      verify(mockDio.get(
        any,
        options: argThat(
          predicate((Options options) =>
              options.headers?['Authorization'] == 'mock_token'),
        ),
      )).called(1);
    });
  });
}
