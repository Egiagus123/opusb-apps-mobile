import 'package:apps_mobile/features/mr/receipt/data/model/receipt_model.dart';

abstract class ReceiptDataSource {
  Future<int> getDocTypeId(int poDocTypeId);
  Future<ReceiptModel> push(Map<String, dynamic> data);
}
