// GraphQL query for chapter pages
String chapterPagesQuery = '''
  query (\$mangaId: String!, \$translationType: VaildTranslationTypeMangaEnumType!, \$chapterString: String!) {
    chapterPages(mangaId: \$mangaId, translationType: \$translationType, chapterString: \$chapterString) { 
      edges { 
        chapterString 
        pictureUrls 
        pictureUrlsProcessed 
        pictureUrlHead 
      } 
    } 
  }
''';

// GraphQL query for manga search
String mangaSearchQuery = '''
  query (\$search: SearchInput!, \$limit: Int, \$page: Int \$translationType: VaildTranslationTypeMangaEnumType!, \$countryOrigin: VaildCountryOriginEnumType!) {
    mangas(search: \$search, limit: \$limit, page: \$page, translationType: \$translationType, countryOrigin: \$countryOrigin) {
      edges {
        _id
        name
        englishName
        thumbnail
        lastChapterInfo 
        lastChapterDate
        chapterCount
        score
        availableChapters
        lastUpdateEnd
      }
    } 
  }
''';

// GraphQL query for manga details
String mangaDetailsQuery = '''
  query (\$_id: String! \$search: SearchInput!) {
    manga(_id: \$_id, search: \$search) {
      _id
      name
      englishName
      thumbnail
      lastChapterInfo 
      lastChapterDate
      score
      availableChapters
      description
      genres
      status
      averageScore
      banner
      availableChaptersDetail
      tags
      authors
    } 
  }
''';
