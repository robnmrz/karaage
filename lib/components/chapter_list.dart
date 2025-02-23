import 'package:flutter/material.dart';
import 'package:mango/panels.dart';

class ChapterList extends StatelessWidget {
  final List<dynamic> chapters;
  final String mangaTitle;
  final String mangaId;

  const ChapterList({
    super.key,
    required this.chapters,
    required this.mangaTitle,
    required this.mangaId,
  });

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
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MangaPanelsPage(
                  title: mangaTitle,
                  mangaId: mangaId,
                  chapterString: chapters[index],
                ),
              ),
            );
          },
          child: Card(
            color: Colors.white.withValues(alpha: 0.3),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                chapters.isEmpty ? "0" : chapters[index],
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
