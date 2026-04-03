import 'package:pdfyuedu/models/book.dart';
import 'package:pdfyuedu/services/book_service.dart';

class SearchService {
  final BookService _bookService = BookService();

  Future<List<Book>> searchLocal(String keyword) async {
    List<Book> books = await _bookService.getBooks();
    return books.where((book) {
      return book.title.toLowerCase().contains(keyword.toLowerCase()) ||
          book.author.toLowerCase().contains(keyword.toLowerCase()) ||
          book.isbn.contains(keyword);
    }).toList();
  }

  Future<List<Map<String, dynamic>>> searchOnline(String keyword) async {
    return [
      {
        'title': '测试书籍1',
        'author': '作者1',
        'coverUrl': 'https://example.com/cover1.jpg',
        'url': 'https://example.com/book1.pdf',
      },
      {
        'title': '测试书籍2',
        'author': '作者2',
        'coverUrl': 'https://example.com/cover2.jpg',
        'url': 'https://example.com/book2.pdf',
      },
    ];
  }
}
