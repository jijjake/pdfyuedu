import 'package:flutter/material.dart';
import '../ui/pages/library_page.dart';
import '../ui/pages/import_page.dart';
import '../ui/pages/search_page.dart';
import '../ui/pages/cloud_storage_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const LibraryPage(),
    const ImportPage(),
    const SearchPage(),
    const CloudStoragePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '书库',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: '导入',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '搜索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
