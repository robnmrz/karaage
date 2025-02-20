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
