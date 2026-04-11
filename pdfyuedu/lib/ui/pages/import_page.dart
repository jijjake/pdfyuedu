import 'package:flutter/material.dart';
import 'package:pdfyuedu/services/book_service.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  final BookService _bookService = BookService();
  bool _isImporting = false;

  Future<void> _importFromLocal() async {
    setState(() {
      _isImporting = true;
    });

    try {
      String mockFilePath = '/path/to/mock/book.pdf';
      await _bookService.importBook(mockFilePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('书籍导入成功')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导入失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('导入书籍'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isImporting ? null : _importFromLocal,
              child: const Text('从本地导入'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('从云存储导入'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('从网站下载'),
            ),
          ],
        ),
      ),
    );
  }
}
