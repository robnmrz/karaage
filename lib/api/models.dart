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

  factory ChapterPages.fromJson(Map<String, dynamic> json) {
    return ChapterPages(
      edges: (json['edges'] as List)
          .map((edge) => ChapterEdge.fromJson(edge))
          .toList(),
    );
  }
}

// Model for the entire API response
class ApiResponse {
  final ChapterPages chapterPages;

  ApiResponse({required this.chapterPages});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      chapterPages: ChapterPages.fromJson(json['data']['chapterPages']),
    );
  }
}
