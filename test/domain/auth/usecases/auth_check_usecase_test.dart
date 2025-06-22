import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/auth/repository/auth.dart';
import 'package:customer/domain/auth/usecases/auth_check_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_check_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
void main() {
  late AuthCheckUseCase authCheckUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authCheckUseCase = AuthCheckUseCase(authRepository: mockAuthRepository);
  });

  group('AuthCheckUseCase', () {
    test('should return true when user is authenticated', () async {
      // Arrange
      when(mockAuthRepository.authCheck())
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await authCheckUseCase();

      // Assert
      expect(result, equals(const Right<Failure, bool>(true)));
      verify(mockAuthRepository.authCheck());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return false when user is not authenticated', () async {
      // Arrange
      when(mockAuthRepository.authCheck())
          .thenAnswer((_) async => const Right(false));

      // Act
      final result = await authCheckUseCase();

      // Assert
      expect(result, equals(const Right<Failure, bool>(false)));
      verify(mockAuthRepository.authCheck());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthFailure when repository returns failure', () async {
      // Arrange
      final failure = AuthFailure(message: 'Authentication failed');
      when(mockAuthRepository.authCheck())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await authCheckUseCase();

      // Assert
      expect(result, equals(Left<Failure, bool>(failure)));
      verify(mockAuthRepository.authCheck());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ServerFailure when repository throws exception',
        () async {
      // Arrange
      final failure = ServerFailure(message: 'Server error');
      when(mockAuthRepository.authCheck())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await authCheckUseCase();

      // Assert
      expect(result, equals(Left<Failure, bool>(failure)));
      verify(mockAuthRepository.authCheck());
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
