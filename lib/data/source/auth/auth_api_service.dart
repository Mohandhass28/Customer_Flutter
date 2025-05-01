import 'package:customer/core/error/failures.dart';
import 'package:customer/core/network/dio_client.dart';
import 'package:customer/data/models/auth/send_otp_model/send_otp_model.dart';
import 'package:customer/data/models/auth/send_otp_model/send_otp_params.dart';
import 'package:customer/data/models/auth/verify_otp_model/verify_otp.dart';
import 'package:customer/data/models/auth/verify_otp_model/login_response.dart';
import 'package:customer/data/models/auth/verify_otp_model/user_model.dart';
import 'package:customer/domain/auth/entities/send_otp.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthApiService {
  Future<Either<Failure, SendOTP>> sendOTP(SendOTPParams params);
  Future<Either<Failure, UserModel>> verifyOTP(VerifyOtpParams params);
  Future<Either<Failure, bool>> authCheck();
  Future<Either<Failure, bool>> logout();
}

class AuthApiServiceImpl implements AuthApiService {
  final DioClient _dioClient;
  final SharedPreferences _sharedPreferences;

  AuthApiServiceImpl({
    required DioClient dioClient,
    required SharedPreferences sharedPreferences,
  })  : _dioClient = dioClient,
        _sharedPreferences = sharedPreferences;

  @override
  Future<Either<Failure, SendOTP>> sendOTP(SendOTPParams params) async {
    try {
      final response = await _dioClient.post(
        endpoint: 'customer/sendOtp',
        params: params.toJson(),
      );

      if (response.statusCode == 200) {
        return Right(SendOTPModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(message: 'Failed to send OTP'));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const Left(NetworkFailure(message: 'Network connection failed'));
      }

      final errorMessage =
          e.response?.data?['message'] ?? e.message ?? 'Server error';
      return Left(ServerFailure(message: errorMessage));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> verifyOTP(VerifyOtpParams params) async {
    try {
      final response = await _dioClient.post(
        endpoint: 'customer/verifyOtp',
        params: params.toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      if (loginResponse.status == 1 && loginResponse.payload?.user != null) {
        // Save token to shared preferences
        await _sharedPreferences.setString(
            'token', loginResponse.payload!.token);
        await _sharedPreferences.setString('number', params.phone);

        return Right(loginResponse.payload!.user!);
      } else {
        return Left(AuthFailure(message: loginResponse.message));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const Left(NetworkFailure(message: 'Network connection failed'));
      }

      final errorMessage =
          e.response?.data?['message'] ?? e.message ?? 'Server error';
      return Left(ServerFailure(message: errorMessage));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> authCheck() async {
    try {
      final token = _sharedPreferences.getString('token');

      print('token: $token');

      if (token == null || token.isEmpty) {
        return const Left(AuthFailure(message: 'No token found'));
      }

      return Right(true);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _sharedPreferences.remove('token');
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
