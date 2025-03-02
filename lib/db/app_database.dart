import 'package:karaage/api/models.dart';
import 'package:karaage/db/models.dart';
import 'package:karaage/db/schema.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String fileName = "mango.db";

class AppDatabase {
  AppDatabase._init();

  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  Future<Database> _initializeDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    // // ✅ Delete existing database before opening the new one
    // if (await databaseExists(dbPath)) {
    //   await deleteDatabase(dbPath);
    //   print("Old database deleted.");
    // }

    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _createDB,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDB(fileName);
    return _database!;
  }

  Future _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys=ON;");
  }

  Future _createDB(Database db, int version) async {
    await db.execute('DROP TABLE IF EXISTS $tableName;');
    await db.execute('DROP TABLE IF EXISTS $chaptersReadTableName;');

    await db.execute('''
      CREATE TABLE $tableName (
        $mangaIdField $idType,
        $nameField $textTypeNotNullable,
        $englishNameField $textTypeNullable,
        $thumbnailField $textTypeNotNullable,
        $lastChapterField $textTypeNotNullable,
        $lastChapterDateField $intTypeNullable,
        $scoreField $doubleTypeNullable,
        $statusField $textTypeNullable,
        $ratingField $intTypeNullable,
        $availableChaptersField $intTypeNotNullable,
        $isFavoriteField $boolType
      )
    ''');

    await db.execute('''
      CREATE TABLE $chaptersReadTableName (
        $mangaIdField $textTypeNotNullable,
        $chapterStringField $textTypeNotNullable,
        $chapterDoubleField $doubleTypeNotNullable,
        PRIMARY KEY ($mangaIdField, $chapterStringField),
        FOREIGN KEY ($mangaIdField) REFERENCES $tableName ($mangaIdField) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertManga(Manga manga) async {
    final db = await instance.database;
    try {
      int result = await db.insert(
        'mangas',
        manga.toDbJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      return result;
    } catch (e) {
      print('Insert Exception: $e');
      return 0;
    }
  }

  // get manga by id
  Future<Manga?> getMangaById(String mangaId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'mangas',
      where: '$mangaIdField = ?',
      whereArgs: [mangaId],
    );
    if (maps.isNotEmpty) {
      return MangaDBExtension.fromDbJson(maps.first);
    }
    return null;
  }

  // return a list of mangas from db where isFavorite is true
  Future<List<Manga>> readFavoritedMangas() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'mangas',
      where: '$isFavoriteField = ?', // Filter where isFavorite is 1 (true)
      whereArgs: [1], // 1 represents true in SQLite
      orderBy: '$nameField ASC',
    );

    return List.generate(maps.length, (i) {
      return MangaDBExtension.fromDbJson(maps[i]);
    });
  }

  Future<void> updateIsFavorite(String mangaId, bool isFavorite) async {
    final db = await instance.database;

    await db.update(
      'mangas',
      {
        isFavoriteField: isFavorite ? 1 : 0, // Convert bool to int
      },
      where: '$mangaIdField = ?',
      whereArgs: [mangaId],
    );
  }

  // get all mangas from db
  Future<List<Manga>> fetchAllMangas() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('mangas');
    return List.generate(maps.length, (i) {
      return MangaDBExtension.fromDbJson(maps[i]);
    });
  }

  Future<int> insertReadChapter(String mangaId, String chapter) async {
    final db = await instance.database;
    try {
      int result = await db.insert(chaptersReadTableName, {
        mangaIdField: mangaId,
        chapterStringField: chapter,
        chapterDoubleField: double.parse(chapter),
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      return result;
    } catch (e) {
      print('Insert read chapter exception: $e');
      return 0;
    }
  }

  Future<List<String>> getReadChaptersByMangaId(String mangaId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      chaptersReadTableName,
      where: '$mangaIdField = ?',
      whereArgs: [mangaId],
      orderBy: '$chapterDoubleField DESC',
    );

    return maps.map((map) => map[chapterStringField] as String).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    return db.close();
  }
}
