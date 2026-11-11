import '../models/news_item.dart';

class NewsData {
  const NewsData._();

  static final List<NewsItem> all = [
    NewsItem(
      id: 'tickets-karma',
      tag: 'Tickets',
      title: 'Tickets open for Newroz vs Al Karma',
      summary: 'Choose your zone and seats in the app.',
      body: 'Newroz host Al Karma at Newroz Stadium on 21 November in the '
          'Iraq Stars League. Pick a ticket package on the stadium map, then '
          'choose your exact seats and confirm your booking in a few taps. '
          'You can book up to 6 seats in one order.',
      date: DateTime(2026, 11, 10),
    ),
    NewsItem(
      id: 'shop-open',
      tag: 'Shop',
      title: 'The team shop is open',
      summary: 'Jerseys, scarves, caps and more.',
      body: 'Browse home and away jerseys, training tops, hoodies, scarves and '
          'fan gear in the new team shop. Members get a discount on every '
          'order.',
      date: DateTime(2026, 11, 10),
    ),
    NewsItem(
      id: 'membership',
      tag: 'Membership',
      title: 'Membership plans are here',
      summary: 'Silver, Gold and Platinum.',
      body: 'Join the Newroz family with a Silver, Gold or Platinum plan. '
          'Open the Membership tab to compare the benefits and choose the '
          'plan that fits you.',
      date: DateTime(2026, 11, 9),
    ),
    NewsItem(
      id: 'fixtures',
      tag: 'Matches',
      title: 'Iraq Stars League 2026–27 fixtures',
      summary: 'All published matches in one place.',
      body: 'The Matches tab lists every published fixture of the league. '
          'Switch to the Newroz filter to see only our matches. New rounds '
          'are added as soon as they are announced.',
      date: DateTime(2026, 11, 8),
    ),
  ];
}
