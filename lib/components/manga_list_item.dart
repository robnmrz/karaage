// Widget for Each Manga Item
import 'package:flutter/material.dart';
import 'package:karaage/api/models.dart';
import 'package:karaage/api/utils.dart';

class MangaListItem extends StatelessWidget {
  final Manga manga;
  final bool showTotalChaptersRead;

  const MangaListItem({
    super.key,
    required this.manga,
    required this.showTotalChaptersRead,
  });

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
                      "${showTotalChaptersRead ? manga.readChapters.length : (manga.readChapters.isEmpty ? 0 : manga.readChapters.first)} / ${manga.availableChapters.sub}",
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
                              ? Colors.white70
                              : Colors.greenAccent,
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
