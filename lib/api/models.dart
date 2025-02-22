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
  final String pictureUrlHead;

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
}

class LastChapterDate {
  final LastChapterDateMeta sub;

  LastChapterDate({required this.sub});

  factory LastChapterDate.fromJson(Map<String, dynamic> json) {
    return LastChapterDate(
      sub: LastChapterDateMeta.fromJson(json['sub']),
    );
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

}

class LastChapterInfo {
  final LastChapterInfoMeta sub;

  LastChapterInfo({required this.sub});

  factory LastChapterInfo.fromJson(Map<String, dynamic> json) {
    return LastChapterInfo(
      sub: LastChapterInfoMeta.fromJson(json['sub']),
    );
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
  final double? score;
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
  final List<dynamic> raw;

  AvailableChaptersDetail({required this.sub, required this.raw});

  factory AvailableChaptersDetail.fromJson(Map<String, dynamic> json) {
    return AvailableChaptersDetail(
      sub: json['sub'],
      raw: json['raw'],
    );
  }
}
class Manga {
  final String id;
  final String name;
  final String? englishName;
  final String thumbnail;
  final LastChapterInfo lastChapterInfo;
  final LastChapterDate lastChapterDate;
  final double? score;
  final AvailableChapters availableChapters;
  final String? description;
  final List<dynamic> genres;
  final String? status;
  final int? averageScore;
  final String? banner;
  final AvailableChaptersDetail availableChaptersDetail;
  final List<dynamic> tags;

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
  });

  // getter to check if description is given and not empty string
  bool get hasDescription => description != null && description != '';

  // getter to check if banner is given and not empty string
  bool get hasBanner => banner != null && banner != '';

  // Factory constructor returning a default "empty" instance
  factory Manga.empty() {
    return Manga(
      id: '',
      name: '',
      englishName: '',
      thumbnail: '',
      lastChapterInfo: LastChapterInfo.fromJson({"sub": {"chapterString": "", "pictureUrlsProcessed": 0}}),
      lastChapterDate: LastChapterDate.fromJson({"sub": {"year": 0, "month": 0, "date": 0, "hour": 0, "minute": 0}}),
      score: 0,
      availableChapters: AvailableChapters.fromJson({"sub": 0, "raw": 0}),
      description: '',
      genres: [],
      status: '',
      averageScore: 0,
      banner: '',
      availableChaptersDetail: AvailableChaptersDetail.fromJson({"sub": [], "raw": []}),
      tags: [],
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
      description: json['description'],
      genres: json['genres'],
      status: json['status'],
      averageScore: json['averageScore'],
      banner: json['banner'],
      availableChaptersDetail: AvailableChaptersDetail.fromJson(json['availableChaptersDetail']),
      tags: json['tags'],
    );
  }
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
