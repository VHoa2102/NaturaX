class ApiResponse<T> {
  final bool status;
  final String? message;
  final T? data;

  ApiResponse({required this.status, this.message, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] ?? false,
      message: json['message'],
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : json['data'],
    );
  }

  factory ApiResponse.success(T data, [String? message]) {
    return ApiResponse<T>(status: true, message: message, data: data);
  }

  factory ApiResponse.error(String message) {
    return ApiResponse<T>(status: false, message: message, data: null);
  }
}
