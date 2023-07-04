import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/src/helper/storage.dart';
import 'package:path_provider/path_provider.dart';

String baseUrl = dotenv.env['BACKEND_URL'] ?? 'http://192.168.1.4:80';
const sanctumCsrfCookieUrl = '/sanctum/csrf-cookie';
const apiUrl = '/api';
const healthUrl = '$apiUrl/health';
const loginUrl = '$apiUrl/login';
const usersUrl = '$apiUrl/users';
const userUrl = '$apiUrl/user';
const authUrl = '$apiUrl/auth';
const logoutUrl = '$apiUrl/logout';
const forgotPasswordUrl = '$apiUrl/forgot-password';
const resetPasswordtUrl = '$apiUrl/reset-password';

const storage = FlutterSecureStorage();

class NetworkConfig {
  static final NetworkConfig _singleton = NetworkConfig._internal();
  late Dio _client;

  factory NetworkConfig() => _singleton;

  NetworkConfig._internal() {
    _client = Dio()
      ..options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
        responseType: ResponseType.json,
        headers: (kIsWeb)
            ? {
                "Accept": 'application/json',
              }
            : {
                HttpHeaders.userAgentHeader: "dio",
                "Connection": "keep-alive",
                "Accept": 'application/json',
              },
      )
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // when getCsrftoken() is called, the function puts to storage the csrf token
            // for any and all subsequent requests, it will contain X-XSRF-TOKEN header
            final csrfToken =
                await storage.read(key: StorageKeys.csrfToken.name);
            if (csrfToken != null) {
              options.headers['X-XSRF-TOKEN'] = csrfToken;
            }

            // pre-requisite is to login at frontend\lib\src\features\login\login_page.dart
            // for any and all subsequent requests, the login token will be added to
            // the headers of the requests
            final loginToken =
                await storage.read(key: StorageKeys.loginToken.name);
            if (loginToken != null) {
              options.headers['Authorization'] = 'Bearer $loginToken';
            }

            return handler.next(options);
          },
          onError: (e, handler) {
            return handler.resolve(
              Response(
                requestOptions: e.requestOptions,
                data: e.response,
                statusCode: e.response?.statusCode,
              ),
            );
          },
        ),
      );
  }

  PersistCookieJar? _jar;
  String? csrfTokenValue;

  Dio get client => _client;
  PersistCookieJar? get jar => _jar;

  // https://stackoverflow.com/questions/52500575/post-request-with-cookies-in-flutter
  // intercepting cookies using dio cookie manager and cookie jar for CORS
  // goal is to retrieve cookie "XSRF-TOKEN"
  //
  // SIDE NOTE:
  //   CORS is not needed for mobile application but it is used for web
  //   WEB use not tested thoroughly, will proceed with mobile testing for now
  Future<String?> getCsrftoken() async {
    String appDocPath;
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      appDocPath = appDocDir.path;
    } catch (e) {
      appDocPath = '';
    }
    try {
      final Directory dir = Directory("$appDocPath/.cookies/");
      final cookiePath = dir.path;
      _jar = PersistCookieJar(storage: FileStorage(cookiePath));
      await _jar!.deleteAll(); //clearing any existing cookies for a fresh start
      _client.interceptors.add(
        CookieManager(
          _jar!,
        ), //this sets up _dio to persist cookies throughout subsequent requests
      );
      _client.interceptors.add(
        InterceptorsWrapper(
          onResponse: (Response response, handler) async {
            List<Cookie> cookies =
                await _jar!.loadForRequest(Uri.parse(baseUrl));
            csrfTokenValue = cookies
                .firstWhere(
                  (c) => c.name == 'XSRF-TOKEN',
                  orElse: () => Cookie('temp', 'temp'),
                )
                .value;
            if (csrfTokenValue != 'temp') {
              _client.options.headers['X-XSRF-TOKEN'] =
                  csrfTokenValue; //setting the csrftoken from the response in the headers
            }

            return handler.next(response);
          },
        ),
      );

      await _client.get(sanctumCsrfCookieUrl);
      await storage.write(
          key: StorageKeys.csrfToken.name, value: csrfTokenValue);

      return csrfTokenValue;
    } catch (error, stacktrace) {
      debugPrint("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }
}
