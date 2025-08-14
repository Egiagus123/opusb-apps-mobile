import 'package:uuid/uuid.dart';

final uuid = Uuid();

String generateUuidV4() => uuid.v4();