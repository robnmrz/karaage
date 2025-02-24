class TempStoreProvider {
  static final TempStoreProvider _instance = TempStoreProvider._internal();
  
  factory TempStoreProvider() {
    return _instance;
  }

  TempStoreProvider._internal();

  Set<String> viewedChapters = {};
}

final tempStoreProvider = TempStoreProvider();
