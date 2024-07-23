// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';
import 'package:flutter_core/core/data/abstract/exception/http_exception.dart';

/// модель для ошибки при авторизации
class HttpExceptionData extends HttpRequestException {
  int status;
  String? detail;

  HttpExceptionData({required this.status, this.detail})
      : super(detail, status, HttpTypeError.http);

  factory HttpExceptionData.fromJson(
          Map<String, dynamic> map, String defaultError, int code) =>
      HttpExceptionData(
          status: map['status'],
          detail: map['detail'] ?? defaultError ?? CoreConstant.empty);
}
