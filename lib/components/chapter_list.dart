import 'package:flutter/material.dart';
import 'package:mango/components/noanimation_router.dart';
import 'package:mango/components/temp_store.dart';
import 'package:mango/panels.dart';

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
  // @override
  // void initState() {
  //   super.initState();
  //   _loadViewedChapters();
  // }

  // Future<void> _loadViewedChapters() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _viewedChapters = prefs.getStringList('${widget.mangaId}_viewedChapters')?.toSet() ?? {};
  //   });
  // }

  Future<void> _markChapterAsViewed(String chapter) async {
    // final prefs   = await SharedPreferences.getInstance();
    setState(() {
      tempStoreProvider.viewedChapters.add(chapter);
      // prefs.setStringList('${widget.mangaId}_viewedChapters', _viewedChapters.toList());
    });
  }


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 10),
      shrinkWrap: true, // Prevents infinite height error
      physics: const NeverScrollableScrollPhysics(), // Allows scrolling inside a parent SingleChildScrollView
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // 5 elements per row
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 1.4, // Adjust this to fit the design
      ),
      itemCount: widget.chaptersGroup.length,
      itemBuilder: (context, index) {
        String chapter = widget.chaptersGroup[index];
        bool isViewed = tempStoreProvider.viewedChapters.contains(chapter);

        return GestureDetector(
          onTap: () {
            _markChapterAsViewed(chapter);
            Navigator.push(
              context,
              NoAnimationPageRoute(
                builder: (context) => MangaPanelsPage(
                  mangaId: widget.mangaId,
                  chapterString: widget.chaptersGroup[index],
                  chapters: widget.chapters,
                ),
              ),
            );
          },
          child: Card(
            color: isViewed
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
