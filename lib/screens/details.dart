import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:karaage/api/manga_details.dart';
import 'package:karaage/api/models.dart';
import 'package:karaage/components/app_bar.dart';
import 'package:karaage/components/chapter_grid.dart';
import 'package:karaage/components/manga_info.dart';
import 'package:karaage/db/app_database.dart';

class MangaDetailsScreen extends StatefulWidget {
  final String mangaId;
  final String mangaTitle;

  const MangaDetailsScreen({
    super.key,
    required this.mangaId,
    required this.mangaTitle,
  });

  @override
  State<MangaDetailsScreen> createState() => _MangaDetailsScreenState();
}

class _MangaDetailsScreenState extends State<MangaDetailsScreen> {
  late Future<MangaDetailsResponse> _mangaFuture;
  List<List<dynamic>> _chapterGroups = [];
  int _selectedRangeIndex = 0;
  List<dynamic> sortedChapterList = [];

  final AppDatabase db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    _mangaFuture = fetchMangaDetails();
  }

  // Async function to fetch manga details
  Future<MangaDetailsResponse> fetchMangaDetails() async {
    final manga = await getMangaDetails(id: widget.mangaId);
    await db.insertManga(manga.manga); // Insert into DB
    return manga;
  }

  List<List<dynamic>> splitChaptersIntoRanges(
    List<dynamic> chapters,
    int rangeSize,
  ) {
    if (chapters.isEmpty) {
      return []; // Handle case where there are no chapters
    }

    List<List<dynamic>> groups = [];
    sortedChapterList = chapters.reversed.toList();
    for (int i = 0; i < sortedChapterList.length; i += rangeSize) {
      groups.add(
        sortedChapterList.sublist(
          i,
          (i + rangeSize > sortedChapterList.length)
              ? sortedChapterList.length
              : i + rangeSize,
        ),
      );
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows the image to flow behind the navbar
      extendBodyBehindAppBar: true,

      appBar: GlassAppBar(
        title: widget.mangaTitle,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true); // Go back
          },
        ),
      ),

      body: FutureBuilder<MangaDetailsResponse>(
        future: _mangaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/karaage_app_bg.jpg',
                    fit: BoxFit.cover,
                  ),
                ),

                // Blur Effect
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
                ),

                // Loading Indicator
                Center(child: CircularProgressIndicator(color: Colors.white)),
              ],
            );
          } else if (snapshot.hasError) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/karaage_app_bg.jpg',
                    fit: BoxFit.cover,
                  ),
                ),

                // Blur Effect
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
                ),

                // Error Message
                Center(
                  child: Text(
                    "Sorry, something went wrong",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          } else if (!snapshot.hasData) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/karaage_app_bg.jpg',
                    fit: BoxFit.cover,
                  ),
                ),

                // Blur Effect
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
                ),

                // No Data Message
                Center(
                  child: Text(
                    "No details about this Manga found.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          }

          Manga manga = snapshot.data!.manga;

          // Split chapters into ranges
          _chapterGroups = splitChaptersIntoRanges(
            manga.availableChaptersDetail.sub,
            MediaQuery.of(context).size.width > 600 ? 100 : 50,
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                manga.hasBanner ? manga.banner! : manga.thumbnail,
                fit: BoxFit.fitHeight,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/karaage_app_bg.jpg',
                    fit: BoxFit.cover,
                  );
                },
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
                  child: Container(
                    color: Colors.black.withValues(
                      alpha: 0.5,
                    ), // Adjust opacity as needed
                  ),
                ),
              ),

              // Main Content Section
              SingleChildScrollView(
                // padding: EdgeInsets.zero,
                padding: const EdgeInsets.fromLTRB(16.0, 130.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Manga info section
                    MangaInfoSection(manga: manga),

                    const SizedBox(height: 5),

                    // Horizontal Divider
                    Divider(color: Colors.white54, thickness: 1),

                    const SizedBox(height: 10),

                    // Chapter grid Headline
                    Text(
                      "${manga.availableChapters.sub} Chapters".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Horizontally scrollable chapter range selector
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_chapterGroups.length, (index) {
                          int start = index * 50;
                          int end =
                              (start + 49 > manga.availableChapters.sub)
                                  ? manga.availableChapters.sub
                                  : start + 49;

                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedRangeIndex = index;
                                  });
                                },
                                child: Stack(
                                  children: [
                                    if (_selectedRangeIndex == index)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 20,
                                            sigmaY: 20,
                                          ), // Glass effect
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(
                                                alpha: 0.2,
                                              ), // Light transparent white
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 5,
                                            ),
                                            child: Text(
                                              "$start - $end",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 5,
                                        ),
                                        child: Text(
                                          "$start - $end",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              // White vertical divider except for the last item
                              if (index != _chapterGroups.length - 1)
                                Container(
                                  height: 15,
                                  width: 1,
                                  color: Colors.white70,
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                ),
                            ],
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Chapter grid component
                    ChapterList(
                      chaptersGroup:
                          _chapterGroups.isEmpty
                              ? []
                              : _chapterGroups[_selectedRangeIndex],
                      chapters: sortedChapterList,
                      mangaTitle: manga.name,
                      mangaId: manga.id,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
