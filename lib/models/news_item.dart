class NewsItem {
  const NewsItem({
    required this.id,
    required this.tag,
    required this.title,
    required this.summary,
    required this.body,
    required this.date,
  });

  final String id;
  final String tag;
  final String title;
  final String summary;
  final String body;
  final DateTime date;
}
