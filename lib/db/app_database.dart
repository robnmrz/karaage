import 'dart:convert';

import 'package:mango/api/models.dart';
import 'package:mango/db/schema.dart';
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
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDB(fileName);
    return _database!;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $idField $idType,
        $nameField $textTypeNotNullable,
        $englishNameField $textTypeNullable,
        $thumbnailField $textTypeNotNullable,
        $lastChapterField $textTypeNotNullable,
        $lastChapterDateField $textTypeNullable,
        $scoreField $doubleTypeNullable,
        $ratingField $intTypeNullable,
        $availableChaptersField $intTypeNotNullable,
        $chaptersReadField $textTypeNullable,
        $chaptersReadTotalField $intTypeNullable,
        $lastChapterReadField $textTypeNullable,
        $isFavoriteField $boolType,
        $statusField $textTypeNullable
      )
      '''
    );
  }

  Future<int> insertManga(Manga manga) async {
    print(manga.toDbJson());
    final db = await instance.database;
    return await db.insert(
      'mangas',
      manga.toDbJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // return a list of mangas from db where isFavorite is true
  Future<List<Manga>> readFavoritedMangas() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'mangas',
      where: '$isFavoriteField = ?',  // Filter where isFavorite is 1 (true)
      whereArgs: [1],                 // 1 represents true in SQLite
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
      where: '$idField = ?',
      whereArgs: [mangaId],
    );
  }

  Future<void> updateChaptersRead(String mangaId, String newChapter) async {
    final db = await instance.database;

    // Retrieve current chaptersRead and chaptersReadTotal
    final List<Map<String, dynamic>> result = await db.query(
      'mangas',
      columns: [chaptersReadField, chaptersReadTotalField],
      where: '$idField = ?',
      whereArgs: [mangaId],
    );

    if (result.isNotEmpty) {
      String jsonString = result.first[chaptersReadField] as String;
      List<String> readChapters = List<String>.from(jsonDecode(jsonString));
      int currentTotal = result.first[chaptersReadTotalField] as int? ?? 0;

      // Increment chaptersReadTotal
      int updatedTotal = currentTotal + 1;

      // Add new chapter if not already in list
      if (!readChapters.contains(newChapter)) {
        readChapters.add(newChapter);

        // Update the database with the new list
        await db.update(
          'mangas',
          {
            chaptersReadField: jsonEncode(readChapters),
            chaptersReadTotalField: updatedTotal,
          },
          where: '$idField = ?',
          whereArgs: [mangaId],
        );
      }
    }
  }

  // get chapters read for a manga
  Future<List<String>> fetchChaptersRead(String mangaId) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.query(
      'mangas',
      columns: [chaptersReadField],
      where: '$idField = ?',
      whereArgs: [mangaId],
    );

    if (result.isNotEmpty) {
      String jsonString = result.first[chaptersReadField] as String;
      return List<String>.from(jsonDecode(jsonString));
    } else {
      return [];
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    return db.close();
  }
}
