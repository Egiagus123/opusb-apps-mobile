import 'opusb_exception.dart';

class NetworkException extends OpusbException {
  NetworkException([String message = 'Error connecting to network'])
      : super(message);
}
