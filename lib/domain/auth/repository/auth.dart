import 'package:customer/core/error/failures.dart';
import 'package:customer/data/models/auth/verify_otp_model/login_params.dart';
import 'package:customer/domain/auth/entities/send_otp.dart';
import 'package:customer/domain/auth/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, SendOTP>> sendOTP(LoginParams params);
  Future<Either<Failure, User>> verifyOTP(LoginParams params);
  Future<Either<Failure, bool>> authCheck();
}
