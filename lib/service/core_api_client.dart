import 'dart:convert';

import 'package:english_learning_app/models/database/token.dart';
import 'package:english_learning_app/models/user_model.dart';
import 'package:english_learning_app/repositories/information_user_repository.dart';
import 'package:english_learning_app/repositories/token_repository.dart';
import 'package:english_learning_app/service/data_client_service.dart';
import 'package:english_learning_app/utils/network_service.dart';
import 'package:english_learning_app/viewmodels/main_viewmodel.dart';
import 'package:http/http.dart' as http;

import '../utils/app_util.dart';
import 'database_service.dart';

class CoreApiClient {
  static const String API_URL = "http://103.27.61.209";
  static String? fireBaseDeviceToken;

  // Simplified logout method
  static Future<dynamic> logout() async {
    String urlPath = "/api/v1/auth/logout";
    var response = await http.get(
      Uri.parse(API_URL + urlPath),
      headers: {"Content-Type": "application/json", "evn-token": DataClient.user.token!},
    );
    return response.body;
  }

  Future initialize() async {
    await DatabaseService.initDb();
    await checkLoggedInToken();
  }

  static checkLoggedInToken() async {
    var token = await TokenRepository.getByName("token");
    if (token.name != null && token.name != "") {
      DataClient.user.token = token.token;
      bool connect = await NetworkService().isConnect();
      if (connect) {
        await CoreApiClient.getInformationUser().then((value) async {
          if (value != null) {
            DataClient.user.currentUser = value;
            if (DataClient.user.currentUser != null) {
              await InformationUserRepository.addCustomer(DataClient.user.currentUser!);
            }
            ();
            print('FINISH LOADING ---  LOGGED IN');
            MainViewModel().setLoggedIn(true);
          }
        });
      } else {
        await InformationUserRepository.getByToken(DataClient.user.token).then((value) {
          if (value != null) {
            DataClient.user.currentUser = value;
            // DataClient.user.chatInternalCompany = ChatInternalCompany(accessToken: DataClient.chatInternal.informationCustomer!.accessToken);
            MainViewModel().setLoggedIn(true);
          }
        });
      }
    } else {
      MainViewModel().setLoggedIn(false);
    }
  }

  //
  // static Future<UserModel?> getInformationUser() async {
  //   var response = await ApiClient.callApi(
  //     API_URL + "/api/v1/user/profile",
  //     {"Bearer": DataClient.user.token},
  //   );
  //   if (response != null && response["data"] != null) {
  //     return UserModel.fromJson(response["data"]);
  //   }
  //   return null;
  // }
  static Future<UserModel?> getInformationUser() async {
    final url = Uri.parse("$API_URL/api/v1/user/profile");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${DataClient.user.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null && jsonData["data"] != null) {
          return UserModel.fromJson(jsonData["data"]);
        }
      }
      return null;
    } catch (e) {
      print('Error getting user information: $e');
      return null;
    }
  }

  static Future<bool> Login({String? username, String? password}) async {
    String urlPath = "/api/v1/auth/login";
    var body = jsonEncode({"email": username, "password": password});
    try {
      var response = await http.post(
        Uri.parse(API_URL + urlPath),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      print(response.body);
      if (response.statusCode == 200) {
        try {
          var data = json.decode(response.body);
          DataClient.user.token = data["access_token"];
          DataClient.user.currentUser = UserModel.fromJson(data["user"]);

          // Save  token
          TokenRepository.add(Token(name: "token", token: DataClient.user.token));
          // if (DataClient.user.currentUser != null) {
          MainViewModel().setLoggedIn(true);
          return true;
        } catch (error) {
          AppUtil.showToastError("Tài khoản hoặc mật khẩu không đúng");
          return false;
        }
      } else if (response.statusCode == 422) {
        AppUtil.showToastError("Tài khoản hoặc mật khẩu không đúng");
        return false;
      } else {
        AppUtil.showToastError("Đăng nhập thất bại");
        return false;
      }
    } catch (e) {
      AppUtil.showToastError("Đăng nhập thất bại");
      return false;
    }
  }

  static Future<bool> register({String username = "", String email = "", String password = "", String phone = ""}) async {
    String urlPath = "/api/v1/auth/register";
    var body = jsonEncode({
      "user_name": username,
      "email": email,
      "password": password,
      "phone": phone,
    });
    try {
      var response = await http.post(
        Uri.parse(API_URL + urlPath),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 201) {
        AppUtil.showToastSuccess("Đã đăng kí thành công!\nĐăng nhập để trải nghiệm nào!");
        return true;
      } else if (response.statusCode == 422) {
        // Parse validation errors
        final Map<String, dynamic> errorJson = jsonDecode(jsonDecode(response.body));

        // Show first error message immediately
        if (errorJson.containsKey('email')) {
          AppUtil.showToastError(errorJson['email'][0]);
        } else if (errorJson.containsKey('user_name')) {
          AppUtil.showToastError(errorJson['user_name'][0]);
        } else if (errorJson.containsKey('phone')) {
          AppUtil.showToastError(errorJson['phone'][0]);
        } else if (errorJson.containsKey('password')) {
          AppUtil.showToastError(errorJson['password'][0]);
        } else {
          AppUtil.showToastError("Đăng kí thất bại zzz");
        }
        return false;
      } else {
        AppUtil.showToastError("Đăng kí thất bại");
        return false;
      }
    } catch (e) {
      print("LOI REGISTER : " + e.toString());
      AppUtil.showToastError(e.toString());
      return false;
    }
  }
}
