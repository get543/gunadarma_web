
// Data model for each navigation item
class LinkItem {
  final String title;
  final String url;
  final String imageUrl; // For the CircleAvatar

  const LinkItem({
    required this.title,
    required this.url,
    required this.imageUrl,
  });
}
