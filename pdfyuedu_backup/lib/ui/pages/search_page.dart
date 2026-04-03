import 'package:flutter/material.dart';
import 'package:pdfyuedu/models/book.dart';
import 'package:pdfyuedu/services/search_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchService _searchService = SearchService();
  final TextEditingController _searchController = TextEditingController();
  List<Book> _localResults = [];
  List<Map<String, dynamic>> _onlineResults = [];
  bool _isSearching = false;
  bool _showOnlineResults = false;

  Future<void> _search(String keyword) async {
    if (keyword.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      _localResults = await _searchService.searchLocal(keyword);

      if (_showOnlineResults) {
        _onlineResults = await _searchService.searchOnline(keyword);
      }
    } catch (e) {
      print('搜索失败: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: '搜索书籍',
            border: InputBorder.none,
          ),
          onSubmitted: _search,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _search(_searchController.text),
          ),
        ],
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('搜索在线书籍'),
            value: _showOnlineResults,
            onChanged: (value) {
              setState(() {
                _showOnlineResults = value;
              });
            },
          ),
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      if (_localResults.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('本地书籍', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            ..._localResults.map((book) {
                              return ListTile(
                                leading: book.coverUrl.isNotEmpty
                                    ? Image.network(book.coverUrl, width: 48, height: 64, fit: BoxFit.cover)
                                    : const Icon(Icons.book, size: 48),
                                title: Text(book.title),
                                subtitle: Text(book.author),
                                onTap: () {},
                              );
                            }),
                          ],
                        ),
                      if (_showOnlineResults && _onlineResults.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('在线书籍', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            ..._onlineResults.map((book) {
                              return ListTile(
                                leading: Image.network(book['coverUrl'], width: 48, height: 64, fit: BoxFit.cover),
                                title: Text(book['title']),
                                subtitle: Text(book['author']),
                                onTap: () {},
                              );
                            }),
                          ],
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
