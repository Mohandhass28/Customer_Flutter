import 'package:customer/core/error/failures.dart';
import 'package:customer/data/models/auth/send_otp_model/send_otp_params.dart';
import 'package:customer/data/models/auth/verify_otp_model/verify_otp.dart';
import 'package:customer/data/source/auth/auth_api_service.dart';
import 'package:customer/domain/auth/entities/send_otp.dart';
import 'package:customer/domain/auth/entities/user.dart';
import 'package:customer/domain/auth/repository/auth.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;

  AuthRepositoryImpl({required AuthApiService authApiService})
      : _authApiService = authApiService;

  @override
  Future<Either<Failure, SendOTP>> sendOTP(SendOTPParams params) async {
    return await _authApiService.sendOTP(params);
  }

  @override
  Future<Either<Failure, User>> verifyOTP(VerifyOtpParams params) async {
    return await _authApiService.verifyOTP(params);
  }

  @override
  Future<Either<Failure, bool>> authCheck() async {
    return await _authApiService.authCheck();
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    return await _authApiService.logout();
  }
}
