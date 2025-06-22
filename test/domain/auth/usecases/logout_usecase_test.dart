import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/auth/repository/auth.dart';
import 'package:customer/domain/auth/usecases/logout_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_check_usecase_test.mocks.dart';

void main() {
  late LogoutUseCase logoutUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    logoutUseCase = LogoutUseCase(authRepository: mockAuthRepository);
  });

  group('LogoutUseCase', () {
    test('should return true when logout is successful', () async {
      // Arrange
      when(mockAuthRepository.logout())
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await logoutUseCase();

      // Assert
      expect(result, equals(const Right<Failure, bool>(true)));
      verify(mockAuthRepository.logout());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return false when logout fails', () async {
      // Arrange
      when(mockAuthRepository.logout())
          .thenAnswer((_) async => const Right(false));

      // Act
      final result = await logoutUseCase();

      // Assert
      expect(result, equals(const Right<Failure, bool>(false)));
      verify(mockAuthRepository.logout());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ServerFailure when repository returns failure', () async {
      // Arrange
      final failure = ServerFailure(message: 'Logout failed');
      when(mockAuthRepository.logout())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await logoutUseCase();

      // Assert
      expect(result, equals(Left<Failure, bool>(failure)));
      verify(mockAuthRepository.logout());
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
