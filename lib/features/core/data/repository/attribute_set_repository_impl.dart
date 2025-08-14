import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/data/datasource/attribute_set_datasource.dart';
import 'package:apps_mobile/features/core/data/model/attribute_set_instance_model.dart';
import 'package:apps_mobile/features/core/data/model/storage_model.dart';
import 'package:apps_mobile/features/core/domain/entity/attribute_set_instance.dart';
import 'package:apps_mobile/features/core/domain/entity/storage_entity.dart';
import 'package:apps_mobile/features/core/domain/repository/attribute_set_repository.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:dartz/dartz.dart';

class AttributeSetRepositoryImpl implements AttributeSetRepository {
  final AttributeSetDataSource _attributeSetDataSource;

  AttributeSetRepositoryImpl(
      {required AttributeSetDataSource attributeSetDataSource})
      : _attributeSetDataSource = attributeSetDataSource;

  @override
  Future<Either<CommonError, List<StorageEntity>>> getInstances(int productId,
      {String? lot, String? serNo}) async {
    // Nullable untuk lot dan serNo
    try {
      final data = await _attributeSetDataSource.getExistingInstances(productId,
          lot: lot!, serNo: serNo!);
      final result = data.map((asi) => StorageModel.fromJson(asi)).toList();
      return Right(result);
    } on UnauthorizedException catch (_) {
      return Left(ClientError(message: 'Session expired. Please login'));
    } on ServerException catch (e) {
      return Left(ServerError(message: e.message));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  @override
  Future<Either<CommonError, List<StorageEntity>>> getInstancesWithLocator(
      int locator, int productId,
      {String? lot, String? serNo}) async {
    // Nullable untuk lot dan serNo
    try {
      final data = await _attributeSetDataSource
          .getExistingInstancesWithLocator(locator, productId,
              lot: lot!, serNo: serNo!);
      final result = data.map((asi) => StorageModel.fromJson(asi)).toList();
      return Right(result);
    } on UnauthorizedException catch (_) {
      return Left(ClientError(message: 'Session expired. Please login'));
    } on ServerException catch (e) {
      return Left(ServerError(message: e.message));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  @override
  Future<Either<CommonError, List<StorageEntity>>> getInstancesWithLocator2(
      int locator, int productId,
      {String? lot, String? serNo}) async {
    // Nullable untuk lot dan serNo
    try {
      final data = await _attributeSetDataSource.getExistInstancesWithLocator(
          locator, productId,
          lot: lot!, serNo: serNo!);
      final result = data.map((asi) => StorageModel.fromJson(asi)).toList();
      return Right(result);
    } on UnauthorizedException catch (_) {
      return Left(ClientError(message: 'Session expired. Please login'));
    } on ServerException catch (e) {
      return Left(ServerError(message: e.message));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  @override
  Future<Either<CommonError, AttributeSetInstance>> addInstance(
      AttributeSetInstance data) async {
    try {
      if (data is AttributeSetInstanceModel) {
        final json = await _attributeSetDataSource.create(data.toJson());
        return Right(AttributeSetInstanceModel.fromJson(json));
      } else {
        return Left(UnknownError(message: "Invalid instance model"));
      }
    } on UnauthorizedException catch (_) {
      return Left(ClientError(message: 'Session expired. Please login'));
    } on ServerException catch (e) {
      return Left(ServerError(message: e.message));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }
}
