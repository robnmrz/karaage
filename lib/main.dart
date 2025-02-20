import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mango/api/panels.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ImageGalleryPage(),
  ));
}

class ImageGalleryPage extends StatefulWidget {
  const ImageGalleryPage({super.key});
  @override
  _ImageGalleryPageState createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  int _selectedIndex = 0;

  // Async function to fetch image URLs
  Future<List<String>> fetchImageUrls() async {
    return getChapterPagesUrls(
      mangaId: "bjKg6rj5rh539Wfey",
      chapterString: "1",
    );
  }

  // Function to handle bottom bar item clicks
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation logic here (for now, just print)
    switch (index) {
      case 0:
        print("Search Clicked");
        break;
      case 1:
        print("Bookmark Clicked");
        break;
      case 2:
        print("Shelf Clicked");
        break;
    }
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true, // Allows the image to flow behind the navbar
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: Text("MangaName - 1", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0, // Remove shadow
        backgroundColor: Colors.transparent, // Transparent AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back
          },
        ),
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Glass effect
            child: Container(
              color: Colors.black.withValues(alpha: 0.3), // Semi-transparent background
            ),
          ),
        ),
      ),

      body: FutureBuilder<List<String>>(
        future: fetchImageUrls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Failed to load images",
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
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
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

              // // Glass Bottom Navigation Bar
              // Positioned(
              //   left: 0,
              //   right: 0,
              //   bottom: 0,
              //   child: ClipRRect(
              //     child: BackdropFilter(
              //       filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // Blur effect
              //       child: BottomNavigationBar(
              //         backgroundColor: Colors.black.withValues(alpha: 0.4), // Transparent glass effect
              //         elevation: 0, // Remove shadow
              //         selectedItemColor: Colors.white,
              //         unselectedItemColor: Colors.white,
              //         currentIndex: _selectedIndex,
              //         onTap: _onItemTapped,
              //         iconSize: 20,
              //         items: [
              //           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              //           BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Bookmark'),
              //           BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Shelf'),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}
