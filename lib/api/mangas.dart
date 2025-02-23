import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'package:mango/api/models.dart';
import 'package:mango/api/query.dart';

// define the API base URL, referer and user agent for allmanga.to
const String apiBaseUrl = "https://api.allanime.day/api";
const String referer = "https://allmanga.to";
const String agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0";

Future<MangaSearchResponse> searchMangas({
  required String searchTerm,
  String translationType = "sub",
  int limit = 16,
}) async {
  Uri apiUrl = generateMangaSearchUri(
    searchTerm: searchTerm,
    translationType: translationType,
    limit: limit,
  );
  try {
    final response = await http.get(
      apiUrl,
      headers: {
        'Referer': referer,
        'User-Agent': agent,
      },
    );
    if (response.statusCode == 200) {
      return MangaSearchResponse.fromJson(jsonDecode(response.body));
    } else {
      print('Search Error: ${response.statusCode}');
      return MangaSearchResponse(rawData: {}, mangas: Mangas(edges: []));
    }
  } catch (e) {
    print('Search Exception: $e');
    return MangaSearchResponse(rawData: {}, mangas: Mangas(edges: []));
  }
}

Uri generateMangaSearchUri({
  required String searchTerm,
  required String translationType,
  int limit = 26,
}) {

  Map<String, dynamic> searchInput = {
    "query": searchTerm,
    "isManga": true,
    "allowUnknown":false
  };
  
  // Construct the variables map
  Map<String, dynamic> variables = {
    "search": searchInput,
    "limit": limit, 
    "page": 1, 
    "translationType": translationType,
    "countryOrigin": "ALL",
  };
  // Convert the variables map to a JSON string
  String encodedVariables = jsonEncode(variables);
  
  // Remove extra spaces and new lines from the query string for cleaner output
  String compactQuery = mangaSearchQuery.replaceAll("\n", " ").replaceAll("  ", " ").trim();
  
  // Encode the query for URL safety
  String encodedQuery = Uri.encodeComponent(compactQuery);

  // Construct the final request Uri
  return Uri.parse("$apiBaseUrl?variables=$encodedVariables&query=$encodedQuery");
}

// void main() async {
//   MangaSearchResponse response = await searchMangas(searchTerm: "Conan");
//   print(response.rawData);
// }
