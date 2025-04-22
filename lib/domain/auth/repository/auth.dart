import 'package:customer/core/error/failures.dart';
import 'package:customer/data/models/auth/send_otp_model/send_otp_params.dart';
import 'package:customer/data/models/auth/verify_otp_model/verify_otp.dart';
import 'package:customer/domain/auth/entities/send_otp.dart';
import 'package:customer/domain/auth/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, SendOTP>> sendOTP(SendOTPParams params);
  Future<Either<Failure, User>> verifyOTP(VerifyOtpParams params);
  Future<Either<Failure, bool>> authCheck();
}
