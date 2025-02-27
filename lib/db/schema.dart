// table name
const String tableName = "mangas";

// column names
const String idField = "_id";
const String nameField = "name";
const String englishNameField = "englishName";
const String thumbnailField = "thumbnail";
const String lastChapterField = "lastChapter";
const String lastChapterDateField = "lastChapterDate";
const String scoreField = "score";
const String ratingField = "averageScore";
const String availableChaptersField = "availableChapters";
const String chaptersReadField = "chaptersRead";
const String chaptersReadTotalField = "chaptersReadTotal";
const String lastChapterReadField = "lastChapterRead";
const String isFavoriteField = "isFavorite";
const String statusField = "status";

// all columns
const List<String> mangaColumns = [
  idField,
  nameField,
  englishNameField,
  thumbnailField,
  lastChapterField,
  lastChapterDateField,
  scoreField,
  ratingField,
  availableChaptersField,
  chaptersReadField,
  chaptersReadTotalField,
  lastChapterReadField,
  isFavoriteField,
  statusField
];

// column types
const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
const String textTypeNotNullable = "TEXT NOT NULL";
const String textTypeNullable = "TEXT";
const String intTypeNotNullable = "INTEGER NOT NULL";
const String intTypeNullable = "INTEGER";
const String doubleTypeNotNullable = "REAL NOT NULL";
const String doubleTypeNullable = "REAL";
const String boolType = "INTEGER DEFAULT 0";
