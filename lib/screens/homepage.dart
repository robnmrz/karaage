import 'package:flutter/material.dart';
import 'package:karaage/api/models.dart';
import 'package:karaage/components/manga_list_item.dart';
import 'package:karaage/components/search_bar.dart';
import 'package:karaage/db/app_database.dart';
import 'package:karaage/screens/details.dart';
import 'package:karaage/router/no_animation.dart';
import 'package:karaage/screens/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Manga> _filteredMangas = [];
  List<Manga> _allMangas = [];
  bool _isLoading = true;
  bool _showTotalChaptersRead = false;

  final AppDatabase db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    _loadMangas();
    _loadSettings();
  }

  void reloadMangas() {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
      _loadMangas();
      _loadSettings();
    }
  }

  Future<void> _loadMangas() async {
    try {
      List<Manga> mangas = await db.readFavoritedMangas();
      for (var manga in mangas) {
        manga.readChapters = await db.getReadChaptersByMangaId(manga.id);
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

  Future<void> _loadSettings() async {
    bool preference = await getShowTotalChaptersReadPreference();
    setState(() {
      _showTotalChaptersRead = preference;
    });
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
          // Content
          Column(
            children: [
              // Searchbar
              Padding(
                padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
                child: CustomSearchbar(
                  hintText: "Filter mangas...",
                  icon: Icons.filter_list,
                  onChanged: _filterMangas,
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
                                        (context) => MangaDetailsScreen(
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
                              child: MangaListItem(
                                manga: _filteredMangas[index],
                                showTotalChaptersRead: _showTotalChaptersRead,
                              ),
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
