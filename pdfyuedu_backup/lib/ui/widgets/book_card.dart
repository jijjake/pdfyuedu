import 'package:flutter/material.dart';
import 'package:pdfyuedu/models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: book.coverUrl.isNotEmpty
                  ? Image.network(book.coverUrl, fit: BoxFit.cover)
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.book, size: 48, color: Colors.grey),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                book.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            if (book.author.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  book.author,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
