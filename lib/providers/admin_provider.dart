import 'package:flutter/material.dart';

import '../data/iraq_league_fixtures.dart';
import '../data/news.dart';
import '../data/shop_products.dart';
import '../models/league_match.dart';
import '../models/news_item.dart';
import '../models/product.dart';

class AdminProvider extends ChangeNotifier {
  final List<LeagueMatch> _matches = List<LeagueMatch>.of(IraqLeagueFixtures.all);
  final List<Product> _products = List<Product>.of(ShopProducts.all);
  final List<NewsItem> _news = List<NewsItem>.of(NewsData.all);
  final Map<String, String> _scores = {};
  int _shopRevenue = 0;
  int _shopOrders = 0;

  List<LeagueMatch> get matches => List.unmodifiable(_matches);
  List<Product> get products => List.unmodifiable(_products);
  List<NewsItem> get news => List.unmodifiable(_news);
  int get shopRevenue => _shopRevenue;
  int get shopOrders => _shopOrders;

  String matchKey(LeagueMatch m) => '${m.home}_${m.away}_${m.kickoff.millisecondsSinceEpoch}';

  String? scoreFor(LeagueMatch m) => _scores[matchKey(m)];

  void setScore(LeagueMatch m, int homeGoals, int awayGoals) {
    _scores[matchKey(m)] = '$homeGoals - $awayGoals';
    notifyListeners();
  }

  void addMatch({required String home, required String away, required DateTime kickoff, bool timeConfirmed = true}) {
    _matches.insert(0, LeagueMatch(home: home, away: away, kickoff: kickoff, timeConfirmed: timeConfirmed));
    notifyListeners();
  }

  void addProduct({required String name, required ProductCategory category, required int price, required String description}) {
    _products.insert(
      0,
      Product(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        category: category,
        price: price,
        description: description,
        color: const Color(0xFF065F46),
        icon: Icons.checkroom,
        sizes: const ['S', 'M', 'L', 'XL'],
      ),
    );
    notifyListeners();
  }

  void recordShopOrder(int amount) {
    _shopRevenue += amount;
    _shopOrders += 1;
    notifyListeners();
  }

  void addNews({required String tag, required String title, required String summary, required String body}) {
    _news.insert(
      0,
      NewsItem(
        id: 'news_${DateTime.now().millisecondsSinceEpoch}',
        tag: tag,
        title: title,
        summary: summary,
        body: body,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
