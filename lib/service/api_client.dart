import 'dart:convert';
import 'dart:io';
import 'package:english_learning_app/viewmodels/main_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import '../utils/app_util.dart';


class ApiClient {
  // static final SaleworkApiClient salework = new SaleworkApiClient();
  // static final ChatInternalApiClient chatInternalApiClient = new ChatInternalApiClient();

  //body tpye Map<String,dynamic>
  static dynamic callApi(String urlPath, Map<String, String?> header, {method = "GET", dynamic body, bool isEncodeBody = true, errorRegister = false, int timeoutSeconds = 25, bool retry = true, bool isBanking = false, List<File>? images, List<File>? videos, List<File>? files, bool isFile = false}) async {
    if (!kReleaseMode) print(method + ":" + urlPath);
    if (!kReleaseMode && method == "POST") print("▲" + encode(body, isEncodeBody)!);

    http.Response response = await api(Uri.parse(urlPath), header, method: method, body: encode(body, isEncodeBody), retry: retry, timeoutSeconds: timeoutSeconds,images: images,files: files,videos: videos,isFile: isFile);
    if (!kReleaseMode) print("▼" + urlPath + "  " + response.statusCode.toString() + "  " + response.body.toString());
    if (response.statusCode == 401) {
      AppUtil.showToastError("Vui lòng đăng nhập lại");
      MainViewModel().setLoggedIn(false);
    }
    if (response.bodyBytes != null && response.bodyBytes.isNotEmpty && response.statusCode == 200 || (errorRegister && (response.statusCode == 409 || response.statusCode == 500))) {
      String resource = Utf8Decoder().convert(response.bodyBytes);
      return json.decode(resource);
    } else if (isBanking && response.statusCode == 400) {
      return {'error': Utf8Decoder().convert(response.bodyBytes)};
    }
    return null;
  }

  static String? encode(body, bool isEncodeBody) {
    if (isEncodeBody) {
      return jsonEncode(body);
    }
    return body;
  }

  static Future<http.Response> api(urlPath, Map<String, String?> header, {method,String? body, authVerify, required retry, timeoutSeconds, List<File>? images, List<File>? videos, List<File>? files, bool isFile = false }) async {
    Duration timeout = Duration(seconds: retry ? timeoutSeconds : 15);
    final ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final httpRequest = IOClient(ioc);

    if (method == "POST") {
      if (isFile) {
        var request = http.MultipartRequest('POST', urlPath);
        request.headers.addAll(getHeaders(header)!);

        if (body != null) {
          request.fields['data'] = body;
        }

        // ✅ Hàm tiện ích thêm file vào request
        Future<void> addFilesToRequest(List<File>? fileList, String fieldName) async {
          if (fileList != null && fileList.isNotEmpty) {
            for (var file in List.from(fileList)) {
              request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));
            }
          }
        }


        await addFilesToRequest(images, 'images');
        await addFilesToRequest(videos, 'videos');
        await addFilesToRequest(files, 'files');

        try {
          var streamedResponse = await request.send();
          return await http.Response.fromStream(streamedResponse);
        } catch (e) {
          throw Exception("Failed to send request: $e");
        }
      } else {
        // ✅ Trả về request khi không phải file
        return await httpRequest
            .post(urlPath, headers: getHeaders(header), body: body)
            .timeout(timeout, onTimeout: () async {
          return await onTimeoutRequest(urlPath, header, method: method, body: body, authVerify: authVerify, retry: retry);
        });
      }
    } else if (method == "GET") {
      return await httpRequest.get(urlPath, headers: getHeaders(header)).timeout(timeout, onTimeout: () async {
        return await onTimeoutRequest(urlPath, header, method: method, body: body, authVerify: authVerify, retry: retry);
      });
    } else {
      // ✅ Tránh việc kết thúc mà không có giá trị trả về
      throw Exception("Unhandled method type: $method");
    }
  }


  static Map<String, String>? getHeaders(Map<String, String?> header) {
    Map<String, String>? newHeader = new Map();
    header.forEach((key, value) {
      newHeader[key] = value ?? "";
    });
    return newHeader;
  }

  static Future<http.Response> onTimeoutRequest(urlPath, header, {method, body, authVerify, required retry}) async {
    print("Timeout request - " + urlPath.toString());
    if (retry) {
      return await api(urlPath, header, method: method, body: body, authVerify: authVerify, retry: false);
    }
    return http.Response("{}", 408);
  }

  static Future<List<T>> callApiList<T>(String urlPath, Map<String, String> header, T convert(dynamic json), {String method = "GET", dynamic body}) async {
    var response = await callApi(urlPath, header, method: method, body: body);
    Iterable l = response["data"];
    return List<T>.from(l.map((modelJson) => convert(modelJson)));
  }
}
