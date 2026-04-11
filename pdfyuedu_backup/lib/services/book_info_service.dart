import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pdfyuedu/models/book.dart';

class BookInfoService {
  Future<Map<String, dynamic>> getBookInfoByISBN(String isbn) async {
    return {
      'title': '测试书籍',
      'author': '测试作者',
      'publisher': '测试出版社',
      'description': '这是一本测试书籍',
      'coverUrl': 'https://example.com/cover.jpg',
    };
  }

  Future<Map<String, dynamic>> getBookInfoByTitle(String title) async {
    return {
      'title': title,
      'author': '测试作者',
      'publisher': '测试出版社',
      'description': '这是一本测试书籍',
      'coverUrl': 'https://example.com/cover.jpg',
    };
  }

  Future<Book> enrichBookInfo(Book book) async {
    if (book.isbn.isNotEmpty) {
      try {
        final info = await getBookInfoByISBN(book.isbn);
        return Book(
          id: book.id,
          title: info['title'] ?? book.title,
          author: info['author'] ?? book.author,
          publisher: info['publisher'] ?? book.publisher,
          isbn: book.isbn,
          coverUrl: info['coverUrl'] ?? book.coverUrl,
          description: info['description'] ?? book.description,
          filePath: book.filePath,
          cloudPath: book.cloudPath,
          categories: book.categories,
          tags: book.tags,
          readingProgress: book.readingProgress,
          isFavorite: book.isFavorite,
          addedAt: book.addedAt,
          lastReadAt: book.lastReadAt,
        );
      } catch (e) {
        print('通过ISBN获取书籍信息失败: $e');
      }
    }

    if (book.title.isNotEmpty) {
      try {
        final info = await getBookInfoByTitle(book.title);
        return Book(
          id: book.id,
          title: info['title'] ?? book.title,
          author: info['author'] ?? book.author,
          publisher: info['publisher'] ?? book.publisher,
          isbn: book.isbn,
          coverUrl: info['coverUrl'] ?? book.coverUrl,
          description: info['description'] ?? book.description,
          filePath: book.filePath,
          cloudPath: book.cloudPath,
          categories: book.categories,
          tags: book.tags,
          readingProgress: book.readingProgress,
          isFavorite: book.isFavorite,
          addedAt: book.addedAt,
          lastReadAt: book.lastReadAt,
        );
      } catch (e) {
        print('通过标题获取书籍信息失败: $e');
      }
    }

    return book;
  }
}
