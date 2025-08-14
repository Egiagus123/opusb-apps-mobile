import 'dart:convert';

import 'package:apps_mobile/business_logic/models/auth_response.dart';
import 'package:apps_mobile/business_logic/models/id_name_pair.dart';
import 'package:apps_mobile/business_logic/models/login_credential.dart';
import 'package:apps_mobile/business_logic/models/login_parameters.dart';
import 'package:apps_mobile/business_logic/models/user.dart';
import 'package:apps_mobile/business_logic/models/user_data.dart';
import 'package:apps_mobile/business_logic/utils/constants.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/business_logic/utils/keys.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    AuthResponse authResponse;
    try {
      final response =
          await dio.post('/auth/tokens', data: credential.toJson());

      authResponse = AuthResponse.fromJson(response.data);
      await saveAuthData(AuthKey.token, authResponse.token);
      await saveAuthData(AuthKey.username, credential.userName);
      await saveAuthData(AuthKey.password, credential.password);
    } on DioError catch (e) {
      throw e.error.toString();
    }
    log.d(authResponse);
    return authResponse;
  }

  @override
  Future<AuthResponse> authorize(LoginParameters parameters) async {
    log.i('authorize($parameters)');
    AuthResponse authResponse;
    try {
      final response = await dio.put('/auth/tokens', data: parameters.toJson());
      authResponse = AuthResponse.fromJson(response.data);
      await saveAuthData(AuthKey.token, authResponse.token);
      await saveAuthData(AuthKey.clientId, parameters.clientId.toString());
      await saveAuthData(AuthKey.roleId, parameters.roleId.toString());
      Context().token = authResponse.token;

      // get user information
      final userResponse = await dio.get("/windows/my-profile");
      var userData = (userResponse.data as List);

      if (userData.isNotEmpty) {
        User user = User.fromJson(userData.first);
        Context().userId = user.id;
        print('id user : ${Context().userId}');
        Context().userName = user.name;
        await saveAuthData(AuthKey.userId, user.id.toString());
      }

      // register device token to server
      await _registerDeviceToken(true);
    } on DioError catch (e) {
      throw e.error.toString();
    }
    log.d(authResponse);
    return authResponse;
  }

  @override
  Future<List<IdNamePair>> getRoles(int clientId) async {
    log.i('getRoles($clientId)');
    var roles = <IdNamePair>[];
    try {
      final response = await dio.get('/auth/roles?client=$clientId');

      final List<dynamic> data = response.data;
      if (data.isNotEmpty) {
        roles = data.map((r) => IdNamePair.fromJson(r)).toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    log.d(roles);
    return roles;
  }

  @override
  Future<bool> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    log.i('logout');

    // deregister device from server
    await _registerDeviceToken(false);

    await storage.deleteAll();
    await preferences.remove(Keys.notifLastChecked);
    await preferences.remove(Keys.pin);
    await preferences.remove(Keys.fingerOn);

    return true;
  }

  Future<String?> getAuthData(AuthKey key) async {
    log.i('getAuthData(${key.toString()})');
    String? data = await storage.read(key: key.toString());
    log.d(data);
    return data;
  }

  Future<void> saveAuthData(AuthKey key, String data) async {
    log.i('saveAuthData(key:$key , data:$data)');
    await storage.write(key: key.toString(), value: data);
  }

  @override
  Future<bool> autoLogin() async {
    log.i('autoLogin');
    bool success = true;
    final String? username = await getAuthData(AuthKey.username);
    final String? password = await getAuthData(AuthKey.password);
    final String? clientIdStr = await getAuthData(AuthKey.clientId);
    final String? roleIdStr = await getAuthData(AuthKey.roleId);
    final userId = await getAuthData(AuthKey.userId);
    if (username != null &&
        password != null &&
        clientIdStr != null &&
        roleIdStr != null) {
      try {
        await authenticate(
            LoginCredential(userName: username, password: password));
        await authorize(LoginParameters(
            clientId: int.parse(clientIdStr), roleId: int.parse(roleIdStr)));
        await getDataImage(
            int.parse(userId!), int.parse(clientIdStr), int.parse(roleIdStr));
      } catch (e) {
        log.i('Auto login failed');
        success = false;
      }
    } else {
      success = false;
    }
    return success;
  }

  @override
  Future<String> getMinVersion() async {
    log.i('getMinVersion');
    String version = '';
    final String sysConfigMinVersion = 'BHP_MOBILE_MIN_VERSION';
    try {
      final response = await dio.get(
          "/windows/system-configurator?filter=Name='$sysConfigMinVersion'");
      var responseList = (response.data as List);
      if (responseList.isNotEmpty) {
        version = responseList.single['value'];
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    log.i('MinVersion: $version');
    return version;
  }

  Future<void> _registerDeviceToken(bool isRegister) async {
    log.i('registerDeviceToken($isRegister)');
    try {
      final String isRegisterStr = isRegister ? 'Y' : 'N';
      final String? token = await FirebaseMessaging.instance.getToken();
      // 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJJbnRhbiIsIkFEX1JvbGVfSUQiOjEwMDAxMDgsIkFEX1VzZXJfSUQiOjEwMDAzNTEsIkFEX09yZ19JRCI6MCwiaXNzIjoiaWRlbXBpZXJlLm9yZyIsIkFEX0NsaWVudF9JRCI6MTAwMDA0NiwiZXhwIjoxNjE5NzYyNTAzfQ.NehNLonEycqVHJF0HIg9BB41rqzhaCvQr27yQ0YRvpw';
      log.i('FCM Token: $token');
      final response = await dio.post('/processes/registerdevicetoken', data: {
        'AD_User_ID': Context().userId,
        'isRegister': isRegisterStr,
        'token': token,
      });
      log.i(response);
      if (response.statusCode == 200) {
        final client = await storage.read(key: AuthKey.clientId.toString());
        final role = await storage.read(key: AuthKey.roleId.toString());
        final userId = Context().userId;
        final filter = Uri.encodeComponent(
            'ad_user_id= $userId and ad_client_id= $client and ad_role_id= $role');
        final response =
            await dio.get('/models/bhp_rv_user_mobile?filter=$filter');
        var userData = (response.data as List);

        if (userData.isNotEmpty) {
          UserData data = UserData.fromJson(userData.first);
          Context().clientName = data.client_name;
          Context().roleName = data.role_name;
          Context().photo = data.binaryData;
          var bytes = Context().photo;
          if (bytes != null) {
            const Base64Codec base64 = Base64Codec();

            Context().photo = base64.decode(bytes);
          }
        }
        // await getDataImage(userId);
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
  }

  @override
  Future<void> getDataImage(int userID, client, role) async {
    String query =
        "filter=AD_User_ID=$userID and ad_Client_id= $client and ad_role_id=$role";

    List<UserData> userData = [];
    try {
      final response = await dio.get("/models/bhp_rv_user_mobile?$query");
      if (response.statusCode == 200) {
        var userData = (response.data as List);
        if (userData.isNotEmpty) {
          UserData data = UserData.fromJson(userData.first);
          Context().photo = data.binaryData;
          var bytes = Context().photo;
          if (bytes != null) {
            const Base64Codec base64 = Base64Codec();

            Context().photo = base64.decode(bytes);
          }
        }
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
  }
}
