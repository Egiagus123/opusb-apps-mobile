import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_entity.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_line_entity.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/repository/imf_repository.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement.dart';

class ImfUseCase {
  final ImfRepository receiptRepository;

  ImfUseCase(this.receiptRepository);

  Future<Either<CommonError, int>> getDocTypeId(int poDocTypeId) async {
    return receiptRepository.getDocTypeId(poDocTypeId);
  }

  Future<Either<CommonError, List<ImfLineEntity>>> createLines(
      {@required OrderMovement? po}) async {
    return receiptRepository.createLines(om: po!);
  }

  Future<Either<CommonError, ImfEntity>> submit(ImfEntity data) async {
    return receiptRepository.submitPoReceipt(data);
  }
}
