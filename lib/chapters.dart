import 'package:flutter/material.dart';
import 'package:mango/main.dart';

class MangaSelectionPage extends StatelessWidget {
  MangaSelectionPage({Key? key}) : super(key: key);
  final List<Map<String, String>> mangaList = [
    {"title": "Manga One", "mangaId": "bjKg6rj5rh539Wfey"},
    {"title": "Manga Two", "mangaId": "ajJg7hj9rh123Xyze"},
    {"title": "Manga Three", "mangaId": "lkJg8df5rh789Pqrs"},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a Manga"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: mangaList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(mangaList[index]["title"]!),
              subtitle: Text("ID: ${mangaList[index]["mangaId"]}"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to ImageGalleryPage and pass the mangaId
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageGalleryPage(
                      title: mangaList[index]["title"]!,
                      mangaId: mangaList[index]["mangaId"]!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
