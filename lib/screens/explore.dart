import 'package:flutter/material.dart';
import 'package:karaage/components/horizontal_scroll_card.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen({super.key});

  final List<Map<String, String>> sampleData = [
    {
      'thumbnail':
          'https://www.acouplecooks.com/wp-content/uploads/2019/05/Chopped-Salad-008.jpg',
      'title': 'This is a long recipe name or so',
      'subheading': 'Breakfast',
    },
    {
      'thumbnail':
          'https://www.acouplecooks.com/wp-content/uploads/2019/05/Chopped-Salad-008.jpg',
      'title': 'Card Title 2',
      'subheading': 'Lunch',
    },
    {
      'thumbnail':
          'https://www.acouplecooks.com/wp-content/uploads/2019/05/Chopped-Salad-008.jpg',
      'title': 'Card Title 3',
      'subheading': 'Snack',
    },
    {
      'thumbnail':
          'https://www.acouplecooks.com/wp-content/uploads/2019/05/Chopped-Salad-008.jpg',
      'title': 'Card Title 4',
      'subheading': 'Dinner',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScrollableCardSection(headline: 'Top Manga', items: sampleData),
            ScrollableCardSection(
              headline: 'Recent Updates',
              items: sampleData,
            ),
          ],
        ),
      ),
    );
  }
}
