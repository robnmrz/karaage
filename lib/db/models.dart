// Model Extension for Manga class for db operations
import 'package:karaage/api/models.dart';

extension MangaDBExtension on Manga {
  Map<String, dynamic> toDbJson() {
    return {
      'mangaId': id,
      'name': name,
      'englishName': englishName,
      'thumbnail': thumbnail,
      'lastChapter': lastChapterInfo.sub.chapterString,
      'lastChapterDate':
          lastChapterDate.sub.year * 10000000000 + // save in milliseconds
          lastChapterDate.sub.month * 100000000 +
          lastChapterDate.sub.date * 1000000 +
          lastChapterDate.sub.hour * 10000 +
          lastChapterDate.sub.minute * 100,
      'availableChapters': availableChapters.sub,
      'score': score,
      'status': status,
      'averageScore': averageScore,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  static Manga fromDbJson(Map<String, dynamic> json) {
    return Manga(
      id: json['mangaId'],
      name: json['name'],
      englishName: json['englishName'],
      thumbnail: json['thumbnail'],
      lastChapterInfo: LastChapterInfo(
        sub: LastChapterInfoMeta(
          chapterString: json['lastChapter'],
          pictureUrlsProcessed: 0,
        ),
      ),
      lastChapterDate: LastChapterDate(
        sub: LastChapterDateMeta(
          year: json['lastChapterDate'] ~/ 10000000000,
          month: (json['lastChapterDate'] % 10000000000) ~/ 100000000,
          date: (json['lastChapterDate'] % 100000000) ~/ 1000000,
          hour: (json['lastChapterDate'] % 1000000) ~/ 10000,
          minute: (json['lastChapterDate'] % 10000) ~/ 100,
        ),
      ),
      availableChapters: AvailableChapters(
        sub: json['availableChapters'],
        raw: 0,
      ),
      score: json['score'],
      status: json['status'],
      averageScore: json['averageScore'],
      isFavorite: json['isFavorite'] == 1,
      authors: [],
      tags: [],
      genres: [],
      banner: "",
      description: "N/A",
      availableChaptersDetail: AvailableChaptersDetail.fromJson({"sub": []}),
    );
  }
}
