class Cache {
  static final Cache _singleton = Cache._internal();

  factory Cache() {
    return _singleton;
  }

  Cache._internal();

  final Map<String, dynamic> _cache = Map();

  static T handleCache<T>(String key, T getter()) {
    Cache c = Cache();
    T cacheValue = c._cache[key];

    if (cacheValue == null) {
      c._cache[key] = getter();
    }

    return c._cache[key];
  }
}
