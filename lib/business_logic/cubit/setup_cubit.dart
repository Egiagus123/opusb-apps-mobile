import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../service_locator.dart';
import '../../services/setup/setup_service.dart';
import '../utils/logger.dart';

part 'setup_state.dart';

class SetupCubit extends Cubit<SetupState> {
  final log = getLogger('SetupCubit');
  SetupCubit() : super(SetupInitial());

  Future<void> loadHost() async {
    log.i('loadHost()');
    try {
      emit(SetupLoadInProgress());
      final String host = await sl<SetupService>().getHost();
      emit(SetupLoadSuccess(host: host));
    } catch (e) {
      log.e('loadHost error: $e');
      emit(SetupStateFailure(message: 'Failed loading host'));
    }
  }

  Future<void> saveHost(String host) async {
    log.i('saveHost($host)');
    try {
      emit(SetupLoadInProgress());
      await sl<SetupService>().saveHost(host);
      emit(SetupSaveSuccess());
    } catch (e) {
      log.e('saveHost error: $e');
      emit(SetupStateFailure(message: 'Failed to save host $host'));
    }
  }
}
