import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/inventory/setup/setup_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
