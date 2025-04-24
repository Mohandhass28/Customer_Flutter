import 'package:customer/core/bloc/default_address_header/bloc/address_header_bloc.dart';
import 'package:customer/core/network/dio_client.dart';
import 'package:customer/data/repository/address/address.dart';
import 'package:customer/data/repository/auth/auth.dart';
import 'package:customer/data/source/address/address_api_service.dart';
import 'package:customer/data/source/auth/auth_api_service.dart';
import 'package:customer/domain/address/repository/address.dart';
import 'package:customer/domain/address/usecases/get_adderss_list_usecase.dart';
import 'package:customer/domain/address/usecases/get_default_address_usecase.dart';
import 'package:customer/domain/auth/repository/auth.dart';
import 'package:customer/domain/auth/usecases/auth_check_usecase.dart';
import 'package:customer/domain/auth/usecases/login_usecase.dart';
import 'package:customer/main.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  _registerCore();
  _registerAuth();
  _registerAddress();
}

void _registerCore() {
  sl.registerSingleton<DioClient>(DioClient(sharedPrefs: sharedPref));
}

void _registerAuth() {
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

void _registerAddress() {
  // Data sources
  sl.registerLazySingleton<AddressApiService>(
    () => AddressApiServiceImpl(
      dioClient: sl<DioClient>(),
      sharedPreferences: sharedPref,
    ),
  );

  // Repositories
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(
      addressApiService: sl<AddressApiService>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<AddressListUseCase>(
    () => AddressListUseCase(
      addressRepository: sl<AddressRepository>(),
    ),
  );

  //default address
  sl.registerLazySingleton<GetDefaultAddressUseCase>(
    () => GetDefaultAddressUseCase(
      addressRepository: sl<AddressRepository>(),
    ),
  );

  sl.registerLazySingleton<AddressHeaderBloc>(
    () => AddressHeaderBloc(
      getDfaultusecase: sl<GetDefaultAddressUseCase>(),
    ),
  );
}
