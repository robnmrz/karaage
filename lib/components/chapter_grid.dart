import 'package:flutter/material.dart';
import 'package:karaage/db/app_database.dart';
import 'package:karaage/screens/reader.dart';
import 'package:karaage/router/no_animation.dart';

class ChapterList extends StatefulWidget {
  final List<dynamic> chapters;
  final List<dynamic> chaptersGroup;
  final String mangaTitle;
  final String mangaId;

  const ChapterList({
    super.key,
    required this.chapters,
    required this.chaptersGroup,
    required this.mangaTitle,
    required this.mangaId,
  });

  @override
  _ChapterListState createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  Set<String> viewedChapters = {};
  final AppDatabase db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    _loadViewedChapters();
  }

  void reloadChaptersRead() {
    if (mounted) {
      setState(() {});
      _loadViewedChapters();
    }
  }

  Future<void> _loadViewedChapters() async {
    List<String> readChapters = await db.getReadChaptersByMangaId(
      widget.mangaId,
    );
    setState(() {
      viewedChapters = readChapters.toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      shrinkWrap: true, // Prevents infinite height error
      physics:
          const NeverScrollableScrollPhysics(), // Allows scrolling inside a parent SingleChildScrollView
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).size.width > 600
                ? 10
                : 5, // 5 elements per row
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 1.4, // Adjust this to fit the design
      ),
      itemCount: widget.chaptersGroup.length,
      itemBuilder: (context, index) {
        String chapter = widget.chaptersGroup[index];
        bool isViewed = viewedChapters.contains(chapter);

        return GestureDetector(
          onTap: () async {
            bool? shouldReload = await Navigator.push(
              context,
              NoAnimationPageRoute(
                builder:
                    (context) => ReaderScreen(
                      mangaId: widget.mangaId,
                      chapterString: widget.chaptersGroup[index],
                      chapters: widget.chapters,
                    ),
              ),
            );

            // Check if we need to reload data
            if (shouldReload == true) {
              reloadChaptersRead();
            }
          },
          child: Card(
            color:
                isViewed
                    ? Colors.grey.withValues(alpha: 0.3) // Grayed-out if viewed
                    : Colors.white.withValues(alpha: 0.4),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                chapter,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
