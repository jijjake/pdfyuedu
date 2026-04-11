import 'dart:convert';

class Book {
  String id;
  String title;
  String author;
  String publisher;
  String isbn;
  String coverUrl;
  String description;
  String filePath;
  String cloudPath;
  List<String> categories;
  List<String> tags;
  double readingProgress;
  bool isFavorite;
  DateTime addedAt;
  DateTime lastReadAt;

  Book({
    required this.id,
    required this.title,
    this.author = '',
    this.publisher = '',
    this.isbn = '',
    this.coverUrl = '',
    this.description = '',
    this.filePath = '',
    this.cloudPath = '',
    this.categories = const [],
    this.tags = const [],
    this.readingProgress = 0.0,
    this.isFavorite = false,
    DateTime? addedAt,
    DateTime? lastReadAt,
  }) : 
    addedAt = addedAt ?? DateTime.now(),
    lastReadAt = lastReadAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publisher': publisher,
      'isbn': isbn,
      'coverUrl': coverUrl,
      'description': description,
      'filePath': filePath,
      'cloudPath': cloudPath,
      'categories': json.encode(categories),
      'tags': json.encode(tags),
      'readingProgress': readingProgress,
      'isFavorite': isFavorite ? 1 : 0,
      'addedAt': addedAt.toIso8601String(),
      'lastReadAt': lastReadAt.toIso8601String(),
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      publisher: map['publisher'],
      isbn: map['isbn'],
      coverUrl: map['coverUrl'],
      description: map['description'],
      filePath: map['filePath'],
      cloudPath: map['cloudPath'],
      categories: List<String>.from(json.decode(map['categories'])),
      tags: List<String>.from(json.decode(map['tags'])),
      readingProgress: map['readingProgress'],
      isFavorite: map['isFavorite'] == 1,
      addedAt: DateTime.parse(map['addedAt']),
      lastReadAt: DateTime.parse(map['lastReadAt']),
    );
  }
}
