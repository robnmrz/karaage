import 'package:flutter/material.dart';

class NumberScrollbarScreen extends StatefulWidget {
  const NumberScrollbarScreen({super.key});

  @override
  _NumberScrollbarScreenState createState() => _NumberScrollbarScreenState();
}

class _NumberScrollbarScreenState extends State<NumberScrollbarScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<int> numbers = List.generate(100, (index) => index + 1); // 1 to 100
  final List<int> indexNumbers = [1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100];

  void _jumpToNumber(int number) {
    int index = numbers.indexOf(number);
    if (index != -1) {
      _scrollController.animateTo(
        index * 50.0, // Assuming each item has a height of 50
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Number Scrollbar")),
      body: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: numbers.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  numbers[index].toString(),
                  style: TextStyle(fontSize: 20),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: indexNumbers.map((number) {
                  return GestureDetector(
                    onTap: () => _jumpToNumber(number),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        number.toString(),
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
