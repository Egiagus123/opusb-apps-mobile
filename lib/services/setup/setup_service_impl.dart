import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../business_logic/utils/keys.dart';
import '../../business_logic/utils/logger.dart';
import 'setup_service.dart';

class SetupServiceImpl implements SetupService {
  final log = getLogger('SetupServiceImpl');
  final Dio dio;
  final SharedPreferences preferences;

  SetupServiceImpl({
    required this.dio,
    required this.preferences,
  });

  @override
  Future<String> getHost() async {
    log.i('getHost()');
    String host = preferences.getString(Keys.authHost) ?? '';
    log.d(host);
    return host;
  }

  @override
  Future<String> saveHost(String host) async {
    log.i('saveHost($host)');
    preferences.setString(Keys.authHost, host);
    dio.options.baseUrl = 'https://$host/api/v1';
    return host;
  }
}
