import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/book.dart';
import '../models/cloud_storage_account.dart';
import '../models/custom_website.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'pdfyuedu.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT,
        publisher TEXT,
        isbn TEXT,
        coverUrl TEXT,
        description TEXT,
        filePath TEXT,
        cloudPath TEXT,
        categories TEXT,
        tags TEXT,
        readingProgress REAL,
        isFavorite INTEGER,
        addedAt TEXT,
        lastReadAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cloud_storage_accounts (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        name TEXT NOT NULL,
        accessToken TEXT NOT NULL,
        refreshToken TEXT,
        rootPath TEXT,
        isEnabled INTEGER,
        autoSync INTEGER,
        lastSyncAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE custom_websites (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        url TEXT NOT NULL,
        category TEXT,
        searchPattern TEXT,
        downloadPattern TEXT,
        isEnabled INTEGER
      )
    ''');
  }

  Future<void> insertBook(Book book) async {
    final db = await database;
    await db.insert('books', book.toMap());
  }

  Future<List<Book>> getBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  Future<void> updateBook(Book book) async {
    final db = await database;
    await db.update('books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  }

  Future<void> deleteBook(String id) async {
    final db = await database;
    await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertCloudStorageAccount(CloudStorageAccount account) async {
    final db = await database;
    await db.insert('cloud_storage_accounts', account.toMap());
  }

  Future<List<CloudStorageAccount>> getCloudStorageAccounts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cloud_storage_accounts');
    return List.generate(maps.length, (i) => CloudStorageAccount.fromMap(maps[i]));
  }

  Future<void> updateCloudStorageAccount(CloudStorageAccount account) async {
    final db = await database;
    await db.update('cloud_storage_accounts', account.toMap(), where: 'id = ?', whereArgs: [account.id]);
  }

  Future<void> deleteCloudStorageAccount(String id) async {
    final db = await database;
    await db.delete('cloud_storage_accounts', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertCustomWebsite(CustomWebsite website) async {
    final db = await database;
    await db.insert('custom_websites', website.toMap());
  }

  Future<List<CustomWebsite>> getCustomWebsites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('custom_websites');
    return List.generate(maps.length, (i) => CustomWebsite.fromMap(maps[i]));
  }

  Future<void> updateCustomWebsite(CustomWebsite website) async {
    final db = await database;
    await db.update('custom_websites', website.toMap(), where: 'id = ?', whereArgs: [website.id]);
  }

  Future<void> deleteCustomWebsite(String id) async {
    final db = await database;
    await db.delete('custom_websites', where: 'id = ?', whereArgs: [id]);
  }
}
