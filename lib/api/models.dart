import 'dart:convert';

import 'package:mango/api/utils.dart';

///////////////////////////////////////
// MANGA CHAPTER PAGES
///////////////////////////////////////
// Model for a single image with number and URL
class Picture {
  final int num;
  final String url;

  Picture({required this.num, required this.url});

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      num: json['num'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'num': num,
      'url': url,
    };
  }
}

// Model for a chapter edge containing images
class ChapterEdge {
  final String chapterString;
  final List<Picture> pictureUrls;
  final String pictureUrlsProcessed;
  final String? pictureUrlHead;

  ChapterEdge({
    required this.chapterString,
    required this.pictureUrls,
    required this.pictureUrlsProcessed,
    required this.pictureUrlHead,
  });

  factory ChapterEdge.fromJson(Map<String, dynamic> json) {
    return ChapterEdge(
      chapterString: json['chapterString'],
      pictureUrls: (json['pictureUrls'] as List)
          .map((pic) => Picture.fromJson(pic))
          .toList(),
      pictureUrlsProcessed: json['pictureUrlsProcessed'],
      pictureUrlHead: json['pictureUrlHead'],
    );
  }
}

// Model for Chapter Pages containing a list of edges
class ChapterPages {
  final List<ChapterEdge> edges;

  ChapterPages({required this.edges});

  // isEmpty getter to check if mangas is empty
  bool get isEmpty => edges.isEmpty;

  factory ChapterPages.fromJson(Map<String, dynamic> json) {
    return ChapterPages(
      edges: (json['edges'] as List)
          .map((edge) => ChapterEdge.fromJson(edge))
          .toList(),
    );
  }
}

// Model for the entire API response for chapter pages
class ChapterPagesResponse {
  final Map<String, dynamic> rawData;
  final ChapterPages chapterPages;

  ChapterPagesResponse({required this.chapterPages, required this.rawData});

  // isEmpty getter to check if chapterPages is empty
  bool get isEmpty => chapterPages.isEmpty;

  factory ChapterPagesResponse.fromJson(Map<String, dynamic> json) {
    return ChapterPagesResponse(
      rawData: json,
      chapterPages: ChapterPages.fromJson(json['data']['chapterPages']),
    );
  }
}

///////////////////////////////////////
// MANGA SEARCH MODELS
///////////////////////////////////////
class AvailableChapters {
  final int sub;
  final int raw;

  AvailableChapters({required this.sub, required this.raw});

  factory AvailableChapters.fromJson(Map<String, dynamic> json) {
    return AvailableChapters(
      sub: json['sub'],
      raw: json['raw'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub': sub,
      'raw': raw,
    };
  }
}

class LastChapterDateMeta{
  final int year;
  final int month;
  final int date;
  final int minute;
  final int hour;

  LastChapterDateMeta({required this.year, required this.month, required this.date, required this.minute, required this.hour});

  factory LastChapterDateMeta.fromJson(Map<String, dynamic> json) {
    return LastChapterDateMeta(
      year: json['year'],
      month: json['month'],
      date: json['date'],
      minute: json['minute'],
      hour: json['hour'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'date': date,
      'minute': minute,
      'hour': hour,
    };
  }
}

class LastChapterDate {
  final LastChapterDateMeta sub;

  LastChapterDate({required this.sub});

  factory LastChapterDate.fromJson(Map<String, dynamic> json) {
    return LastChapterDate(
      sub: LastChapterDateMeta.fromJson(json['sub']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub': sub.toJson(),
    };
  }
}

class LastChapterInfoMeta{
  final String chapterString;
  final int pictureUrlsProcessed;

  LastChapterInfoMeta({required this.chapterString, required this.pictureUrlsProcessed});

  factory LastChapterInfoMeta.fromJson(Map<String, dynamic> json) {
    return LastChapterInfoMeta(
      chapterString: json['chapterString'],
      pictureUrlsProcessed: json['pictureUrlsProcessed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapterString': chapterString,
      'pictureUrlsProcessed': pictureUrlsProcessed,
    };
  }
}

class LastChapterInfo {
  final LastChapterInfoMeta sub;

  LastChapterInfo({required this.sub});

  factory LastChapterInfo.fromJson(Map<String, dynamic> json) {
    return LastChapterInfo(
      sub: LastChapterInfoMeta.fromJson(json['sub']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub': sub.toJson(),
    };
  }
}

// Model for a manga edges 
class MangaEdge {
  final String id;
  final String name;
  final String? englishName;
  final String thumbnail;
  final LastChapterInfo lastChapterInfo;
  final LastChapterDate lastChapterDate;
  final String? chapterCount;
  final num? score;
  final AvailableChapters availableChapters;
  final String? lastUpdateEnd;

  MangaEdge({
    required this.id,
    required this.name,
    required this.englishName,
    required this.thumbnail,
    required this.lastChapterInfo,
    required this.lastChapterDate,
    required this.chapterCount,
    required this.score,
    required this.availableChapters,
    required this.lastUpdateEnd
  });

  factory MangaEdge.fromJson(Map<String, dynamic> json) {
    return MangaEdge(
      id: json['_id'],
      name: json['name'],
      englishName: json['englishName'],
      thumbnail: createThumbnailUrl(json['thumbnail']),
      lastChapterInfo: LastChapterInfo.fromJson(json['lastChapterInfo']),
      lastChapterDate: LastChapterDate.fromJson(json['lastChapterDate']),
      chapterCount: json['chapterCount'],
      score: json['score'],
      availableChapters: AvailableChapters.fromJson(json['availableChapters']),
      lastUpdateEnd: json['lastUpdateEnd'], 
    );
  }
}

class Mangas {
  final List<MangaEdge> edges;

  Mangas({required this.edges});

  // isEmpty getter to check if edges list is empty
  bool get isEmpty => edges.isEmpty;

  factory Mangas.fromJson(Map<String, dynamic> json) {
    return Mangas(
      edges: (json['edges'] as List)
          .map((edge) => MangaEdge.fromJson(edge))
          .toList(),
    );
  }
}

class MangaSearchResponse {
  final Map<String, dynamic> rawData;
  final Mangas mangas;

  MangaSearchResponse({required this.mangas, required this.rawData});  

  // isEmpty getter to check if mangas is empty
  bool get isEmpty => mangas.isEmpty;

  factory MangaSearchResponse.fromJson(Map<String, dynamic> json) {
    return MangaSearchResponse(
      rawData: json,
      mangas: Mangas.fromJson(json['data']['mangas']),
    );
  }
}

///////////////////////////////////////
// MANGA DETAILS
///////////////////////////////////////
class AvailableChaptersDetail {
  final List<dynamic> sub;

  AvailableChaptersDetail({required this.sub});

  factory AvailableChaptersDetail.fromJson(Map<String, dynamic> json) {
    return AvailableChaptersDetail(
      sub: json['sub'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub': sub,
    };
  }
}

class Manga {
  final String id;
  final String name;
  final String? englishName;
  final String thumbnail;
  final LastChapterInfo lastChapterInfo;
  final LastChapterDate lastChapterDate;
  final num? score;
  final AvailableChapters availableChapters;
  final String? description;
  final List<dynamic> genres;
  final String? status;
  final num? averageScore;
  final String? banner;
  final AvailableChaptersDetail availableChaptersDetail;
  final List<dynamic> tags;
  final List<dynamic> authors;
  final bool isFavorite;
  final List<String>? chaptersRead;
  final int? chaptersReadTotal;
  final String? lastChapterRead;

  Manga({
    required this.id,
    required this.name,
    required this.englishName,
    required this.thumbnail,
    required this.lastChapterInfo,
    required this.lastChapterDate,
    required this.score,
    required this.availableChapters,
    required this.description,
    required this.genres,
    required this.status,
    required this.averageScore,
    required this.banner,
    required this.availableChaptersDetail,
    required this.tags,
    required this.authors,
    required this.isFavorite,
    this.chaptersRead,
    this.chaptersReadTotal,
    this.lastChapterRead
  });

  // getter to check if banner is given and not empty string
  bool get hasBanner => banner != null && banner != '';

  // getter to check if englishName is given and not empty string
  bool get hasEnglishName => englishName != null && englishName != '';

  // Factory constructor returning a default "empty" instance
  factory Manga.empty() {
    return Manga(
      id: "_empty",
      name: "N/A",
      englishName: "N/A",
      thumbnail: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250",
      lastChapterInfo: LastChapterInfo.fromJson({"sub": {"chapterString": "0", "pictureUrlsProcessed": 0}}),
      lastChapterDate: LastChapterDate.fromJson({"sub": {"year": 0, "month": 0, "date": 0, "hour": 0, "minute": 0}}),
      score: 0,
      availableChapters: AvailableChapters.fromJson({"sub": 0, "raw": 0}),
      description: "N/A",
      genres: [],
      status: "N/A",
      averageScore: 0,
      banner: "N/A",
      availableChaptersDetail: AvailableChaptersDetail.fromJson({"sub": [], "raw": []}),
      tags: [],
      authors: [],
      isFavorite: false,
    );
  }
  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['_id'],
      name: json['name'],
      englishName: json['englishName'],
      thumbnail: createThumbnailUrl(json['thumbnail']),
      lastChapterInfo: LastChapterInfo.fromJson(json['lastChapterInfo']),
      lastChapterDate: LastChapterDate.fromJson(json['lastChapterDate']),
      score: json['score'],
      availableChapters: AvailableChapters.fromJson(json['availableChapters']),
      description:  parseHtmlString(json['description']),
      genres: json['genres'],
      status: json['status'],
      averageScore: json['averageScore'],
      banner: json['banner'],
      availableChaptersDetail: AvailableChaptersDetail.fromJson(json['availableChaptersDetail']),
      tags: json['tags'],
      authors: json['authors'],
      isFavorite: false,
    );
  }

  // convert to json map
  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'englishName': englishName,
    'thumbnail': thumbnail,
    'lastChapterInfo': lastChapterInfo.toJson(),
    'lastChapterDate': lastChapterDate.toJson(),
    'score': score,
    'availableChapters': availableChapters.toJson(),
    'description': description,
    'genres': genres,
    'status': status,
    'averageScore': averageScore,
    'banner': banner,
    'availableChaptersDetail': availableChaptersDetail.toJson(),
    'tags': tags,
    'authors': authors,
    'isFavorite': isFavorite
  };
}

class MangaDetailsResponse {
  final Map<String, dynamic> rawData;
  final Manga manga;

  MangaDetailsResponse({required this.manga, required this.rawData});  

  // Factory constructor returning a default "empty" instance
  factory MangaDetailsResponse.empty() {
    return MangaDetailsResponse(
      rawData: {},
      manga: Manga.empty(),
    );
  }

  factory MangaDetailsResponse.fromJson(Map<String, dynamic> json) {
    return MangaDetailsResponse(
      rawData: json,
      manga: Manga.fromJson(json['data']['manga']),
    );
  }
}

extension MangaDBExtension on Manga {
  Map<String, dynamic> toDbJson() {
    return {
      'id': id,
      'name': name,
      'englishName': englishName,
      'thumbnail': thumbnail,
      'lastChapter': lastChapterInfo.sub.chapterString,
      'lastChapterDate': lastChapterDate.sub.year * 10000000000 + // save in milliseconds
          lastChapterDate.sub.month * 100000000 +
          lastChapterDate.sub.date * 1000000 +
          lastChapterDate.sub.hour * 10000 +
          lastChapterDate.sub.minute * 100,
      'availableChapters': availableChapters.sub,
      'score': score,
      'status': status,
      'averageScore': averageScore,
      'chaptersRead': jsonEncode([]),
      'chaptersReadTotal': 0,
      'isFavorite': isFavorite ? 1 : 0,
      'lastChapterRead': "",
    };  
  }

  static Manga fromDbJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'],
      name: json['name'],
      englishName: json['englishName'],
      thumbnail: json['thumbnail'],
      lastChapterInfo: LastChapterInfo(sub: LastChapterInfoMeta(chapterString: json['lastChapter'], pictureUrlsProcessed: 0)),
      lastChapterDate: LastChapterDate(sub: LastChapterDateMeta(
        year: json['lastChapterDate'] ~/ 10000000000,
        month: (json['lastChapterDate'] % 10000000000) ~/ 100000000,
        date: (json['lastChapterDate'] % 100000000) ~/ 1000000,
        hour: (json['lastChapterDate'] % 1000000) ~/ 10000,
        minute: (json['lastChapterDate'] % 10000) ~/ 100,
      )),
      availableChapters: AvailableChapters(sub: json['availableChapters'], raw: 0),
      score: json['score'],
      status: json['status'],
      averageScore: json['averageScore'],
      chaptersRead: json['chaptersRead'],
      chaptersReadTotal: json['chaptersReadTotal'],
      isFavorite: json['isFavorite'] == 1,
      lastChapterRead: json['lastChapterRead'],
      authors: [],
      tags: [],
      genres: [],
      banner: "",
      description: "N/A",
      availableChaptersDetail: AvailableChaptersDetail.fromJson({}),
    );
  } 
}
