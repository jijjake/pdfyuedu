import 'dart:io';
import 'package:uuid/uuid.dart';
import '../models/book.dart';
import './database_service.dart';
import './book_info_service.dart';

class BookService {
  final DatabaseService _databaseService = DatabaseService();
  final BookInfoService _bookInfoService = BookInfoService();
  final Uuid _uuid = const Uuid();

  Future<Book> importBook(String filePath) async {
    File file = File(filePath);
    String fileName = file.path.split('/').last;
    String title = fileName.replaceAll(RegExp(r'\.[^.]+$'), '');

    Book book = Book(
      id: _uuid.v4(),
      title: title,
      filePath: filePath,
    );

    Book enrichedBook = await _bookInfoService.enrichBookInfo(book);
    await _databaseService.insertBook(enrichedBook);
    return enrichedBook;
  }

  Future<List<Book>> getBooks() async {
    return await _databaseService.getBooks();
  }

  Future<void> updateBook(Book book) async {
    await _databaseService.updateBook(book);
  }

  Future<void> deleteBook(String id) async {
    await _databaseService.deleteBook(id);
  }
}
