import 'package:apps_mobile/business_logic/exceptions/minimum_version_exception.dart';
import 'package:apps_mobile/business_logic/models/auth_response.dart';
import 'package:apps_mobile/business_logic/models/id_name_pair.dart';
import 'package:apps_mobile/business_logic/models/login_credential.dart';
import 'package:apps_mobile/business_logic/models/login_parameters.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/inventory/auth/auth_service.dart';
import 'package:apps_mobile/services/inventory/setup/setup_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:version/version.dart';

// import '../../service_locator.dart';
// import '../../services/auth/auth_service.dart';
// import '../../services/setup/setup_service.dart';
// import '../exceptions/minimum_version_exception.dart';
// import '../models/auth_response.dart';
// import '../models/id_name_pair.dart';
// import '../models/login_credential.dart';
// import '../models/login_parameters.dart';
// import '../utils/context.dart';
// import '../utils/logger.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final log = getLogger('AuthCubit');

  AuthCubit() : super(AuthInitial());

  Future<bool> _checkVersion() async {
    log.i('_checkVersion');
    String minVersion = await sl<AuthService>().getMinVersion();
    if (minVersion.isNotEmpty) {
      final Version currentVersion = Version.parse(Context().version);
      final Version minimumVersion = Version.parse(minVersion);
      if (currentVersion < minimumVersion)
        throw MinimumVersionException(
            'Minimum version required is $minimumVersion');
    }
    return Future.value(true);
  }

  Future<void> initLogin() async {
    log.i('initLogin');
    try {
      emit(AuthInProgress());
      bool success = await sl<AuthService>().autoLogin();
      print('login ulang sukses');
      if (success) {
        await _checkVersion();
        emit(AuthAutoLoginSuccess());
      } else
        emit(AuthAuthenticationFailure());
    } on MinimumVersionException catch (e) {
      log.e('MinimumVersionException: $e');
      emit(AuthMinVersionFailure(message: e.message));
    } catch (e) {
      log.e('initLogin error: $e');
      emit(AuthFailure(message: 'Failed to initiate login'));
    }
  }

  Future<void> initreLogin() async {
    log.i('initreLogin');

    try {
      emit(AuthInProgress());
      bool success = await sl<AuthService>().autoLogin();
      if (success) {
        await _checkVersion();
        emit(AuthAutoLoginSuccess());
      } else
        emit(AuthAuthenticationFailure());
    } on MinimumVersionException catch (e) {
      log.e('MinimumVersionException: $e');
      emit(AuthMinVersionFailure(message: e.message));
    } catch (e) {
      log.e('initLogin error: $e');
      emit(AuthFailure(message: 'Failed to initiate login'));
    }
  }

  Future<void> authenticate(String username, String password) async {
    log.i('authenticate($username)');
    try {
      emit(AuthInProgress());
      final String host = await sl<SetupService>().getHost();
      if (host == null) {
        emit(AuthHostNotSetFailure());
      } else {
        final AuthResponse response = await sl<AuthService>().authenticate(
            LoginCredential(userName: username, password: password));
        emit(AuthAuthenticationSuccess(response: response));
      }
    } catch (e) {
      log.e('authenticate error: $e');
      emit(AuthFailure(message: 'Failed authenticating $username'));
    }
  }

  Future<void> initAuthorization(List<IdNamePair> clients) async {
    log.i('initAuthorization');
    try {
      emit(AuthInProgress());
      if (clients != null && clients.isNotEmpty) {
        final int clientId = clients.first.id;
        loadAuthorizationData(clientId: clientId);
      }
    } catch (e) {
      log.e('initAuthorization error: $e');
      emit(AuthFailure(message: 'Failed to initiate authorization'));
    }
  }

  Future<void> loadAuthorizationData(
      {required int clientId, int roleId = 0}) async {
    log.i('loadRoles(clientId: $clientId)');
    try {
      emit(AuthInProgress());
      final List<IdNamePair> roles = await sl<AuthService>().getRoles(clientId);
      roleId = roleId == 0 ? roles.first.id : roleId;
      emit(AuthAuthorizationDataLoaded(
          clientId: clientId, roleId: roleId, roles: roles));
    } catch (e) {
      log.e('loadRoles error: $e');
      emit(AuthFailure(message: 'Failed to load roles'));
    }
  }

  Future<void> authorize(int clientId, int roleId) async {
    log.i('authorize(clientId:$clientId , roleId:$roleId)');
    try {
      emit(AuthInProgress());
      final AuthResponse response = await sl<AuthService>()
          .authorize(LoginParameters(clientId: clientId, roleId: roleId));
      await _checkVersion();
      emit(AuthAuthorizationSuccess(response: response));
    } on MinimumVersionException catch (e) {
      log.e('MinimumVersionException: $e');
      emit(AuthMinVersionFailure(message: e.message));
    } catch (e) {
      log.e('authorize error: $e');
      emit(AuthFailure(message: 'Failed to authorize'));
    }
  }

  Future<void> logout() async {
    log.i('logout');
    try {
      emit(AuthInProgress());
      bool success = await sl<AuthService>().logout();
      if (success) emit(AuthLogoutSuccess());
    } catch (e) {
      log.e('logout error: $e');
      emit(AuthFailure(message: 'Failed to logout'));
    }
  }

  Future<void> isScan(bool value) async {
    emit(AuthIsScanValue(value: value));
  }
}
