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
