import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:itmo_grain_frontend/server_routes.dart';

class AuthController extends GetxController {
  Dio dio = Dio();
  RxBool regType = false.obs;
  void changeType(type) {
    regType.value = type;
    notifyChildrens();
  }
  Future<void> createAccount(
  {
    required name,
    required email,
    required rules,
    required password,
}
      )async{
   await dio.post('${ServerRouter.host}/registration',
    data: {
      'name': name,
      'password': password,
      'type': rules.toString(),
      'email': email,
    });
  }
  Future<Map> login(email, password) async {
    final response = await dio.post("${ServerRouter.host}/auth",
    data: {
      'email': email,
      'password': password,
    });
    print(response.data);
    return jsonDecode(response.data);
  }
}
