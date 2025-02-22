import 'package:flutter/material.dart';
import 'package:mango/api/mangas.dart';
import 'package:mango/api/models.dart';
import 'package:mango/components/card.dart';

class MangasSearchResult extends StatefulWidget{
  const MangasSearchResult({super.key});

  @override
  State<MangasSearchResult> createState() => _MangasSearchResultState();
}

class _MangasSearchResultState extends State<MangasSearchResult> {
  final TextEditingController _searchController = TextEditingController();
  late Future<MangaSearchResponse>? _searchFuture;

  @override
  void initState() {
    super.initState();
    _searchFuture = null; // No initial search
  }

  void _onSearchSubmitted(String searchTerm) {
    setState(() {
      _searchFuture = searchMangas(searchTerm: searchTerm);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Mangas"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search mangas...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _onSearchSubmitted(_searchController.text),
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: _onSearchSubmitted,
            ),
          ),
          Expanded(
            child: _searchFuture == null
                ? Center(
                    child: Text("Please enter a search term",
                        style: TextStyle(color: Colors.white)),
                  )
                : FutureBuilder<MangaSearchResponse>(
                    future: _searchFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text("Failed to fetch mangas",
                                style: TextStyle(color: Colors.black)));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text("No matching mangas found",
                                style: TextStyle(color: Colors.black)));
                      }

                      // Return manga cards
                      List<MangaEdge> mangaList = snapshot.data!.mangas.edges;
                        return GridView.builder(
                          padding: EdgeInsets.all(10),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Two cards per row
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7, // Adjust height
                          ),
                          itemCount: mangaList.length,
                          itemBuilder: (context, index) {
                            return CustomMangaCard(
                              imageUrl: mangaList[index].thumbnail,
                              title: mangaList[index].name,
                              lastChapterDate: mangaList[index].lastChapterDate,
                              lastChapterInfo: mangaList[index].lastChapterInfo,
                              onTap: () {},
                            );
                          },
                        );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
