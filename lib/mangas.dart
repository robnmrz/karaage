import 'package:flutter/material.dart';
import 'package:mango/api/mangas.dart';
import 'package:mango/api/models.dart';

class MangasSearchResult extends StatefulWidget{
  final String searchTerm;
  const MangasSearchResult({super.key, required this.searchTerm});

  @override
  State<MangasSearchResult> createState() => _MangasSearchResultState();
}

class _MangasSearchResultState extends State<MangasSearchResult> {
  // Async function to fetch magas based on searchterm
  Future<MangaSearchResponse> searchForMangas() async {
    return searchMangas(
      searchTerm: widget.searchTerm
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<MangaSearchResponse>(
        future: searchForMangas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Failed to fetch mangas",
                    style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text("No matching mangas found",
                    style: TextStyle(color: Colors.white)));
          }

          List<MangaEdge> mangaList = snapshot.data!.mangas.edges;
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: mangaList.length,
            itemBuilder: (context, index) {
              return Placeholder();
            },
          );
        },
      ),
    );
  }
}
