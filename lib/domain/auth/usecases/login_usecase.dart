import 'package:customer/core/error/failures.dart';
import 'package:customer/data/models/auth/verify_otp_model/verify_otp.dart';
import 'package:customer/domain/auth/entities/send_otp.dart';
import 'package:customer/domain/auth/entities/user.dart';
import 'package:customer/domain/auth/repository/auth.dart';
import 'package:dartz/dartz.dart';

import '../../../data/models/auth/send_otp_model/send_otp_params.dart';

class SendOTPUseCase {
  final AuthRepository _authRepository;

  SendOTPUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<Either<Failure, SendOTP>> call(SendOTPParams params) async {
    return await _authRepository.sendOTP(params);
  }
}

class VerifyOTPUseCase {
  final AuthRepository _authRepository;

  VerifyOTPUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<Either<Failure, User>> call(VerifyOtpParams params) async {
    return await _authRepository.verifyOTP(params);
  }
}
