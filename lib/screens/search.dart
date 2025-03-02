import 'package:flutter/material.dart';
import 'package:karaage/api/manga_search.dart';
import 'package:karaage/api/models.dart';
import 'package:karaage/components/manga_card.dart';
import 'package:karaage/components/search_bar.dart';
import 'package:karaage/screens/details.dart';
import 'package:karaage/router/no_animation.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
    return Stack(
      children: [
        /// Main Content Body
        Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
                child: CustomSearchbar(
                  hintText: "Search mangas...",
                  icon: Icons.search,
                  controller: _searchController,
                  onSubmitted: _onSearchSubmitted,
                ),
              ),

              Expanded(
                child:
                    _searchFuture == null
                        ? Center(
                          child: Text(
                            "Please enter a search term",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                        : FutureBuilder<MangaSearchResponse>(
                          future: _searchFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  "Failed to fetch mangas",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                child: Text(
                                  "No matching mangas found",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }

                            // Return manga cards
                            List<MangaEdge> mangaList =
                                snapshot.data!.mangas.edges;
                            return GridView.builder(
                              padding: EdgeInsets.fromLTRB(
                                10.0,
                                10.0,
                                10.0,
                                110.0,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width > 600
                                            ? 4
                                            : 2, // Two cards per row
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.7, // Adjust height
                                  ),
                              itemCount: mangaList.length,
                              itemBuilder: (context, index) {
                                // MangaCard Component
                                return MangaCard(
                                  imageUrl: mangaList[index].thumbnail,
                                  title: mangaList[index].name,
                                  lastChapterDate:
                                      mangaList[index].lastChapterDate,
                                  lastChapterInfo:
                                      mangaList[index].lastChapterInfo,
                                  onTap: () {
                                    // Navigate to details page and pass the mangaId
                                    Navigator.push(
                                      context,
                                      NoAnimationPageRoute(
                                        builder:
                                            (context) => MangaDetailsScreen(
                                              mangaTitle: mangaList[index].name,
                                              mangaId: mangaList[index].id,
                                            ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
