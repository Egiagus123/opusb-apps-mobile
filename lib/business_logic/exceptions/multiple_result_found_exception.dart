import 'opusb_exception.dart';

class MultipleResultFoundException extends OpusbException {
  MultipleResultFoundException(String message) : super(message);
}
