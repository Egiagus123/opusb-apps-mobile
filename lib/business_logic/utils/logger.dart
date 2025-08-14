import 'package:logger/logger.dart';

Logger getLogger(String className) {
  return Logger(printer: SimpleLogPrinter(className));
}

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    // Create an instance of PrettyPrinter to access instance members
    var prettyPrinter = PrettyPrinter();

    // Using a fallback for color and emoji if not available
    var color = prettyPrinter.levelColors?[event.level] ??
        prettyPrinter.levelColors?[Level.debug];
    var emoji = prettyPrinter.levelEmojis?[event.level] ?? '🐞';

    // Returning formatted log message
    return [''];
  }
}
