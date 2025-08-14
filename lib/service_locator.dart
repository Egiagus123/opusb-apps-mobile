import 'dart:io';

import 'package:apps_mobile/features/core/data/datasource/attribute_set_datasource.dart';
import 'package:apps_mobile/features/core/data/datasource/attribute_set_datasource_impl.dart';
import 'package:apps_mobile/features/core/data/repository/attribute_set_repository_impl.dart';
import 'package:apps_mobile/features/core/domain/repository/attribute_set_repository.dart';
import 'package:apps_mobile/features/core/domain/usecase/attribute_set_usecase.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/data/datasource/imf_datasource.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/data/datasource/imf_datasource_impl.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/data/repository/imf_repository_impl.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/repository/imf_repository.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/usecase/imf_usecase.dart';
import 'package:apps_mobile/features/imf/om/data/datasource/om_datasource.dart';
import 'package:apps_mobile/features/imf/om/data/datasource/om_datasource_impl.dart';
import 'package:apps_mobile/features/imf/om/data/repository/om_repository_impl.dart';
import 'package:apps_mobile/features/imf/om/domain/repository/om_repository.dart';
import 'package:apps_mobile/features/imf/om/domain/usecase/om_usecase.dart';
import 'package:apps_mobile/features/imt/imt/data/datasource/imt_datasource.dart';
import 'package:apps_mobile/features/imt/imt/data/datasource/imt_datasource_impl.dart';
import 'package:apps_mobile/features/imt/imt/data/repository/imt_repository_impl.dart';
import 'package:apps_mobile/features/imt/imt/domain/repository/imt_repository.dart';
import 'package:apps_mobile/features/imt/imt/domain/usecase/imt_usecase.dart';
import 'package:apps_mobile/features/imt/om/data/datasource/om_datasource.dart';
import 'package:apps_mobile/features/imt/om/data/datasource/om_datasource_impl.dart';
import 'package:apps_mobile/features/imt/om/data/repository/om_repository_impl.dart';
import 'package:apps_mobile/features/imt/om/domain/repository/om_repository.dart';
import 'package:apps_mobile/features/imt/om/domain/usecase/om_usecase.dart';
import 'package:apps_mobile/features/mr/po/data/datasource/po_datasource.dart';
import 'package:apps_mobile/features/mr/po/data/datasource/po_datasource_impl.dart';
import 'package:apps_mobile/features/mr/po/data/repository/po_repository_impl.dart';
import 'package:apps_mobile/features/mr/po/domain/repository/po_repository.dart';
import 'package:apps_mobile/features/mr/po/domain/usecase/po_usecase.dart';
import 'package:apps_mobile/features/mr/receipt/data/datasource/receipt_datasource.dart';
import 'package:apps_mobile/features/mr/receipt/data/datasource/receipt_datasource_impl.dart';
import 'package:apps_mobile/features/mr/receipt/data/repository/receipt_repository_impl.dart';
import 'package:apps_mobile/features/mr/receipt/domain/repository/receipt_repository.dart';
import 'package:apps_mobile/features/mr/receipt/domain/usecase/receipt_usecase.dart';
import 'package:apps_mobile/features/pi/services/inventory_service.dart';
import 'package:apps_mobile/features/pi/services/inventory_service_impl.dart';
import 'package:apps_mobile/features/pi/states/dispute_list_store.dart';
import 'package:apps_mobile/features/pi/states/inventory_form_store.dart';
import 'package:apps_mobile/features/pi/states/line_form_store.dart';
import 'package:apps_mobile/features/pi/states/line_list_store.dart';
import 'package:apps_mobile/features/shipment/shipment/data/datasource/shipment_datasource.dart';
import 'package:apps_mobile/features/shipment/shipment/data/datasource/shipment_datasource_impl.dart';
import 'package:apps_mobile/features/shipment/shipment/data/repository/shipment_repository_impl.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/repository/shipment_repository.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/usecase/shipment_usecase.dart';
import 'package:apps_mobile/features/shipment/so/data/datasource/so_datasource.dart';
import 'package:apps_mobile/features/shipment/so/data/datasource/so_datasource_impl.dart';
import 'package:apps_mobile/features/shipment/so/data/repository/so_repository_impl.dart';
import 'package:apps_mobile/features/shipment/so/domain/repository/so_repository.dart';
import 'package:apps_mobile/features/shipment/so/domain/usecase/so_usecase.dart';
import 'package:apps_mobile/services/inventory/alert_note/alert_note_service.dart';
import 'package:apps_mobile/services/inventory/alert_note/alert_note_service_impl.dart';
import 'package:apps_mobile/services/inventory/approval/approval_service.dart';
import 'package:apps_mobile/services/inventory/approval/approval_service_impl.dart';
import 'package:apps_mobile/services/inventory/chart/chart_service.dart';
import 'package:apps_mobile/services/inventory/chart/chart_service_impl.dart';
import 'package:apps_mobile/services/inventory/dashboard/dashboard_service.dart';
import 'package:apps_mobile/services/inventory/dashboard/dashboard_service_impl.dart';
import 'package:apps_mobile/services/inventory/watchlist/watchlist_service.dart';
import 'package:apps_mobile/services/inventory/watchlist/whatchlist_service_impl.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:dio/dio.dart';
import 'package:apps_mobile/services/assetaudit/asset_audit_service.dart';
import 'package:apps_mobile/services/assetaudit/asset_audit_service_impl.dart';
import 'package:apps_mobile/services/assettracking/asset_tracking_service.dart';
import 'package:apps_mobile/services/assettracking/asset_tracking_service_impl.dart';
import 'package:apps_mobile/services/assettrf/asset_trf_service_impl.dart';
import 'package:apps_mobile/services/offlineservices/offline_service.dart';
import 'package:apps_mobile/services/offlineservices/offline_service_impl.dart';
import 'package:apps_mobile/services/woservice/woservice_service.dart';
import 'package:apps_mobile/services/woservice/woservice_service_impl.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:apps_mobile/business_logic/models/login_credential.dart';
import 'package:apps_mobile/business_logic/models/login_parameters.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'business_logic/exceptions/http_code_exception.dart';
import 'business_logic/exceptions/server_exception.dart';
import 'business_logic/models/http_status_code.dart';
import 'business_logic/platform/network_info.dart';
import 'business_logic/utils/constants.dart';
import 'business_logic/utils/keys.dart';
import 'business_logic/utils/logger.dart';

import 'services/assettrf/asset_trf_service.dart';
import 'services/auth/auth_service.dart';
import 'services/auth/auth_service_impl.dart';
import 'services/downloaddata/downloaddata_service.dart';
import 'services/downloaddata/downloaddata_service_impl.dart';
import 'services/setup/setup_service.dart';
import 'services/setup/setup_service_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Context().appName = packageInfo.appName;
  Context().packageName = packageInfo.packageName;
  Context().version = packageInfo.version;
  Context().buildNumber = packageInfo.buildNumber;

  //! AUTH
  sl.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<SetupService>(
    () => SetupServiceImpl(
      dio: sl(),
      preferences: sl(),
    ),
  );

  //! ASSET TRACKING
  sl.registerLazySingleton<AssetTrackingService>(
    () => AssetTrackingServiceImpl(dio: sl()),
  );

  //! ASSET AUDIT
  sl.registerLazySingleton<AssetAuditService>(
    () => AssetAuditServiceImpl(dio: sl()),
  );

  //! ASSET TRANSFER
  sl.registerLazySingleton<AssetTransferService>(
    () => AssetTransferServiceImpl(dio: sl()),
  );

  //! Download Data
  sl.registerLazySingleton<DownloadDataService>(
    () => DownloadDataServiceImpl(dio: sl()),
  );
  //! ASSET Offline
  sl.registerLazySingleton<OfflineService>(
    () => OfflineServiceImpl(dio: sl()),
  );
  // NETWORK
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() {
    return DataConnectionChecker();
  });
  //! WO Service
  sl.registerLazySingleton<WOServiceService>(
    () => WOServiceImpl(dio: sl()),
  );

  //Homepage
  sl.registerLazySingleton<DashboardService>(
    () => DashboardServiceImpl(dio: sl()),
  );
  sl.registerLazySingleton<ChartService>(
    () => ChartServiceImpl(dio: sl()),
  );
  sl.registerLazySingleton<WatchlistService>(
    () => WatchlistServiceImpl(dio: sl()),
  );

  //! Approval
  sl.registerLazySingleton<ApprovalService>(
    () => ApprovalServiceImpl(dio: sl()),
  );

  //! ALERT NOTE
  sl.registerLazySingleton<AlertNoteService>(
    () => AlertNoteServiceImpl(dio: sl()),
  );

  // SHIPMENT //

  // ---Register Shipment UseCase---
  sl.registerLazySingleton(() => SoUseCase(sl()));
  sl.registerLazySingleton(() => ShipmentUseCase(sl()));
  sl.registerLazySingleton(() => AttributeSetUseCase(sl()));

  // ---Register Shipment Repository---
  sl.registerLazySingleton<SoRepository>(
      () => SoRepositoryImpl(soDataSource: sl()));

  sl.registerLazySingleton<ShipmentRepository>(() =>
      ShipmentRepositoryImpl(poDataSource: sl(), shipmentDataSource: sl()));

  sl.registerLazySingleton<AttributeSetRepository>(
      () => AttributeSetRepositoryImpl(attributeSetDataSource: sl()));

  // ---Register Shipment DataSource---
  sl.registerLazySingleton<SoDataSource>(
      () => SoDataSourceImpl(dio: sl(), secureStorage: sl()));

  sl.registerLazySingleton<ShipmentDataSource>(
      () => ShipmentDataSourceImpl(dio: sl(), secureStorage: sl()));

  sl.registerLazySingleton<AttributeSetDataSource>(
      () => AttributeSetDataSourceImpl(dio: sl(), secureStorage: sl()));

  // MATERIAL RECEIPT //

  // ---Register Receipt UseCase---
  sl.registerLazySingleton(() => PoUseCase(sl()));
  sl.registerLazySingleton(() => ReceiptUseCase(sl()));

  // ---Register Receipt Repository---
  sl.registerLazySingleton<PoRepository>(
      () => PoRepositoryImpl(poDataSource: sl()));

  sl.registerLazySingleton<ReceiptRepository>(
      () => ReceiptRepositoryImpl(poDataSource: sl(), receiptDataSource: sl()));

  // ---Register Shipment DataSource---
  sl.registerLazySingleton<PoDataSource>(
      () => PoDataSourceImpl(dio: sl(), secureStorage: sl()));

  sl.registerLazySingleton<ReceiptDataSource>(
      () => ReceiptDataSourceImpl(dio: sl(), secureStorage: sl()));

  // IMT //
  // .. usecase //
  sl.registerLazySingleton(() => OmUseCase(sl<OmRepository>()));
  sl.registerLazySingleton(() => ImtUseCase(sl<ImtRepository>()));
  // .. repository //
  sl.registerLazySingleton<OmRepository>(
      () => OmRepositoryImpl(poDataSource: sl<OmDataSource>()));

  sl.registerLazySingleton<ImtRepository>(() => ImtRepositoryImpl(
      poDataSource: sl<OmDataSource>(),
      receiptDataSource: sl<ImtDataSource>()));
  // .. datasource //
  sl.registerLazySingleton<OmDataSource>(() => OmDataSourceImpl(
      dio: sl<Dio>(), secureStorage: sl<FlutterSecureStorage>()));

  sl.registerLazySingleton<ImtDataSource>(() => ImtDataSourceImpl(
      dio: sl<Dio>(), secureStorage: sl<FlutterSecureStorage>()));

  // IMF //
  // .. usecase //
  sl.registerLazySingleton(() => OmIMFUseCase(sl()));
  sl.registerLazySingleton(() => ImfUseCase(sl()));

  // .. repository //
  sl.registerLazySingleton<OmIMFRepository>(() => OmIMFRepositoryImpl(
      omDataSource: sl(), secureStorage: sl<FlutterSecureStorage>()));
  sl.registerLazySingleton<ImfRepository>(
      () => ImfRepositoryImpl(poDataSource: sl(), receiptDataSource: sl()));

  // .. datasource //
  sl.registerLazySingleton<ImfDataSource>(
      () => ImfDataSourceImpl(dio: sl(), secureStorage: sl()));

  sl.registerLazySingleton<OmIMFDataSource>(
      () => OmIMFDataSourceImpl(dio: sl(), secureStorage: sl()));

  // PHYSICAL INV
  // services
  sl.registerLazySingleton<InventoryService>(
      () => InventoryServiceImpl(dio: sl()));
  // states
  sl.registerFactory(() => InventoryFormStore(inventoryService: sl()));
  sl.registerFactory(() => LineListStore(inventoryService: sl()));
  sl.registerFactory(() => LineFormStore(inventoryService: sl()));
  sl.registerFactory(() => DisputeListStore(inventoryService: sl()));

  //! CORE
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => FlutterSecureStorage());

  sl.registerLazySingleton(() {
    String host = sl<SharedPreferences>().getString(Keys.authHost) ?? '';

    if (host.contains("")) {
      host = "poc-1.opusb.co.id";
    }
    final BaseOptions options = BaseOptions(
        baseUrl: 'https://$host/api/v1', headers: {"apikey": "apiberca2021"});

    Dio dio = Dio(options);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        final method = options.method;
        final uri = options.uri;
        final path = uri.path;

        options.headers[HttpHeaders.contentTypeHeader] ??=
            Headers.jsonContentType;
        options.headers[HttpHeaders.acceptHeader] ??= Headers.jsonContentType;

        if (path.contains('/auth/tokens') && method == 'POST') {
          // no token required
        } else {
          final token = await sl<FlutterSecureStorage>()
              .read(key: AuthKey.token.toString());
          options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
        }

        handler.next(options); // lanjutkan request
      },
      onResponse:
          (Response response, ResponseInterceptorHandler handler) async {
        handler.next(response); // lanjutkan response
      },
      onError: (DioException de, ErrorInterceptorHandler handler) async {
        final log = getLogger('DioError');
        final response = de.response;
        final useCase = sl<AuthService>();
        final storage = sl<FlutterSecureStorage>();

        final userName = await storage.read(key: AuthKey.username.toString());
        final password = await storage.read(key: AuthKey.password.toString());
        final clientId = await storage.read(key: AuthKey.clientId.toString());
        final roleId = await storage.read(key: AuthKey.roleId.toString());

        log.e(de);
        log.e('Path: ${de.requestOptions.path}');
        log.e('Data: ${de.requestOptions.data}');

        if (de.type == DioExceptionType.badResponse) {
          String message = de.message ?? '';
          if (response != null && response.data.toString().isNotEmpty) {
            message = HttpStatusCode.fromJson(response.data)?.detail ?? message;
          }

          if (response?.statusCode == 403) {
            handler.reject(DioException(
              requestOptions: de.requestOptions,
              error: HttpCodeException('Forbidden Access. $message'),
              response: response,
            ));
          } else if (response?.statusCode == 401) {
            // Refresh token dan retry request
            await useCase.authenticate(
                LoginCredential(userName: userName!, password: password!));
            await useCase.authorize(LoginParameters(
              clientId: int.parse(clientId!),
              roleId: int.parse(roleId!),
            ));

            final opts = de.requestOptions;
            final clonedResponse = await dio.request(
              opts.path,
              data: opts.data,
              options: Options(
                method: opts.method,
                headers: opts.headers,
              ),
            );

            handler.resolve(clonedResponse); // lanjutkan dengan response retry
          } else {
            handler.reject(DioException(
              requestOptions: de.requestOptions,
              error: ServerException(message),
              response: response,
            ));
          }
        } else {
          handler.reject(DioException(
            requestOptions: de.requestOptions,
            error: ServerException(de.message ?? 'Unknown Error'),
          ));
        }
      },
    ));

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };

    return dio;
  });
  Future<void> _refreshToken(RequestOptions options) async {
    try {
      final storage = sl<FlutterSecureStorage>();
      final userName = await storage.read(key: AuthKey.username.toString());
      final password = await storage.read(key: AuthKey.password.toString());
      final clientId = await storage.read(key: AuthKey.clientId.toString());
      final roleId = await storage.read(key: AuthKey.roleId.toString());

      final useCase = sl<AuthService>();

      // Tunggu autentikasi
      await useCase.authenticate(LoginCredential(
        userName: userName!,
        password: password!,
      ));

      // Tunggu otorisasi
      await useCase.authorize(LoginParameters(
        clientId: int.parse(clientId!),
        roleId: int.parse(roleId!),
      ));
    } catch (e) {
      // Handle error kalau mau
      rethrow;
    }
  }
}
