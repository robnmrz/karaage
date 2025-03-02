import 'package:flutter/material.dart';
import 'package:karaage/api/models.dart';
import 'package:karaage/api/utils.dart';

class MangaCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final LastChapterDate lastChapterDate;
  final LastChapterInfo lastChapterInfo;
  final VoidCallback? onTap;

  const MangaCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.lastChapterDate,
    required this.lastChapterInfo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 250, // Define a fixed height to avoid layout issues
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 4,
          child: Stack(
            fit: StackFit.expand, // Ensure the stack fills the card
            children: [
              // Background Image
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/defaultThumbnail.jpg',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),

              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                ),
              ),

              // Footer Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Avoid unnecessary space
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // spacer
                      const SizedBox(height: 8),

                      // Row of infos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // chapters row (icon and text)
                          Row(
                            children: [
                              Icon(
                                Icons.menu_book, // Paper pages icon
                                color: Colors.white70,
                                size: 12, // Adjust size as needed
                              ),
                              const SizedBox(
                                width: 4,
                              ), // Small spacing between icon and text
                              Text(
                                lastChapterInfo
                                    .sub
                                    .chapterString, // Display the number of chapters
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          // last updated row (icon and text)
                          Row(
                            children: [
                              Icon(
                                Icons.access_time, // Paper pages icon
                                color: Colors.white70,
                                size: 12, // Adjust size as needed
                              ),
                              const SizedBox(
                                width: 4,
                              ), // Small spacing between icon and text
                              Text(
                                getTimeAgo(
                                  lastChapterDate,
                                ), // Display the number of chapters
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
