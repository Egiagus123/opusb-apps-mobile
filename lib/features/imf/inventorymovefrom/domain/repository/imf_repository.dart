import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_entity.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_line_entity.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement.dart';

abstract class ImfRepository {
  Future<Either<CommonError, int>> getDocTypeId(int poDocTypeId);

  Future<Either<CommonError, List<ImfLineEntity>>> createLines(
      {@required OrderMovement om});

  Future<Either<CommonError, ImfEntity>> submitPoReceipt(ImfEntity data);
}
