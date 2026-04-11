import 'dart:convert';

class CloudStorageAccount {
  String id;
  String type;
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
