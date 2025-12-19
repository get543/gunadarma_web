import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:gunadarma_web/class/CommonWebView.dart';
import 'package:gunadarma_web/class/LinkItem.dart';

void main() async {
  // It's best practice to ensure the Flutter binding is initialized,
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(
      debug: true,
      ignoreSsl: true // Set to true if specific website has SSL issues!
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView Demo',

      // Provide standard light theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        brightness: Brightness.light,
      ),

      // Provide a dark theme
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),

      // Set theme mode
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Flutter WebView'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // --- Create the list of data ---
  final List<LinkItem> _linkItems = const [
    LinkItem(
      title: 'Gunadarma Home',
      url: "https://gunadarma.ac.id",
      imageUrl: "images/webIcon/gunadarma_icon.png",
    ),
    LinkItem(
      title: 'V-Class',
      url: "https://v-class.gunadarma.ac.id",
      imageUrl: "images/webIcon/vclass_icon.png",
    ),
    LinkItem(
      title: 'Praktikum iLab',
      url: "https://praktikum.gunadarma.ac.id",
      imageUrl: "images/webIcon/ilab_icon.png",
    ),
    LinkItem(
      title: 'Praktikum IFLab',
      url: "https://praktikum-iflab.gunadarma.ac.id",
      imageUrl: "images/webIcon/iflab_icon.png",
    ),
    LinkItem(
      title: 'StudentSite',
      url: "https://studentsite.gunadarma.ac.id/index.php/site/login",
      imageUrl: "images/webIcon/studentsite_icon.png",
    ),
    LinkItem(
      title: 'BAAK',
      url: "https://baak.gunadarma.ac.id",
      imageUrl: "images/webIcon/baak_icon.png",
    ),
    LinkItem(
      title: 'VM Lepkom',
      url: "https://vm.lepkom.gunadarma.ac.id/",
      imageUrl: "images/webIcon/lepkom_icon.png",
    ),
  ];

  // --- Step 3: Refactor the build method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        // Add some padding around the ListView
        padding: const EdgeInsets.all(12.0),
        itemCount: _linkItems.length,
        itemBuilder: (context, index) {
          final item = _linkItems[index];
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
