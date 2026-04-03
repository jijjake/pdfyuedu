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
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addWebDAVAccount() async {
    CloudStorageAccount account = CloudStorageAccount(
      id: _uuid.v4(),
      type: 'WebDAV',
      name: '测试WebDAV',
      accessToken: 'password',
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
