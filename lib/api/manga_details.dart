import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:karaage/api/models.dart';
import 'package:karaage/api/query.dart';

// define the API base URL, referer and user agent for allmanga.to
const String apiBaseUrl = "https://api.allanime.day/api";
const String referer = "https://allmanga.to";
const String agent =
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0";

Future<MangaDetailsResponse> getMangaDetails({required String id}) async {
  Uri apiUrl = generateMangaDetailsUri(id: id);
  try {
    final response = await http.get(
      apiUrl,
      headers: {'Referer': referer, 'User-Agent': agent},
    );
    if (response.statusCode == 200) {
      return MangaDetailsResponse.fromJson(jsonDecode(response.body));
    } else {
      print('Details Error: ${response.statusCode}');
      return MangaDetailsResponse.empty();
    }
  } catch (e) {
    print('Details Exception: $e');
    return MangaDetailsResponse.empty();
  }
}

Uri generateMangaDetailsUri({required String id}) {
  Map<String, dynamic> searchInput = {"allowUnknown": false};

  // Construct the variables map
  Map<String, dynamic> variables = {"_id": id, "search": searchInput};
  // Convert the variables map to a JSON string
  String encodedVariables = jsonEncode(variables);

  // Remove extra spaces and new lines from the query string for cleaner output
  String compactQuery =
      mangaDetailsQuery.replaceAll("\n", " ").replaceAll("  ", " ").trim();

  // Encode the query for URL safety
  String encodedQuery = Uri.encodeComponent(compactQuery);

  // Construct the final request Uri
  return Uri.parse(
    "$apiBaseUrl?variables=$encodedVariables&query=$encodedQuery",
  );
}

// void main() async {
//   MangaDetailsResponse response = await getMangaDetails(id: "bjKg6rj5rh539Wfey");
//   print(response.rawData);
// }
