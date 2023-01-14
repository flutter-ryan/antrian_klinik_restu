import 'package:antrian_online_restu/src/repositories/response/api_exception.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiBaseHelper {
  late Dio dio;

  Future<String?> getToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? token = _prefs.getString('token');
    return token;
  }

  ApiBaseHelper() {
    BaseOptions options = new BaseOptions(
      baseUrl: 'https://klinik-restu.com/api',
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      connectTimeout: 30000,
      receiveTimeout: 30000,
    );
    dio = Dio(options);
  }

  Future<dynamic> get(String url) async {
    var responseJson;
    dio.options.headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "x-token": await getToken(),
    };

    try {
      final response = await dio.get('$url');

      responseJson = response.data;
    } on DioError catch (e) {
      print(e.type);
      if (e.type == DioErrorType.connectTimeout) {
        throw BadRequestException("Server unreachable");
      } else if (e.type == DioErrorType.receiveTimeout) {
        throw BadRequestException("Server unreachable");
      } else if (e.type == DioErrorType.response) {
        return _returnResponse(e.response);
      }
      throw NoInternetException(
          "Pastikan data seluler atau wifi perangkat Anda terhubung ke internet");
    }

    return responseJson;
  }

  Future<dynamic> post(String url, String request) async {
    dio.options.headers = {
      "x-token": await getToken(),
    };
    var responseJson;
    try {
      final response = await dio.post('$url', data: request);

      responseJson = response.data;
    } on DioError catch (e) {
      print(e.toString());
      if (e.type == DioErrorType.connectTimeout) {
        throw BadRequestException("Server unreachable");
      } else if (e.type == DioErrorType.receiveTimeout) {
        throw BadRequestException("Server unreachable");
      } else if (e.type == DioErrorType.response) {
        return _returnResponse(e.response);
      }
      throw NoInternetException(
          "Pastikan data seluler atau wifi perangkat Anda terhubung ke internet");
    }

    return responseJson;
  }

  Future<dynamic> postToken(String url, String request) async {
    var responseJson;
    try {
      final response = await dio.post('$url', data: request);
      responseJson = response.data;
    } on DioError catch (e) {
      print(e.type);
      if (e.type == DioErrorType.connectTimeout) {
        throw BadRequestException("Server unreachable");
      } else if (e.type == DioErrorType.receiveTimeout) {
        throw BadRequestException("Server unreachable");
      } else if (e.type == DioErrorType.response) {
        return _returnResponse(e.response);
      }
      throw NoInternetException(
          "Pastikan data seluler atau wifi perangkat Anda terhubung ke internet");
    }

    return responseJson;
  }

  dynamic _returnResponse(Response<dynamic>? response) {
    switch (response!.statusCode) {
      case 400:
        throw BadRequestException("Bad Request");
      case 401:
      case 403:
        throw UnauthorisedException("Unauthorized user");
      case 408:
        throw UnauthorisedException("Token Expired");
      case 500:
      default:
        throw FetchDataException(
            "Server tidak dapat terhubung dengan status: ${response.statusCode}");
    }
  }
}

final ApiBaseHelper helper = new ApiBaseHelper();
