import 'package:bloc/bloc.dart';
import 'logger.dart';

class SimpleBlocObserver extends BlocObserver {
  final log = getLogger('SimpleBlocObserver');

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log.d('Event: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log.d('Transition: $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    log.e('Error: $error\nStackTrace: $stacktrace');
  }
}
