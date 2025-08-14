import '../../business_logic/models/auth_response.dart';
import '../../business_logic/models/id_name_pair.dart';
import '../../business_logic/models/login_credential.dart';
import '../../business_logic/models/login_parameters.dart';

abstract class AuthService {
  Future<AuthResponse> authenticate(LoginCredential credential);
  Future<AuthResponse> authorize(LoginParameters parameters);
  Future<List<IdNamePair>> getRoles(int clientId);
  Future<bool> autoLogin();
  Future<String> getMinVersion();
  Future<bool> logout();
  Future<void> getDataImage(int userID, client, role);
  Future<List<IdNamePair>> getOrg(int clientId, int roleId);
}
