import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mango/api/panels.dart';
import 'package:mango/components/closebutton.dart';
import 'package:mango/components/floating_bottombar.dart';
import 'package:mango/components/noanimation_router.dart';
import 'package:mango/db/app_database.dart';

class MangaPanelsPage extends StatefulWidget {
  final String mangaId;
  final String chapterString;
  final List<dynamic> chapters; // List of chapters

  const MangaPanelsPage({
    super.key,
    required this.mangaId,
    required this.chapterString,
    required this.chapters,
  });

  @override
  _MangaPanelsPageState createState() => _MangaPanelsPageState();
}

class _MangaPanelsPageState extends State<MangaPanelsPage> {
  late int currentIndex;
  late ScrollController _scrollController;
  bool _isBottomBarVisible = true;
  Future<List<String>>? _chapterPagesFuture; // Cache the future
  bool _chapterMarkedAsRead = false;
  Set<int> viewedImages = {}; // Track viewed images

  final AppDatabase db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.chapters.indexOf(widget.chapterString);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Fetch chapter pages only once
    _chapterPagesFuture = getChapterPagesUrls(
      mangaId: widget.mangaId,
      chapterString: widget.chapterString,
    );
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isBottomBarVisible) {
        setState(() {
          _isBottomBarVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isBottomBarVisible) {
        setState(() {
          _isBottomBarVisible = true;
        });
      }
    }

    // Check if the user has scrolled past half of the content
    if (!_chapterMarkedAsRead && _scrollController.hasClients) {
      final double maxScroll = _scrollController.position.maxScrollExtent;
      final double currentScroll = _scrollController.position.pixels;

      if (currentScroll > maxScroll / 2) {
        // If scrolled past 50%
        _markChapterAsRead();
      }
    }
  }

  Future<void> _markChapterAsRead() async {
    _chapterMarkedAsRead = true;
    await db.insertReadChapter(widget.mangaId, widget.chapterString);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String getPreviousChapter() {
    if (currentIndex > 0) {
      return widget.chapters[currentIndex - 1].toString();
    }
    return widget.chapterString;
  }

  String getNextChapter() {
    if (currentIndex < widget.chapters.length - 1) {
      return widget.chapters[currentIndex + 1].toString();
    }
    return widget.chapterString;
  }

  @override
  Widget build(BuildContext context) {
    bool isFirstChapter = currentIndex == 0;
    bool isLastChapter = currentIndex == widget.chapters.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      extendBodyBehindAppBar: true,

      body: FutureBuilder<List<String>>(
        future: _chapterPagesFuture, // Use the cached future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Panels could not be fetched",
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No images found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          List<String> imageUrls = snapshot.data!;

          return Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    imageUrls[index],
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        color: Colors.black,
                        child: const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50,
                        ),
                      );
                    },
                  );
                },
              ),

              // Floating Close Button
              const GlassCloseButton(),

              // Floating Bottom Bar with Animated Opacity
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: AnimatedOpacity(
                  opacity: _isBottomBarVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 100),
                  child: FloatingBottomBar(
                    isBackDisabled: isFirstChapter,
                    isForwardDisabled: isLastChapter,
                    chapterString: widget.chapterString,
                    onBackPressed: () {
                      if (!isFirstChapter) {
                        Navigator.pushReplacement(
                          context,
                          NoAnimationPageRoute(
                            builder:
                                (context) => MangaPanelsPage(
                                  mangaId: widget.mangaId,
                                  chapterString: getPreviousChapter(),
                                  chapters: widget.chapters,
                                ),
                          ),
                        );
                      }
                    },
                    onForwardPressed: () {
                      if (!isLastChapter) {
                        Navigator.pushReplacement(
                          context,
                          NoAnimationPageRoute(
                            builder:
                                (context) => MangaPanelsPage(
                                  mangaId: widget.mangaId,
                                  chapterString: getNextChapter(),
                                  chapters: widget.chapters,
                                ),
                          ),
                        );
                      }
                    },
                    onSearchPressed: () {
                      print("Search Pressed");
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
