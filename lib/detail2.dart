import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mango/api/manga_details.dart';
import 'package:mango/api/models.dart';
import 'package:mango/components/appbar.dart';


class MangaDetailsPage extends StatefulWidget {
  final String mangaId;

  const MangaDetailsPage({super.key, required this.mangaId});

  @override
  State<MangaDetailsPage> createState() => _MangaDetailsPageState();
}

class _MangaDetailsPageState extends State<MangaDetailsPage> {
  bool _isExpanded = false;
  late Future<MangaDetailsResponse> _mangaDetailsFuture;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows the image to flow behind the navbar
      extendBodyBehindAppBar: true,

      appBar: GlassAppBar(
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
              padding: const EdgeInsets.fromLTRB(16.0, 135.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Section: Image on Left, Info on Right
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Manga Cover Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          mangaDetails.thumbnail,
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Information Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              mangaDetails.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Info Row 1
                            Text(
                              "Author: John Doe",
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 4),

                            // Info Row 2
                            Text(
                              "Genre: Action, Adventure",
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 4),

                            // Info Row 3
                            Text(
                              "Chapters: 150+",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Summary Section
                  Text(
                    "Summary".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Collapsible Summary Text
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mangaDetails.hasDescription ? mangaDetails.description! : "No Description",
                            maxLines: _isExpanded ? null : 2,
                            overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  _isExpanded ? "less" : "more",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 5),

                  // Horizontal Divider
                  Divider(color: Colors.white54, thickness: 1),

                  const SizedBox(height: 10),

                  // Chapter List Title
                  Text(
                    "${mangaDetails.availableChapters.sub} Chapters".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  // Chapter List
                  ListView.builder(
                    padding: EdgeInsets.only(top: 15),
                    shrinkWrap: true, // Prevent infinite height error
                    physics: NeverScrollableScrollPhysics(), // Allow scrolling in SingleChildScrollView
                    itemCount: mangaDetails.availableChapters.sub,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: ListTile(
                          title: Text(
                            mangaDetails.availableChaptersDetail.sub[index],
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            // Empty onPress Action
                          },
                          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                        ),
                      );
                    },
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
