import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/auth/repository/auth.dart';
import 'package:dartz/dartz.dart';

class AuthCheckUseCase {
  final AuthRepository _authRepository;

  AuthCheckUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<Either<Failure, bool>> call() async {
    return await _authRepository.authCheck();
  }
}
