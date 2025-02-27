class TempStoreProvider {
  static final TempStoreProvider _instance = TempStoreProvider._internal();
  
  factory TempStoreProvider() {
    return _instance;
  }

  TempStoreProvider._internal();

  Set<String> viewedChapters = {};
  Set<String> savedMangas = {};
}

final tempStoreProvider = TempStoreProvider();
