import 'package:dartz/dartz.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_entity.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_line_entity.dart';
import 'package:apps_mobile/features/imt/imt/domain/repository/imt_repository.dart';

class ImtUseCase {
  final ImtRepository receiptRepository;

  ImtUseCase(this.receiptRepository);

  Future<Either<CommonError, int>> getDocTypeId(int poDocTypeId) async {
    return receiptRepository.getDocTypeId(poDocTypeId);
  }

  Future<Either<CommonError, List<ImtLineEntity>>> createLines(
      {OrderMovement? po}) async {
    return receiptRepository.createLines(po: po!);
  }

  Future<Either<CommonError, ImtEntity>> submit(ImtEntity data) async {
    return receiptRepository.submitPoImt(data);
  }
}
