import 'package:customer/core/network/dio_client.dart';
import 'package:customer/data/repository/auth/auth.dart';
import 'package:customer/data/source/auth/auth_api_service.dart';
import 'package:customer/domain/auth/repository/auth.dart';
import 'package:customer/domain/auth/usecases/auth_check_usecase.dart';
import 'package:customer/domain/auth/usecases/login_usecase.dart';
import 'package:customer/main.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Core
  sl.registerSingleton<DioClient>(DioClient(sharedPrefs: sharedPref));

  // Data sources
  sl.registerLazySingleton<AuthApiService>(
    () => AuthApiServiceImpl(
      dioClient: sl<DioClient>(),
      sharedPreferences: sharedPref,
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authApiService: sl<AuthApiService>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<SendOTPUseCase>(
    () => SendOTPUseCase(
      authRepository: sl<AuthRepository>(),
    ),
  );

  sl.registerLazySingleton<VerifyOTPUseCase>(
    () => VerifyOTPUseCase(
      authRepository: sl<AuthRepository>(),
    ),
  );

  sl.registerLazySingleton<AuthCheckUseCase>(
    () => AuthCheckUseCase(
      authRepository: sl<AuthRepository>(),
    ),
  );
}
