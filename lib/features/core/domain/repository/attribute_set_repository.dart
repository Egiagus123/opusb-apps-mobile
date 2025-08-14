import 'package:dartz/dartz.dart';
import 'package:apps_mobile/features/core/domain/entity/attribute_set_instance.dart';
import 'package:apps_mobile/features/core/domain/entity/storage_entity.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';

abstract class AttributeSetRepository {
  Future<Either<CommonError, List<StorageEntity>>> getInstances(int productId,
      {String lot, String serNo});

  Future<Either<CommonError, AttributeSetInstance>> addInstance(
      AttributeSetInstance data);

  Future<Either<CommonError, List<StorageEntity>>> getInstancesWithLocator(
      int locator, int productId,
      {String lot, String serNo});
  Future<Either<CommonError, List<StorageEntity>>> getInstancesWithLocator2(
      int locator, int productId,
      {String lot, String serNo});
}
