import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mango/api/models.dart';
import 'package:mango/api/utils.dart';
import 'package:mango/components/noanimation_router.dart';
import 'package:mango/db/app_database.dart';
import 'package:mango/details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Manga> _filteredMangas = [];
  List<Manga> _allMangas = [];
  bool _isLoading = true;

  final AppDatabase db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    _loadMangas();
  }

  void reloadMangas() {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
      _loadMangas();
    }
  }

  Future<void> _loadMangas() async {
    try {
      List<Manga> mangas = await db.readFavoritedMangas();
      for (var manga in mangas) {
        List<String> readChapters = await db.getReadChaptersByMangaId(manga.id);
        manga.readChaptersCount =
            readChapters.length; // Add the read count to the Manga object
      }

      setState(() {
        _allMangas = mangas;
        _filteredMangas = mangas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching mangas: $e");
    }
  }

  void _filterMangas(String query) {
    setState(() {
      _filteredMangas =
          _allMangas
              .where(
                (manga) =>
                    manga.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/images/mangoBg.jpg', fit: BoxFit.cover),
          ),

          // Blur Effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ),

          // Content
          Column(
            children: [
              // Searchbar
              Padding(
                padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
                child: TextField(
                  onChanged: _filterMangas,
                  decoration: InputDecoration(
                    hintText: "Filter mangas...",
                    hintStyle: TextStyle(color: Colors.white60),
                    suffixIcon: Icon(
                      Icons.filter_list,
                      color: Colors.white70, // Change icon color to white
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 191, 105, 0),
                        width: 1.0,
                      ), // Color when focused
                    ),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.3),
                  ),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Color.fromARGB(255, 191, 105, 0),
                ),
              ),

              // Manga List
              Expanded(
                child:
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _filteredMangas.isEmpty
                        ? Center(
                          child: Text(
                            "No mangas found",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                          itemCount: _filteredMangas.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                bool? shouldReload = await Navigator.push(
                                  context,
                                  NoAnimationPageRoute(
                                    builder:
                                        (context) => MangaDetailsPage(
                                          mangaTitle:
                                              _filteredMangas[index].name,
                                          mangaId: _filteredMangas[index].id,
                                        ),
                                  ),
                                );

                                // Check if we need to reload data
                                if (shouldReload == true) {
                                  reloadMangas();
                                }
                              },
                              child: MangaItem(manga: _filteredMangas[index]),
                            );
                          },
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget for Each Manga Item
class MangaItem extends StatelessWidget {
  final Manga manga;

  const MangaItem({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Manga Image
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              manga.thumbnail,
              width: 80,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // Manga Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Manga Title
                Text(
                  manga.englishName == null || manga.englishName == ""
                      ? manga.name
                      : manga.englishName!,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 10),

                // Chapter Count
                Row(
                  children: [
                    const Icon(
                      Icons.menu_book,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${manga.readChaptersCount} / ${manga.availableChapters.sub}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Manga Status
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color:
                          manga.status == "Finished"
                              ? Colors.greenAccent
                              : Colors.orangeAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      manga.status ?? "Unknown",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Last Updated (only if manga is not finished)
                if (manga.status != "Finished")
                  Row(
                    children: [
                      const Icon(Icons.update, color: Colors.white70, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        getTimeAgo(manga.lastChapterDate),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
