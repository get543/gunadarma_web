import 'package:flutter/material.dart';
import 'package:gunadarma_web/screens/common_webview.dart';

import 'list_websites.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),

      //! List of Websites in Card format
      body: ListView.builder(
        // Add some padding around the ListView
        padding: const EdgeInsets.all(20.0),
        itemCount: linkItems.length,
        itemBuilder: (context, index) {
          final item = linkItems[index];
          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: InkWell( // Makes the whole card tappable
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommonWebView(
                      url: item.url,
                      title: item.title,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(15.0), // Match the card's shape
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      // Use NetworkImage for web URLs or AssetImage for local assets
                      // backgroundImage: NetworkImage(item.imageUrl),
                      backgroundImage: AssetImage(item.imageUrl),
                      // Optional: Add a fallback background color
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(width: 20.0),
                    // Use Flexible to prevent text overflow
                    Flexible(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

