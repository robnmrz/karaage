import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mango/api/manga_details.dart';
import 'package:mango/api/models.dart';
import 'package:mango/components/appbar.dart';
import 'package:mango/components/chapter_list.dart';
import 'package:mango/components/info_section.dart';

class MangaDetailsPage extends StatefulWidget {
  final String mangaId;
  final String mangaTitle;

  const MangaDetailsPage({super.key, required this.mangaId, required this.mangaTitle});

  @override
  State<MangaDetailsPage> createState() => _MangaDetailsPageState();
}

class _MangaDetailsPageState extends State<MangaDetailsPage> {

  late Future<MangaDetailsResponse> _mangaDetailsFuture;
  List<List<dynamic>> _chapterGroups = [];
  int _selectedRangeIndex = 0;
  List<dynamic> sortedChapterList = [];

  @override
  void initState() {
    super.initState();
    _mangaDetailsFuture = fetchMangaDetails();
  }

  // Async function to fetch manga details
  Future<MangaDetailsResponse> fetchMangaDetails() async {
    return getMangaDetails(
      id: widget.mangaId,
    );
  }

  List<List<dynamic>> splitChaptersIntoRanges(List<dynamic> chapters, int rangeSize) {
    if (chapters.isEmpty) {
      return []; // Handle case where there are no chapters
    }
  
    List<List<dynamic>> groups = [];
    sortedChapterList = chapters.reversed.toList();
    for (int i = 0; i < sortedChapterList.length; i += rangeSize) {
      groups.add(sortedChapterList.sublist(i, (i + rangeSize > sortedChapterList.length) ? sortedChapterList.length : i + rangeSize));
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
            Navigator.pop(context); // Go back
          },
        ),
      ),

      body: FutureBuilder<MangaDetailsResponse>(
        future: _mangaDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Pannels could not be fetched",
                    style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData) {
            return Center(
                child: Text("No images found",
                    style: TextStyle(color: Colors.white)));
          }
          
          Manga mangaDetails = snapshot.data!.manga;
           _chapterGroups = splitChaptersIntoRanges(mangaDetails.availableChaptersDetail.sub, 50);

          return Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              mangaDetails.hasBanner ? mangaDetails.banner! : mangaDetails.thumbnail,
              fit: BoxFit.fitHeight,
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5), // Adjust opacity as needed
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
                  MangaInfoSection(mangaDetails: mangaDetails),

                  const SizedBox(height: 5),

                  // Horizontal Divider
                  Divider(color: Colors.white54, thickness: 1),

                  const SizedBox(height: 10),

                  // Chapter grid Headline
                  Text(
                    "${mangaDetails.availableChapters.sub} Chapters".toUpperCase(),
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
                        int end = (start + 49 > mangaDetails.availableChapters.sub)
                            ? mangaDetails.availableChapters.sub
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
                                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // Glass effect
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.2), // Light transparent white
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                    chaptersGroup: _chapterGroups.isEmpty ? [] : _chapterGroups[_selectedRangeIndex],
                    chapters: sortedChapterList,
                    mangaTitle: mangaDetails.name,
                    mangaId: mangaDetails.id,
                  ),
                ],
              ),
            ),
          ],
          );
        }
      ),
    );
  }
}
