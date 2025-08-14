import 'package:apps_mobile/features/imt/imt/data/model/imt_model.dart';

abstract class ImtDataSource {
  Future<int> getDocTypeId(int poDocTypeId);
  Future<ImtModel> push(Map<String, dynamic> data);
}
