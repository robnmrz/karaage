import 'dart:ui';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Manga> _filteredMangas = mangas;

  void _filterMangas(String query) {
    setState(() {
      _filteredMangas = mangas
          .where((manga) => manga.title.toLowerCase().contains(query.toLowerCase()))
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
            child: Image.asset(
              'assets/images/mangoBg.jpg',
              fit: BoxFit.cover,
            ),
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
                      borderSide: BorderSide(color: const Color.fromARGB(255, 191, 105, 0), width: 1.0), // Color when focused
                    ),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.3), // Transparent input field
                  ),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Color.fromARGB(255, 191, 105, 0), // Change cursor color to white
                ),
              ),

              // Manga List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                  itemCount: _filteredMangas.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return MangaItem(manga: _filteredMangas[index]);
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

// Dummy Manga Data Model
class Manga {
  final String title;
  final String imageUrl;
  final int chapters;
  final String lastUpdated;

  Manga({required this.title, required this.imageUrl, required this.chapters, required this.lastUpdated});
}

// Dummy Manga List
final List<Manga> mangas = [
  Manga(title: "One Piece", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 1085, lastUpdated: "Feb 20, 2025"),
  Manga(title: "Attack on Titan", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 139, lastUpdated: "Mar 15, 2024"),
  Manga(title: "Naruto", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 700, lastUpdated: "Nov 10, 2019"),
  Manga(title: "Bleach", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 686, lastUpdated: "Aug 22, 2020"),
  Manga(title: "One Piece", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 1085, lastUpdated: "Feb 20, 2025"),
  Manga(title: "Attack on Titan", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 139, lastUpdated: "Mar 15, 2024"),
  Manga(title: "Naruto", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 700, lastUpdated: "Nov 10, 2019"),
  Manga(title: "Bleach", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 686, lastUpdated: "Aug 22, 2020"),
];

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
              manga.imageUrl,
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
                  manga.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 10),

                // Chapter Count
                Row(
                  children: [
                    const Icon(Icons.menu_book, color: Colors.white70, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      "${manga.chapters} / 9999",
                      // "${manga.recentChapter} / ${len(manga.chapters}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Last Updated
                Row(
                  children: [
                    const Icon(Icons.update, color: Colors.white70, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      manga.lastUpdated,
                      style: const TextStyle(color: Colors.white70),
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
