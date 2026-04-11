import 'package:pdfx/pdfx.dart';
import 'package:pdfyuedu/models/book.dart';
import 'package:pdfyuedu/services/book_service.dart';

class ReaderService {
  final BookService _bookService = BookService();
  PdfController? _pdfController;

  Future<PdfController> loadPDF(String filePath) async {
    _pdfController = PdfController(
      document: PdfDocument.openFile(filePath),
    );
    return _pdfController!;
  }

  Future<void> saveReadingProgress(Book book, double progress) async {
    book.readingProgress = progress;
    book.lastReadAt = DateTime.now();
    await _bookService.updateBook(book);
  }

  void dispose() {
    _pdfController?.dispose();
  }
}
