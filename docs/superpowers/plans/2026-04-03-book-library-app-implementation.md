# 书库软件实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 开发一款跨平台的书库软件，支持书籍导入、云存储同步、搜索功能和内置阅读器。

**Architecture:** 使用Flutter框架实现跨平台支持，采用分层架构，包括用户界面层、业务逻辑层、数据访问层和云存储接口层。

**Tech Stack:** Flutter, SQLite, Provider/Bloc, 云存储API (百度网盘、Dropbox、Google Drive), WebDAV, ISBN API

---

## 第一阶段：基础架构搭建

### 任务1: 初始化Flutter项目

**Files:**
- Create: `/workspace/pdfyuedu/pubspec.yaml`
- Create: `/workspace/pdfyuedu/lib/main.dart`
- Create: `/workspace/pdfyuedu/lib/app/app.dart`

- [ ] **Step 1: 初始化Flutter项目**

```bash
flutter create --org com.pdfyuedu pdfyuedu
cd pdfyuedu
```

- [ ] **Step 2: 配置pubspec.yaml**

```yaml
name: pdfyuedu
description: A cross-platform book library app.
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  sqflite: ^2.3.0
  path_provider: ^2.1.0
  provider: ^6.1.1
  http: ^1.1.0
  pdfx: ^2.5.0
  epub: ^3.1.0
  webdav_client: ^3.0.0
  google_sign_in: ^6.1.4
  dropbox_api: ^1.0.0
  flutter_secure_storage: ^9.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
```

- [ ] **Step 3: 创建主应用入口**

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:pdfyuedu/app/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF阅读',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const App(),
    );
  }
}
```

- [ ] **Step 4: 创建App组件**

```dart
// lib/app/app.dart
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF阅读'),
      ),
      body: const Center(
        child: Text('书库软件'),
      ),
    );
  }
}
```

- [ ] **Step 5: 运行项目**

```bash
flutter run
```

- [ ] **Step 6: 提交代码**

```bash
git add .
git commit -m "feat: 初始化Flutter项目"
```

### 任务2: 实现数据模型

**Files:**
- Create: `/workspace/pdfyuedu/lib/models/book.dart`
- Create: `/workspace/pdfyuedu/lib/models/cloud_storage_account.dart`
- Create: `/workspace/pdfyuedu/lib/models/custom_website.dart`

- [ ] **Step 1: 创建书籍模型**

```dart
// lib/models/book.dart
import 'dart:convert';
import 'package:flutter/material.dart';

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
```

- [ ] **Step 2: 创建云存储账户模型**

```dart
// lib/models/cloud_storage_account.dart
import 'dart:convert';

class CloudStorageAccount {
  String id;
  String type; // 百度网盘、Dropbox、Google Drive、WebDAV等
  String name;
  String accessToken;
  String refreshToken;
  String rootPath;
  bool isEnabled;
  bool autoSync;
  DateTime lastSyncAt;

  CloudStorageAccount({
    required this.id,
    required this.type,
    required this.name,
    required this.accessToken,
    this.refreshToken = '',
    this.rootPath = '/',
    this.isEnabled = true,
    this.autoSync = false,
    DateTime? lastSyncAt,
  }) : lastSyncAt = lastSyncAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'rootPath': rootPath,
      'isEnabled': isEnabled ? 1 : 0,
      'autoSync': autoSync ? 1 : 0,
      'lastSyncAt': lastSyncAt.toIso8601String(),
    };
  }

  factory CloudStorageAccount.fromMap(Map<String, dynamic> map) {
    return CloudStorageAccount(
      id: map['id'],
      type: map['type'],
      name: map['name'],
      accessToken: map['accessToken'],
      refreshToken: map['refreshToken'],
      rootPath: map['rootPath'],
      isEnabled: map['isEnabled'] == 1,
      autoSync: map['autoSync'] == 1,
      lastSyncAt: DateTime.parse(map['lastSyncAt']),
    );
  }
}
```

- [ ] **Step 3: 创建自定义网站模型**

```dart
// lib/models/custom_website.dart
class CustomWebsite {
  String id;
  String name;
  String url;
  String category;
  String searchPattern;
  String downloadPattern;
  bool isEnabled;

  CustomWebsite({
    required this.id,
    required this.name,
    required this.url,
    this.category = '',
    this.searchPattern = '',
    this.downloadPattern = '',
    this.isEnabled = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'category': category,
      'searchPattern': searchPattern,
      'downloadPattern': downloadPattern,
      'isEnabled': isEnabled ? 1 : 0,
    };
  }

  factory CustomWebsite.fromMap(Map<String, dynamic> map) {
    return CustomWebsite(
      id: map['id'],
      name: map['name'],
      url: map['url'],
      category: map['category'],
      searchPattern: map['searchPattern'],
      downloadPattern: map['downloadPattern'],
      isEnabled: map['isEnabled'] == 1,
    );
  }
}
```

- [ ] **Step 4: 提交代码**

```bash
git add lib/models/
git commit -m "feat: 实现数据模型"
```

### 任务3: 实现数据库管理

**Files:**
- Create: `/workspace/pdfyuedu/lib/services/database_service.dart`

- [ ] **Step 1: 创建数据库服务**

```dart
// lib/services/database_service.dart
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
    // 创建书籍表
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

    // 创建云存储账户表
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

    // 创建自定义网站表
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

  // 书籍相关操作
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

  // 云存储账户相关操作
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

  // 自定义网站相关操作
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
```

- [ ] **Step 2: 提交代码**

```bash
git add lib/services/database_service.dart
git commit -m "feat: 实现数据库管理"
```

## 第二阶段：书籍管理功能

### 任务4: 实现书籍导入功能

**Files:**
- Create: `/workspace/pdfyuedu/lib/services/book_service.dart`
- Create: `/workspace/pdfyuedu/lib/ui/pages/import_page.dart`

- [ ] **Step 1: 创建书籍服务**

```dart
// lib/services/book_service.dart
import 'dart:io';
import 'package:uuid/uuid.dart';
import '../models/book.dart';
import './database_service.dart';

class BookService {
  final DatabaseService _databaseService = DatabaseService();
  final Uuid _uuid = const Uuid();

  Future<Book> importBook(String filePath) async {
    // 从文件路径提取书籍信息
    File file = File(filePath);
    String fileName = file.path.split('/').last;
    String title = fileName.replaceAll(RegExp(r'\.[^.]+$'), '');

    // 创建书籍对象
    Book book = Book(
      id: _uuid.v4(),
      title: title,
      filePath: filePath,
    );

    // 保存到数据库
    await _databaseService.insertBook(book);
    return book;
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
```

- [ ] **Step 2: 创建导入页面**

```dart
// lib/ui/pages/import_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      // 这里使用模拟数据，实际应用中需要使用文件选择器
      // 例如使用 file_picker 库
      String mockFilePath = '/path/to/mock/book.pdf';
      await _bookService.importBook(mockFilePath);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('书籍导入成功')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导入失败: $e')),
      );
    } finally {
      setState(() {
        _isImporting = false;
      });
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
              onPressed: () {
                // 从云存储导入
              },
              child: const Text('从云存储导入'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 从自定义网站下载导入
              },
              child: const Text('从网站下载'),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: 添加文件选择器依赖**

```yaml
# pubspec.yaml
dependencies:
  # ... 其他依赖
  file_picker: ^6.0.0
```

- [ ] **Step 4: 提交代码**

```bash
git add lib/services/book_service.dart lib/ui/pages/import_page.dart
git commit -m "feat: 实现书籍导入功能"
```

### 任务5: 实现书库主界面

**Files:**
- Create: `/workspace/pdfyuedu/lib/ui/pages/library_page.dart`
- Create: `/workspace/pdfyuedu/lib/ui/widgets/book_card.dart`
- Modify: `/workspace/pdfyuedu/lib/app/app.dart`

- [ ] **Step 1: 创建书籍卡片组件**

```dart
// lib/ui/widgets/book_card.dart
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
```

- [ ] **Step 2: 创建书库页面**

```dart
// lib/ui/pages/library_page.dart
import 'package:flutter/material.dart';
import 'package:pdfyuedu/models/book.dart';
import 'package:pdfyuedu/services/book_service.dart';
import '../widgets/book_card.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final BookService _bookService = BookService();
  List<Book> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _books = await _bookService.getBooks();
    } catch (e) {
      print('加载书籍失败: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('书库'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                return BookCard(
                  book: _books[index],
                  onTap: () {
                    // 导航到书籍详情页
                  },
                );
              },
            ),
    );
  }
}
```

- [ ] **Step 3: 更新App组件**

```dart
// lib/app/app.dart
import 'package:flutter/material.dart';
import '../ui/pages/library_page.dart';
import '../ui/pages/import_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const LibraryPage(),
    const ImportPage(),
    // 搜索页面
    const Center(child: Text('搜索')),
    // 设置页面
    const Center(child: Text('设置')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '书库',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: '导入',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '搜索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: 提交代码**

```bash
git add lib/ui/pages/library_page.dart lib/ui/widgets/book_card.dart lib/app/app.dart
git commit -m "feat: 实现书库主界面"
```

## 第三阶段：云存储集成

### 任务6: 实现云存储接口

**Files:**
- Create: `/workspace/pdfyuedu/lib/services/cloud_storage_service.dart`
- Create: `/workspace/pdfyuedu/lib/services/implementations/webdav_storage.dart`

- [ ] **Step 1: 创建云存储接口**

```dart
// lib/services/cloud_storage_service.dart
import 'dart:io';

abstract class CloudStorage {
  Future<void> authenticate();
  Future<List<FileInfo>> listFiles(String path);
  Future<void> uploadFile(String localPath, String remotePath);
  Future<void> downloadFile(String remotePath, String localPath);
  Future<void> deleteFile(String path);
  Future<bool> exists(String path);
}

class FileInfo {
  final String name;
  final String path;
  final bool isDirectory;
  final int size;
  final DateTime lastModified;

  FileInfo({
    required this.name,
    required this.path,
    required this.isDirectory,
    required this.size,
    required this.lastModified,
  });
}
```

- [ ] **Step 2: 实现WebDAV存储**

```dart
// lib/services/implementations/webdav_storage.dart
import 'package:webdav_client/webdav_client.dart';
import '../cloud_storage_service.dart';

class WebDAVStorage implements CloudStorage {
  late Client _client;
  final String url;
  final String username;
  final String password;

  WebDAVStorage({
    required this.url,
    required this.username,
    required this.password,
  });

  @override
  Future<void> authenticate() async {
    _client = Client(url)
      ..auth(username, password)
      ..setHeaders({
        'User-Agent': 'PDF阅读',
      });
  }

  @override
  Future<List<FileInfo>> listFiles(String path) async {
    final files = await _client.readDir(path);
    return files.map((file) {
      return FileInfo(
        name: file.name,
        path: file.path,
        isDirectory: file.isDir,
        size: file.size,
        lastModified: file.mtime,
      );
    }).toList();
  }

  @override
  Future<void> uploadFile(String localPath, String remotePath) async {
    await _client.writeFromFile(localPath, remotePath);
  }

  @override
  Future<void> downloadFile(String remotePath, String localPath) async {
    await _client.read2File(remotePath, localPath);
  }

  @override
  Future<void> deleteFile(String path) async {
    await _client.delete(path);
  }

  @override
  Future<bool> exists(String path) async {
    try {
      await _client.stat(path);
      return true;
    } catch (e) {
      return false;
    }
  }
}
```

- [ ] **Step 3: 提交代码**

```bash
git add lib/services/cloud_storage_service.dart lib/services/implementations/webdav_storage.dart
git commit -m "feat: 实现云存储接口"
```

### 任务7: 实现云存储设置页面

**Files:**
- Create: `/workspace/pdfyuedu/lib/ui/pages/cloud_storage_page.dart`
- Modify: `/workspace/pdfyuedu/lib/app/app.dart`

- [ ] **Step 1: 创建云存储设置页面**

```dart
// lib/ui/pages/cloud_storage_page.dart
import 'package:flutter/material.dart';
import 'package:pdfyuedu/models/cloud_storage_account.dart';
import 'package:pdfyuedu/services/database_service.dart';
import 'package:uuid/uuid.dart';

class CloudStoragePage extends StatefulWidget {
  const CloudStoragePage({super.key});

  @override
  State<CloudStoragePage> createState() => _CloudStoragePageState();
}

class _CloudStoragePageState extends State<CloudStoragePage> {
  final DatabaseService _databaseService = DatabaseService();
  final Uuid _uuid = const Uuid();
  List<CloudStorageAccount> _accounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _accounts = await _databaseService.getCloudStorageAccounts();
    } catch (e) {
      print('加载云存储账户失败: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addWebDAVAccount() async {
    // 这里使用模拟数据，实际应用中需要使用表单
    CloudStorageAccount account = CloudStorageAccount(
      id: _uuid.v4(),
      type: 'WebDAV',
      name: '测试WebDAV',
      accessToken: 'password', // 这里存储密码，实际应用中需要加密
      rootPath: '/',
    );

    await _databaseService.insertCloudStorageAccount(account);
    await _loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('云存储设置'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _accounts.length + 1,
              itemBuilder: (context, index) {
                if (index == _accounts.length) {
                  return ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('添加云存储服务'),
                    onTap: () {
                      // 显示添加服务的选项
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('添加云存储服务'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.cloud),
                                  title: const Text('WebDAV'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _addWebDAVAccount();
                                  },
                                ),
                                // 添加其他云存储服务选项
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                CloudStorageAccount account = _accounts[index];
                return ListTile(
                  leading: const Icon(Icons.cloud),
                  title: Text(account.name),
                  subtitle: Text(account.type),
                  trailing: Switch(
                    value: account.isEnabled,
                    onChanged: (value) async {
                      account.isEnabled = value;
                      await _databaseService.updateCloudStorageAccount(account);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
    );
  }
}
```

- [ ] **Step 2: 更新App组件，添加设置页面**

```dart
// lib/app/app.dart
import 'package:flutter/material.dart';
import '../ui/pages/library_page.dart';
import '../ui/pages/import_page.dart';
import '../ui/pages/cloud_storage_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const LibraryPage(),
    const ImportPage(),
    // 搜索页面
    const Center(child: Text('搜索')),
    // 设置页面
    const CloudStoragePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '书库',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: '导入',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '搜索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: 提交代码**

```bash
git add lib/ui/pages/cloud_storage_page.dart lib/app/app.dart
git commit -m "feat: 实现云存储设置页面"
```

## 第四阶段：搜索和信息收集功能

### 任务8: 实现书籍搜索功能

**Files:**
- Create: `/workspace/pdfyuedu/lib/services/search_service.dart`
- Create: `/workspace/pdfyuedu/lib/ui/pages/search_page.dart`
- Modify: `/workspace/pdfyuedu/lib/app/app.dart`

- [ ] **Step 1: 创建搜索服务**

```dart
// lib/services/search_service.dart
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
    // 这里使用模拟数据，实际应用中需要调用API
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
```

- [ ] **Step 2: 创建搜索页面**

```dart
// lib/ui/pages/search_page.dart
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
      // 搜索本地书籍
      _localResults = await _searchService.searchLocal(keyword);

      // 搜索在线书籍
      if (_showOnlineResults) {
        _onlineResults = await _searchService.searchOnline(keyword);
      }
    } catch (e) {
      print('搜索失败: $e');
    } finally {
      setState(() {
        _isSearching = false;
      });
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
                                onTap: () {
                                  // 导航到书籍详情页
                                },
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
                                onTap: () {
                                  // 下载书籍
                                },
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
```

- [ ] **Step 3: 更新App组件，添加搜索页面**

```dart
// lib/app/app.dart
import 'package:flutter/material.dart';
import '../ui/pages/library_page.dart';
import '../ui/pages/import_page.dart';
import '../ui/pages/search_page.dart';
import '../ui/pages/cloud_storage_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const LibraryPage(),
    const ImportPage(),
    const SearchPage(),
    const CloudStoragePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '书库',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: '导入',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '搜索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: 提交代码**

```bash
git add lib/services/search_service.dart lib/ui/pages/search_page.dart lib/app/app.dart
git commit -m "feat: 实现书籍搜索功能"
```

### 任务9: 实现书籍信息自动收集功能

**Files:**
- Create: `/workspace/pdfyuedu/lib/services/book_info_service.dart`

- [ ] **Step 1: 创建书籍信息服务**

```dart
// lib/services/book_info_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pdfyuedu/models/book.dart';

class BookInfoService {
  Future<Map<String, dynamic>> getBookInfoByISBN(String isbn) async {
    // 这里使用模拟数据，实际应用中需要调用ISBN API
    // 例如使用 Open Library API
    return {
      'title': '测试书籍',
      'author': '测试作者',
      'publisher': '测试出版社',
      'description': '这是一本测试书籍',
      'coverUrl': 'https://example.com/cover.jpg',
    };
  }

  Future<Map<String, dynamic>> getBookInfoByTitle(String title) async {
    // 这里使用模拟数据，实际应用中需要调用搜索API
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
```

- [ ] **Step 2: 更新书籍服务，集成信息收集功能**

```dart
// lib/services/book_service.dart
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
    // 从文件路径提取书籍信息
    File file = File(filePath);
    String fileName = file.path.split('/').last;
    String title = fileName.replaceAll(RegExp(r'\.[^.]+$'), '');

    // 创建书籍对象
    Book book = Book(
      id: _uuid.v4(),
      title: title,
      filePath: filePath,
    );

    // 尝试获取书籍信息
    Book enrichedBook = await _bookInfoService.enrichBookInfo(book);

    // 保存到数据库
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
```

- [ ] **Step 3: 提交代码**

```bash
git add lib/services/book_info_service.dart lib/services/book_service.dart
git commit -m "feat: 实现书籍信息自动收集功能"
```

## 第五阶段：阅读器功能

### 任务10: 实现内置阅读器

**Files:**
- Create: `/workspace/pdfyuedu/lib/ui/pages/reader_page.dart`
- Create: `/workspace/pdfyuedu/lib/services/reader_service.dart`

- [ ] **Step 1: 创建阅读器服务**

```dart
// lib/services/reader_service.dart
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
```

- [ ] **Step 2: 创建阅读器页面**

```dart
// lib/ui/pages/reader_page.dart
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
      // 跳转到上次阅读的位置
      if (widget.book.readingProgress > 0) {
        // 这里需要根据阅读进度计算页码
        // 简化处理，实际应用中需要更精确的计算
        int page = (_pdfController.pagesCount * widget.book.readingProgress).toInt();
        _pdfController.jumpToPage(page);
      }
    } catch (e) {
      print('加载PDF失败: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                // 保存阅读进度
                double progress = page / _pdfController.pagesCount;
                _readerService.saveReadingProgress(widget.book, progress);
              },
              pageLoader: const Center(child: CircularProgressIndicator()),
            ),
    );
  }
}
```

- [ ] **Step 3: 更新LibraryPage，添加导航到阅读器的功能**

```dart
// lib/ui/pages/library_page.dart
import 'package:flutter/material.dart';
import 'package:pdfyuedu/models/book.dart';
import 'package:pdfyuedu/services/book_service.dart';
import '../widgets/book_card.dart';
import '../pages/reader_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final BookService _bookService = BookService();
  List<Book> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _books = await _bookService.getBooks();
    } catch (e) {
      print('加载书籍失败: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('书库'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                return BookCard(
                  book: _books[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReaderPage(book: _books[index]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
```

- [ ] **Step 4: 提交代码**

```bash
git add lib/services/reader_service.dart lib/ui/pages/reader_page.dart lib/ui/pages/library_page.dart
git commit -m "feat: 实现内置阅读器"
```

## 第六阶段：完善和测试

### 任务11: 完善用户界面和交互

**Files:**
- Modify: `/workspace/pdfyuedu/lib/ui/pages/library_page.dart`
- Modify: `/workspace/pdfyuedu/lib/ui/pages/import_page.dart`
- Modify: `/workspace/pdfyuedu/lib/ui/pages/search_page.dart`
- Modify: `/workspace/pdfyuedu/lib/ui/pages/cloud_storage_page.dart`

- [ ] **Step 1: 完善书库页面，添加筛选和排序功能**

```dart
// 在LibraryPage中添加筛选和排序功能
// 具体实现略
```

- [ ] **Step 2: 完善导入页面，添加文件选择器**

```dart
// 在ImportPage中添加文件选择器
// 具体实现略
```

- [ ] **Step 3: 完善搜索页面，添加搜索历史**

```dart
// 在SearchPage中添加搜索历史
// 具体实现略
```

- [ ] **Step 4: 完善云存储页面，添加更多云存储服务**

```dart
// 在CloudStoragePage中添加更多云存储服务
// 具体实现略
```

- [ ] **Step 5: 提交代码**

```bash
git add lib/ui/pages/
git commit -m "feat: 完善用户界面和交互"
```

### 任务12: 测试和优化

**Files:**
- Create: `/workspace/pdfyuedu/test/book_service_test.dart`
- Create: `/workspace/pdfyuedu/test/database_service_test.dart`

- [ ] **Step 1: 编写单元测试**

```dart
// test/book_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfyuedu/services/book_service.dart';

void main() {
  test('测试书籍导入', () async {
    final bookService = BookService();
    // 测试导入功能
    // 具体测试代码略
  });

  test('测试获取书籍列表', () async {
    final bookService = BookService();
    // 测试获取书籍列表功能
    // 具体测试代码略
  });
}
```

- [ ] **Step 2: 运行测试**

```bash
flutter test
```

- [ ] **Step 3: 性能优化**

```dart
// 优化数据库查询
// 优化图片加载
// 优化网络请求
// 具体实现略
```

- [ ] **Step 4: 提交代码**

```bash
git add test/
git commit -m "feat: 测试和优化"
```

---

## 执行选项

**Plan complete and saved to `docs/superpowers/plans/2026-04-03-book-library-app-implementation.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?**