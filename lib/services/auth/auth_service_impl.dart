import 'dart:convert';

import 'package:apps_mobile/business_logic/models/user.dart';
import 'package:apps_mobile/business_logic/models/user_data.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/business_logic/utils/keys.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../business_logic/models/auth_response.dart';
import '../../business_logic/models/id_name_pair.dart';
import '../../business_logic/models/login_credential.dart';
import '../../business_logic/models/login_parameters.dart';
import '../../business_logic/utils/constants.dart';
import '../../business_logic/utils/logger.dart';
import 'auth_service.dart';

class AuthServiceImpl implements AuthService {
  final log = getLogger('AuthServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  AuthServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<AuthResponse> authenticate(LoginCredential credential) async {
    log.i('authenticate($credential)');
    try {
      final response =
          await dio.post('/auth/tokens', data: credential.toJson());
      final authResponse = AuthResponse.fromJson(response.data);
      await saveAuthData(AuthKey.token, authResponse.token);
      await saveAuthData(AuthKey.username, credential.userName);
      await saveAuthData(AuthKey.password, credential.password);
      log.d(authResponse);
      return authResponse;
    } on DioError catch (e) {
      log.e('authenticate error: ${e.response?.data ?? e.message}');
      throw e.error.toString();
    }
  }

  @override
  Future<AuthResponse> authorize(LoginParameters parameters) async {
    log.i('authorize($parameters)');
    try {
      final response = await dio.put('/auth/tokens', data: parameters.toJson());
      final authResponse = AuthResponse.fromJson(response.data);
      await saveAuthData(AuthKey.token, authResponse.token);
      await saveAuthData(AuthKey.clientId, parameters.clientId.toString());
      await saveAuthData(AuthKey.roleId, parameters.roleId.toString());
      await saveAuthData(AuthKey.orgId, parameters.organizationId.toString());
      Context().token = authResponse.token;

      final userResponse = await dio.get("/windows/my-profile");
      var userData = (userResponse.data as List);

      if (userData.isNotEmpty) {
        User user = User.fromJson(userData.first);
        Context().userId = user.id;
        Context().userName = user.name;
        Context().orgId = parameters.organizationId;
        await saveAuthData(AuthKey.userId, user.id.toString());
      }

      return authResponse;
    } on DioError catch (e) {
      log.e('authorize error: ${e.response?.data ?? e.message}');
      throw e.error.toString();
    }
  }

  @override
  Future<List<IdNamePair>> getRoles(int clientId) async {
    log.i('getRoles($clientId)');
    try {
      final response = await dio.get('/auth/roles?client=$clientId');
      final List<dynamic> data = response.data;
      final roles = data.map((r) => IdNamePair.fromJson(r)).toList();
      log.d(roles);
      return roles;
    } on DioError catch (e) {
      log.e('getRoles error: ${e.response?.data ?? e.message}');
      throw e.error.toString();
    }
  }

  @override
  Future<List<IdNamePair>> getOrg(clientId, roleId) async {
    log.i('getOrg(clientId: $clientId, roleId: $roleId)');
    try {
      final response = await dio.get(
        '/auth/organizations',
        queryParameters: {'client': clientId, 'role': roleId},
      );
      final List<dynamic> data = response.data;
      final orgs = data.map((r) => IdNamePair.fromJson(r)).toList();
      log.d(orgs);
      return orgs;
    } on DioError catch (e) {
      log.e('getOrg error: ${e.response?.data ?? e.message}');
      throw e.error.toString();
    }
  }

  @override
  Future<bool> logout() async {
    log.i('logout');
    try {
      final prefs = await SharedPreferences.getInstance();
      await _registerDeviceToken(false);
      await storage.deleteAll();
      await prefs.remove(Keys.notifLastChecked);
      await prefs.remove(Keys.pin);
      await prefs.remove(Keys.fingerOn);
      return true;
    } catch (e) {
      log.e('Logout error: $e');
      return false;
    }
  }

  Future<String> getAuthData(AuthKey key) async {
    log.i('getAuthData(${key.toString()})');
    final data = await storage.read(key: key.toString());
    log.d(data);
    return data ?? '';
  }

  Future<void> saveAuthData(AuthKey key, String data) async {
    log.i('saveAuthData(key:$key , data:$data)');
    await storage.write(key: key.toString(), value: data);
  }

  @override
  Future<bool> autoLogin() async {
    log.i('autoLogin');
    try {
      final username = await getAuthData(AuthKey.username);
      final password = await getAuthData(AuthKey.password);
      final clientIdStr = await getAuthData(AuthKey.clientId);
      final roleIdStr = await getAuthData(AuthKey.roleId);
      final orgIdStr = await getAuthData(AuthKey.orgId);
      final userId = await getAuthData(AuthKey.userId);

      if ([username, password, clientIdStr, roleIdStr, orgIdStr]
          .any((e) => e.isEmpty)) {
        return false;
      }

      await authenticate(
          LoginCredential(userName: username, password: password));
      await authorize(LoginParameters(
        clientId: int.parse(clientIdStr),
        roleId: int.parse(roleIdStr),
        organizationId: int.parse(orgIdStr),
      ));
      await getDataImage(
          int.parse(userId), int.parse(clientIdStr), int.parse(roleIdStr));
      return true;
    } catch (e) {
      log.e('Auto login failed: $e');
      return false;
    }
  }

  @override
  Future<String> getMinVersion() async {
    log.i('getMinVersion');
    try {
      const sysConfigMinVersion = 'BHP_MOBILE_MIN_VERSION';
      final response = await dio.get(
          "/windows/system-configurator?filter=Name='$sysConfigMinVersion'");
      final responseList = (response.data as List);
      final version =
          responseList.isNotEmpty ? responseList.single['value'] : '';
      log.i('MinVersion: $version');
      return version;
    } on DioError catch (e) {
      log.e('getMinVersion error: ${e.response?.data ?? e.message}');
      throw e.error.toString();
    }
  }

  Future<void> _registerDeviceToken(bool isRegister) async {
    log.i('registerDeviceToken($isRegister)');
    try {
      print("masuk");
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) throw Exception('FCM token is null');

      final response = await dio.post('/processes/registerdevicetoken', data: {
        'AD_User_ID': Context().userId,
        'isRegister': isRegister ? 'Y' : 'N',
        'token': token,
      });
      log.i(response);

      if (response.statusCode == 200) {
        final client = await storage.read(key: AuthKey.clientId.toString());
        final role = await storage.read(key: AuthKey.roleId.toString());
        final orgId = await storage.read(key: AuthKey.orgId.toString());

        final filter = Uri.encodeComponent(
          'ad_user_id=${Context().userId} and ad_client_id=$client and ad_role_id=$role',
        );
        final userResponse =
            await dio.get('/models/bhp_rv_user_mobile?filter=$filter');
        final userData = userResponse.data as List;

        if (userData.isNotEmpty) {
          final data = UserData.fromJson(userData.first);
          Context().clientName = data.client_name;
          Context().roleName = data.role_name;
          Context().photo = data.binaryData;
          if (Context().photo != null) {
            Context().photo = base64.decode(Context().photo);
          }
          Context().orgId = int.parse(orgId ?? '0');
        }
      }
    } on DioError catch (e) {
      log.e('registerDeviceToken error: ${e.response?.data ?? e.message}');
      throw e.error.toString();
    }
  }

  @override
  Future<void> getDataImage(int userID, client, role) async {
    log.i('getDataImage');
    try {
      final query =
          "filter=AD_User_ID=$userID and ad_Client_id=$client and ad_role_id=$role";
      final response = await dio.get("/models/bhp_rv_user_mobile?$query");

      if (response.statusCode == 200) {
        final dataList = response.data as List;
        if (dataList.isNotEmpty) {
          final data = UserData.fromJson(dataList.first);
          Context().photo = data.binaryData;
          if (Context().photo != null) {
            Context().photo = base64.decode(Context().photo);
          }
        }
      }
    } on DioError catch (e) {
      log.e('getDataImage error: ${e.response?.data ?? e.message}');
      throw e.error.toString();
    }
  }
}
