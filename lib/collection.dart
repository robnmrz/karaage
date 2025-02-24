import 'dart:ui';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Manga> _filteredCurrentlyReading = List.from(currentlyReading);
  List<Manga> _filteredPlanToRead = List.from(planToRead);

  bool _isCurrentlyReadingExpanded = true;
  bool _isPlanToReadExpanded = true;

  void _filterMangas(String query) {
    setState(() {
      _filteredCurrentlyReading = currentlyReading
          .where((manga) => manga.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _filteredPlanToRead = planToRead
          .where((manga) => manga.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleCurrentlyReading() {
    setState(() {
      _isCurrentlyReadingExpanded = !_isCurrentlyReadingExpanded;
    });
  }

  void _togglePlanToRead() {
    setState(() {
      _isPlanToReadExpanded = !_isPlanToReadExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/mangoBg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextField(
                    onChanged: _filterMangas,
                    decoration: InputDecoration(
                      hintText: "Filter mangas...",
                      hintStyle: const TextStyle(color: Colors.white60),
                      suffixIcon: const Icon(Icons.filter_list, color: Colors.white70),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color.fromARGB(255, 191, 105, 0), width: 1.0),
                      ),
                      filled: true,
                      fillColor: Colors.black.withValues(alpha: 0.3),
                    ),
                    style: const TextStyle(color: Colors.white),
                    cursorColor: const Color.fromARGB(255, 191, 105, 0),
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      _buildStickyHeader("Reading".toUpperCase(), _toggleCurrentlyReading),
                      if (_isCurrentlyReadingExpanded) _buildMangaList(_filteredCurrentlyReading),
                      _buildStickyHeader("Planned".toUpperCase(), _togglePlanToRead),
                      if (_isPlanToReadExpanded) _buildMangaList(_filteredPlanToRead),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyHeader(String title, VoidCallback onTap) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _StickyHeaderDelegate(title: title, onTap: onTap),
    );
  }

  Widget _buildMangaList(List<Manga> mangas) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return MangaItem(manga: mangas[index]);
        },
        childCount: mangas.length,
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final VoidCallback onTap;

  _StickyHeaderDelegate({required this.title, required this.onTap});

  @override
  double get minExtent => 35;
  @override
  double get maxExtent => 35;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: Colors.black.withValues(alpha: 0.9),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
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

// Dummy Manga Lists
final List<Manga> currentlyReading = [
  Manga(title: "One Piece", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 1085, lastUpdated: "Feb 20, 2025"),
  Manga(title: "Attack on Titan", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 139, lastUpdated: "Mar 15, 2024"),
  Manga(title: "One Piece", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 1085, lastUpdated: "Feb 20, 2025"),
  Manga(title: "Attack on Titan", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 139, lastUpdated: "Mar 15, 2024"),
];

final List<Manga> planToRead = [
  Manga(title: "Naruto", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 700, lastUpdated: "Nov 10, 2019"),
  Manga(title: "Bleach", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 686, lastUpdated: "Aug 22, 2020"),
  Manga(title: "Naruto", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 700, lastUpdated: "Nov 10, 2019"),
  Manga(title: "Bleach", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 686, lastUpdated: "Aug 22, 2020"),
  Manga(title: "Naruto", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 700, lastUpdated: "Nov 10, 2019"),
  Manga(title: "Naruto", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 700, lastUpdated: "Nov 10, 2019"),
  Manga(title: "Bleach", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 686, lastUpdated: "Aug 22, 2020"),
  Manga(title: "Bleach", imageUrl: "https://wp.youtube-anime.com/s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx179256-TRND01mxfNgM.jpg?w=250", chapters: 686, lastUpdated: "Aug 22, 2020"),
];

// Widget for Each Manga Item
class MangaItem extends StatelessWidget {
  final Manga manga;

  const MangaItem({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                Text(
                  manga.title,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.menu_book, color: Colors.white70, size: 18),
                    const SizedBox(width: 6),
                    Text("${manga.chapters} Chapters", style: const TextStyle(color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.update, color: Colors.white70, size: 18),
                    const SizedBox(width: 6),
                    Text(manga.lastUpdated, style: const TextStyle(color: Colors.white70)),
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
