import 'package:dartz/dartz.dart';
import 'package:apps_mobile/features/core/domain/entity/attribute_set_instance.dart';
import 'package:apps_mobile/features/core/domain/entity/storage_entity.dart';
import 'package:apps_mobile/features/core/domain/repository/attribute_set_repository.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';

class AttributeSetUseCase {
  final AttributeSetRepository attributeSetRepository;

  AttributeSetUseCase(this.attributeSetRepository);

  Future<Either<CommonError, List<StorageEntity>>> getExistingInstances(
      int productId,
      {String? lot,
      String? serNo}) async {
    return attributeSetRepository.getInstances(productId,
        lot: lot!, serNo: serNo!);
  }

  Future<Either<CommonError, List<StorageEntity>>>
      getExistingInstancesWithLocator(int locator, int productId,
          {String? lot, String? serNo}) async {
    return attributeSetRepository.getInstancesWithLocator(locator, productId,
        lot: lot!, serNo: serNo!);
  }

  Future<Either<CommonError, List<StorageEntity>>> getExistInstancesWithLocator(
      int locator, int productId,
      {String? lot, String? serNo}) async {
    return attributeSetRepository.getInstancesWithLocator(locator, productId,
        lot: lot!, serNo: serNo!);
  }

  Future<Either<CommonError, AttributeSetInstance>> createInstance(
      AttributeSetInstance data) async {
    return attributeSetRepository.addInstance(data);
  }
}
