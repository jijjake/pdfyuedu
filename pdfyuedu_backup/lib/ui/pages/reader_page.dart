import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:pdfyuedu/models/book.dart';
import 'package:pdfyuedu/services/reader_service.dart';

class ReaderPage extends StatefulWidget {
  final Book book;

  const ReaderPage({super.key, required this.book});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  final ReaderService _readerService = ReaderService();
  late PdfController _pdfController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    try {
      _pdfController = await _readerService.loadPDF(widget.book.filePath);
      if (widget.book.readingProgress > 0) {
        int page = (_pdfController.pagesCount * widget.book.readingProgress).toInt();
        _pdfController.jumpToPage(page);
      }
    } catch (e) {
      print('加载PDF失败: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _readerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : PdfView(
              controller: _pdfController,
              onDocumentLoaded: (document) {
                print('文档加载完成，共 ${document.pagesCount} 页');
              },
              onPageChanged: (page) {
                double progress = page / _pdfController.pagesCount;
                _readerService.saveReadingProgress(widget.book, progress);
              },
              pageLoader: const Center(child: CircularProgressIndicator()),
            ),
    );
  }
}
