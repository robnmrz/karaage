import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mango/api/mangas.dart';
import 'package:mango/api/models.dart';
import 'package:mango/components/card.dart';
import 'package:mango/components/noanimation_router.dart';
import 'package:mango/details.dart';

class MangasSearchResult extends StatefulWidget {
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
    return Stack(
      children: [
        /// Background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/mangoBg.jpg', // Same background as HomePage
            fit: BoxFit.cover,
          ),
        ),

        /// Apply blur effect over the background
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
            child: Container(
              color: Colors.black.withValues(alpha: 0.5), // Adjust opacity if needed
            ),
          ),
        ),

        /// Main content inside Scaffold
        Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent, // Make Scaffold blend with background
          // appBar: AppBar(
          //   title: Text("Search Mangas", style: const TextStyle(color: Colors.white)),
          //   centerTitle: true,
          //   backgroundColor: Colors.black.withValues(alpha: 0.3), // Slightly transparent
          //   elevation: 0,
          // ),
          body: Column(
            children: [

              // Searchbar
              Padding(
                padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search mangas...",
                    hintStyle: TextStyle(color: Colors.white60),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.white60),
                      onPressed: () => _onSearchSubmitted(_searchController.text),
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromARGB(255, 191, 105, 0), width: 1.0), // Color when focused
                    ),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.3), // Transparent input field
                  ),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Color.fromARGB(255, 191, 105, 0), // Change cursor color to white
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
                                    style: TextStyle(color: Colors.white)));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                                child: Text("No matching mangas found",
                                    style: TextStyle(color: Colors.white)));
                          }

                          // Return manga cards
                          List<MangaEdge> mangaList = snapshot.data!.mangas.edges;
                          return GridView.builder(
                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 110.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Two cards per row
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.7, // Adjust height
                            ),
                            itemCount: mangaList.length,
                            itemBuilder: (context, index) {
                              // MangaCard Component
                              return CustomMangaCard(
                                imageUrl: mangaList[index].thumbnail,
                                title: mangaList[index].name,
                                lastChapterDate: mangaList[index].lastChapterDate,
                                lastChapterInfo: mangaList[index].lastChapterInfo,
                                onTap: () {

                                  // Navigate to details page and pass the mangaId
                                  Navigator.push(
                                    context,
                                    NoAnimationPageRoute(
                                      builder: (context) => MangaDetailsPage(
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
