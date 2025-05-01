import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/auth/repository/auth.dart';
import 'package:dartz/dartz.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<Either<Failure, bool>> call() async {
    return await _authRepository.logout();
  }
}
