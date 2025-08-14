import 'package:dartz/dartz.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_entity.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_line_entity.dart';

abstract class ImtRepository {
  Future<Either<CommonError, int>> getDocTypeId(int poDocTypeId);

  Future<Either<CommonError, List<ImtLineEntity>>> createLines(
      {OrderMovement po});

  Future<Either<CommonError, ImtEntity>> submitPoImt(ImtEntity data);
}
