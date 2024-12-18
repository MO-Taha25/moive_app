import 'package:flutter/material.dart';
import 'package:movie_app/browser_tab/screens/browser_screen.dart';
import 'package:movie_app/movies_tab/screens/movie_screen.dart';
import 'package:movie_app/search_tab/search_screen.dart';
import 'package:movie_app/watch_list_tab/watch_list_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> tabs = [
    MovieScreen(),
    SearchScreen(),
    BrowserScreen(),
    WatchlistScreen(),
  ];
  int currentTapIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTapIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: EdgeInsets.zero,
        color: Colors.white,
        child: BottomNavigationBar(
          currentIndex: currentTapIndex,
          onTap: (index) => setState(() => currentTapIndex = index),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: ImageIcon(
                size: 45,
                AssetImage('assets/Home.png'),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Search',
              icon: ImageIcon(
                size: 45,
                AssetImage('assets/movie_search.png'),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Browser',
              icon: ImageIcon(
                size: 45,
                AssetImage('assets/Browser.png'),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Watch List',
              icon: ImageIcon(
                size: 45,
                AssetImage('assets/Watchlist.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
