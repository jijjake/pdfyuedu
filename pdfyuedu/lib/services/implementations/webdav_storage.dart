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
