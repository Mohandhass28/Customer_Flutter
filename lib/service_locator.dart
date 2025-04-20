import 'package:customer/core/network/dio_client.dart';
import 'package:customer/main.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<DioClient>(DioClient(sharedPrefs: sharedPref));
}
