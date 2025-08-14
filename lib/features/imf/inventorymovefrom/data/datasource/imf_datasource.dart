import 'package:apps_mobile/features/imf/inventorymovefrom/data/model/imf_model.dart';

abstract class ImfDataSource {
  Future<int> getDocTypeId(int poDocTypeId);
  Future<ImfModel> push(Map<String, dynamic> data);
}
