import 'package:flutter/material.dart';
import 'package:mango/api/panels.dart';
import 'package:mango/components/appbar.dart';
import 'package:mango/components/floating_bottombar.dart';

class MangaPanelsPage extends StatefulWidget {
  final String mangaId;
  final String title;
  final String chapterString;
  
  const MangaPanelsPage({
    super.key, 
    required this.mangaId, 
    required this.title,
    required this.chapterString 
    });

  @override
  _MangaPanelsPageState createState() => _MangaPanelsPageState();
}

class _MangaPanelsPageState extends State<MangaPanelsPage> {
  // Async function to fetch image URLs
  Future<List<String>> fetchImageUrls() async {
    return getChapterPagesUrls(
      mangaId: widget.mangaId,
      chapterString: widget.chapterString
    );
  }

  @override
   Widget build(BuildContext context) {
    bool isFirstChapter = int.tryParse(widget.chapterString)! <= 1;
    
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true, // Allows the image to flow behind the navbar
      extendBodyBehindAppBar: true,

      appBar: GlassAppBar(
        title: widget.title,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back
          },
        ),
      ),

      body: FutureBuilder<List<String>>(
        future: fetchImageUrls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Pannels could not be fetched",
                    style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text("No images found",
                    style: TextStyle(color: Colors.white)));
          }

          List<String> imageUrls = snapshot.data!;
          return Stack(
            children: [
              // Image list behind the navbar
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
                            // Floating Bottom Bar
              FloatingBottomBar(
                isBackDisabled: isFirstChapter,
                onBackPressed: () {
                  if (!isFirstChapter) {
                    print("Back pressed");
                    // Implement chapter navigation logic
                  }
                },
                onForwardPressed: () {
                  print("Forward pressed");
                  // Implement forward chapter logic
                },
                onSearchPressed: () {
                  print("Search pressed");
                  // Implement search or zoom functionality
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
