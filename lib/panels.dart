import 'package:flutter/material.dart';
import 'package:mango/api/panels.dart';
import 'package:mango/components/closebutton.dart';
import 'package:mango/components/floating_bottombar.dart';
import 'package:mango/components/noanimation_router.dart';
import 'package:mango/components/temp_store.dart';

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

  @override
  void initState() {
    super.initState();
    // Find current index
    currentIndex = widget.chapters.indexOf(widget.chapterString);
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
    tempStoreProvider.viewedChapters.add(widget.chapterString);

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      extendBodyBehindAppBar: true,

      body: FutureBuilder<List<String>>(
        future: getChapterPagesUrls(mangaId: widget.mangaId, chapterString: widget.chapterString),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Panels could not be fetched", style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No images found", style: TextStyle(color: Colors.white)));
          }

          List<String> imageUrls = snapshot.data!;
          return Stack(
            children: [
              ListView.builder(
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
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        color: Colors.black,
                        child: Icon(Icons.error, color: Colors.red, size: 50),
                      );
                    },
                  );
                },
              ),

              // Floating Close Button
              GlassCloseButton(),          

              // Floating Bottom Bar
              FloatingBottomBar(
                isBackDisabled: isFirstChapter,
                isForwardDisabled: isLastChapter,
                chapterString: widget.chapterString,
                onBackPressed: () {
                  if (!isFirstChapter) {
                    Navigator.pushReplacement(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => MangaPanelsPage(
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
                        builder: (context) => MangaPanelsPage(
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
            ],
          );
        },
      ),
    );
  }
}
