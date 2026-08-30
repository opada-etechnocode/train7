import 'dart:developer' as lg;

import 'package:http/http.dart' as http;

import '../utils/shared_import.dart';

Map<String, String> buildHeaderTokens() {
  final String acceptLanguage =
      appStore.selectedLanguageCode == 'ar' ? 'ar' : 'en';

  final Map<String, String> header = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    HttpHeaders.cacheControlHeader: 'no-cache',
    HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
    HttpHeaders.acceptLanguageHeader: acceptLanguage,
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
  };

  if (userStore.isLoggedIn || getBoolAsync(IS_SOCIAL)) {
    header.putIfAbsent(
      HttpHeaders.authorizationHeader,
      () => 'Bearer ${userStore.token}',
    );
  }
  log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint) {
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) url = Uri.parse('$mBaseUrl$endPoint');

  log('URL: ${url.toString()}');

  return url;
}

Future<Response> buildHttpResponse(
  String endPoint, {
  HttpMethod method = HttpMethod.GET,
  Map<String, dynamic>? request,
}) async {
  if (await isNetworkAvailable()) {
    final headers = buildHeaderTokens();
    final Uri url = buildBaseUrl(endPoint);

    log("FULL ENDPOINT");
    log(endPoint);
    log("HEADERS");
    log(buildHeaderTokens().toString());

    Response response;

    if (method == HttpMethod.POST) {
      log('Request: $request');
      response = await http.post(
        url,
        body: jsonEncode(request),
        headers: headers,
      );
    } else if (method == HttpMethod.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethod.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    log('Response body ($method): ${response.statusCode} ${response.body}');
    final dynamic responseLog = json.decode(response.body);
    if (responseLog is Map<String, dynamic>) {
      const encoder = JsonEncoder.withIndent("    ");
      lg.log(
        "\n${encoder.convert(responseLog)}",
        name: "$method ${url.toString()} ${response.statusCode}",
      );
    }

    return response;
  } else {
    throw Exception(errorInternetNotAvailable);
  }
}

@Deprecated('Use buildHttpResponse instead.')
Future<Response> getRequest(String endPoint) async =>
    buildHttpResponse(endPoint);

@Deprecated('Use buildHttpResponse with HttpMethod.POST instead.')
Future<Response> postRequest(String endPoint, Map<String, dynamic> request) async =>
    buildHttpResponse(endPoint, request: request, method: HttpMethod.POST);

Future<dynamic> handleResponse(Response response) async {
  if (!await isNetworkAvailable()) {
    throw Exception(errorInternetNotAvailable);
  }

  if (response.statusCode.isSuccessful()) {
    return jsonDecode(response.body);
  } else {
    final string = await (isJsonValid(response.body));
    log("jsonDecode(response.body)$string");
    if (string!.isNotEmpty) {
      if (string.toString().contains("Unauthenticated")) {
        // Centralized logout handle
        if (userStore.isLoggedIn) {
          logout(navigatorKey.currentContext!);
          push<void>(const SignInScreen(), isNewTask: true);
        }
        throw const AuthException('Unauthenticated');
      } else {
        throw Exception(string);
      }
    } else {
      throw Exception('Please try again later.');
    }
  }
}

//region Common
enum HttpMethod { GET, POST, DELETE, PUT }

class TokenException implements Exception {
  final String message;

  const TokenException([this.message = ""]);

  @override
  String toString() => "FormatException: $message";
}

class AuthException implements Exception {
  final String message;

  const AuthException([this.message = ""]);

  @override
  String toString() => "AuthException: $message";
}
//endregion

Future<String?> isJsonValid(dynamic json) async {
  try {
    final f = jsonDecode(json) as Map<String, dynamic>;
    return f['message'];
  } on Exception catch (e) {
    log(e.toString());
    return "";
  }
}

Future<MultipartRequest> getMultiPartRequest(
  String endPoint, {
  String? baseUrl,
}) async {
  final String url = baseUrl ?? buildBaseUrl(endPoint).toString();
  log(url);
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(
  MultipartRequest multiPartRequest, {
  void Function(dynamic)? onSuccess,
  void Function(dynamic)? onError,
}) async {
  final http.Response response = await http.Response.fromStream(
    await multiPartRequest.send(),
  );
  log("Result: ${response.body}");

  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body);
  } else {
    onError?.call(errorSomethingWentWrong);
  }
}
