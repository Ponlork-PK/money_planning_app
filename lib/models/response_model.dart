class ResponseModel<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  ResponseModel({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ResponseModel.success(T data) => ResponseModel(
    success: true,
    data: data,
    statusCode: 200,
  );

  factory ResponseModel.error(String message, {int statusCode = 500}) =>
      ResponseModel(
        success: false,
        message: message,
        statusCode: statusCode,
      );

  @override
  String toString() => 'Response(success: $success, message: $message)';
}
