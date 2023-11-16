import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

///This provider dioClient with interceptors(TimeResponseInterceptor,FormDataInterceptor,TalkerDioLogger,DefaultAPIInterceptor)
///with fixing bad certificate.
///
final talker = TalkerFlutter.init(
  settings: TalkerSettings(
    maxHistoryItems: null,
    useConsoleLogs: !kReleaseMode,
    enabled: !kReleaseMode,
  ),
  logger: TalkerLogger(
    output: debugPrint,
    settings: const TalkerLoggerSettings(),
  ),
);
