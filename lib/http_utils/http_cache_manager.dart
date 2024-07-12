library http_cache_manager;


import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class HttpCacheManager {
  static const key = 'httpCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: key),
    ),
  );
}