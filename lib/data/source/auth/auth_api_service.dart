import 'package:dartz/dartz.dart';

abstract class AuthApiService {
  Future<Either> login();
}

class AuthApiServiceImpl implements AuthApiService {
  @override
  Future<Either> login() {
    throw UnimplementedError();
  }
}
