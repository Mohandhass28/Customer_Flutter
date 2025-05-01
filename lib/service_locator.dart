import 'package:customer/core/bloc/cart_list_bloc/bloc/cart_list_bloc.dart';
import 'package:customer/core/bloc/default_address_header/bloc/address_header_bloc.dart';
import 'package:customer/core/network/dio_client.dart';
import 'package:customer/core/services/bill_summary_refresh_service.dart';
import 'package:customer/core/services/cart_refresh_service.dart';
import 'package:customer/data/repository/address/address.dart';
import 'package:customer/data/repository/auth/auth.dart';
import 'package:customer/data/repository/cart/cart.dart';
import 'package:customer/data/repository/product/product.dart';
import 'package:customer/data/repository/shop/shop.dart';
import 'package:customer/data/source/address/address_api_service.dart';
import 'package:customer/data/source/auth/auth_api_service.dart';
import 'package:customer/data/source/cart/cart_api_service.dart';
import 'package:customer/data/source/product/product_api_service.dart';
import 'package:customer/data/source/shop/shop_api_service.dart';
import 'package:customer/domain/address/repository/address.dart';
import 'package:customer/domain/address/usecases/get_adderss_list_usecase.dart';
import 'package:customer/domain/address/usecases/get_default_address_usecase.dart';
import 'package:customer/domain/auth/repository/auth.dart';
import 'package:customer/domain/auth/usecases/auth_check_usecase.dart';
import 'package:customer/domain/auth/usecases/login_usecase.dart';
import 'package:customer/domain/auth/usecases/logout_usecase.dart';
import 'package:customer/domain/cart/repository/cart.dart';
import 'package:customer/domain/cart/usecases/add_to_cart_usecase.dart';
import 'package:customer/domain/cart/usecases/cart_details_usecase.dart';
import 'package:customer/domain/cart/usecases/cart_list_usecase.dart';
import 'package:customer/domain/cart/usecases/modify_cart_usecase.dart';
import 'package:customer/domain/product/repository/product.dart';
import 'package:customer/domain/product/usecases/product_details_usecase.dart';
import 'package:customer/domain/shop/repository/shop.dart';
import 'package:customer/domain/shop/usecases/shop_list_usecase.dart';
import 'package:customer/main.dart';
import 'package:customer/presentation/shop_details/page/product_details/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  _registerCore();
  _registerAuth();
  _registerAddress();
  _registerShop();
  _registerProduct();
  _registerCart();
  _registerRefreshServiceForCart();
  _registerRefreshServiceForBillSummary();
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

  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(
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

void _registerShop() {
  // Data sources
  sl.registerLazySingleton<ShopApiService>(
    () => ShopApiServiceImpl(
      dioClient: sl<DioClient>(),
      sharedPreferences: sharedPref,
    ),
  );

  // Repositories
  sl.registerLazySingleton<ShopRepository>(
    () => ShopRepositoryImpl(
      shopApiService: sl<ShopApiService>(),
    ),
  );

  // Use cases for shop list
  sl.registerLazySingleton<ShopListUsecase>(
    () => ShopListUsecase(
      shopRepository: sl<ShopRepository>(),
    ),
  );

  // Use cases for shop details
  sl.registerLazySingleton<ShopDetailsUsecase>(
    () => ShopDetailsUsecase(
      shopRepository: sl<ShopRepository>(),
    ),
  );
}

void _registerProduct() {
  // Data sources
  sl.registerLazySingleton<ProductApiService>(
    () => ProductApiServiceImpl(
      dioClient: sl<DioClient>(),
      sharedPreferences: sharedPref,
    ),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      productApiService: sl<ProductApiService>(),
    ),
  );

  // Use cases for product details
  sl.registerLazySingleton<ProductDetailsUsecase>(
    () => ProductDetailsUsecase(
      productRepository: sl<ProductRepository>(),
    ),
  );
}

void _registerCart() {
  // Data sources
  sl.registerLazySingleton<CartApiService>(
    () => CartApiServiceImpl(
      dioClient: sl<DioClient>(),
      sharedPreferences: sharedPref,
    ),
  );

  // Repositories
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      cartApiService: sl<CartApiService>(),
    ),
  );

  // Use cases for cart list
  sl.registerLazySingleton<CartListUsecase>(
    () => CartListUsecase(
      cartRepository: sl<CartRepository>(),
    ),
  );

  // Use cases for cart list Bloc
  sl.registerLazySingleton<CartListBloc>(
    () => CartListBloc(
      cartListUsecase: sl<CartListUsecase>(),
    ),
  );

  // Use cases for cart details
  sl.registerLazySingleton<CartDetailsUsecase>(
    () => CartDetailsUsecase(
      cartRepository: sl<CartRepository>(),
    ),
  );

  // Use cases for add to cart
  sl.registerLazySingleton<AddToCartUsecase>(
    () => AddToCartUsecase(
      cartRepository: sl<CartRepository>(),
    ),
  );

  // Use cases for modify cart
  sl.registerLazySingleton(
    () => ModifyCartUsecase(
      cartRepository: sl<CartRepository>(),
    ),
  );
}

void _registerRefreshServiceForCart() {
  sl.registerLazySingleton(() => CartRefreshService());
}

void _registerRefreshServiceForBillSummary() {
  sl.registerLazySingleton(() => BillSummaryRefreshService());
}
