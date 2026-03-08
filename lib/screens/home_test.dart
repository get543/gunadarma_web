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
      // Build the UI in a Column.
      body: SafeArea( // Ensures content is not obscured by system UI (like notches).
        child: Column(
          children: [
            Padding( // Add padding around the AppBar.
              padding: const EdgeInsets.all(12.0), // Adjust padding as needed
              child: AppBar(
                // Use clipBehavior to make the corners rounded.
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Makes the AppBar rounded
                ),
                title: Text(widget.title),
                actions: [
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          print("you clicked add");
                        }
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 4. Make the ListView take up the remaining space.
            Expanded(
              child: ListView.builder(
                // The main padding is now on the Column, but you can keep some here if you like.
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
                            builder: (context) =>
                                CommonWebView(url: item.url, title: item.title),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(15.0),

                      // Match the card's shape
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              backgroundImage: AssetImage(item.imageUrl),
                              backgroundColor: Colors.grey.shade200,
                            ),
                            const SizedBox(width: 20.0),
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
            ),
          ],
        ),
      ),
    );
  }
}
