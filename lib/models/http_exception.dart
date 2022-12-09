
class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}

class NetException implements Exception {
  final String message;
  NetException(this.message);

  @override
  String toString() {
    return message;
  }
}