import { useState, useEffect } from 'react';
import type { CloudStorageAccount } from '../types';
import { cloudStorageService } from '../services/databaseService';

const SettingsPage: React.FC = () => {
  const [accounts, setAccounts] = useState<CloudStorageAccount[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [showAddForm, setShowAddForm] = useState(false);
  const [newAccount, setNewAccount] = useState({
    name: '',
    url: '',
    username: '',
    password: ''
  });

  useEffect(() => {
    loadAccounts();
  }, []);

  const loadAccounts = async () => {
    setIsLoading(true);
    try {
      const loadedAccounts = await cloudStorageService.getAllAccounts();
      setAccounts(loadedAccounts);
    } catch (error) {
      console.error('加载云存储账户失败:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleAddAccount = async () => {
    if (!newAccount.name || !newAccount.url || !newAccount.username || !newAccount.password) {
      alert('请填写所有字段');
      return;
    }

    const account: CloudStorageAccount = {
      id: crypto.randomUUID(),
      type: 'WebDAV',
      name: newAccount.name,
      url: newAccount.url,
      username: newAccount.username,
      password: newAccount.password,
      rootPath: '/',
      isEnabled: true,
      lastSyncAt: new Date()
    };

    try {
      await cloudStorageService.addAccount(account);
      await loadAccounts();
      setShowAddForm(false);
      setNewAccount({
        name: '',
        url: '',
        username: '',
        password: ''
      });
    } catch (error) {
      console.error('添加云存储账户失败:', error);
    }
  };

  const handleDeleteAccount = async (id: string) => {
    if (window.confirm('确定要删除这个云存储账户吗？')) {
      try {
        await cloudStorageService.deleteAccount(id);
        await loadAccounts();
      } catch (error) {
        console.error('删除云存储账户失败:', error);
      }
    }
  };

  if (isLoading) {
    return <div className="flex justify-center items-center h-64">加载中...</div>;
  }

  return (
    <div className="max-w-2xl mx-auto">
      <h2 className="text-2xl font-bold mb-6">设置</h2>

      <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6 mb-8">
        <div className="flex justify-between items-center mb-4">
          <h3 className="text-lg font-medium">云存储服务</h3>
          <button
            onClick={() => setShowAddForm(!showAddForm)}
            className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
          >
            {showAddForm ? '取消' : '添加服务'}
          </button>
        </div>

        {showAddForm && (
          <div className="border-t border-gray-200 dark:border-gray-700 pt-4 mt-4">
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium mb-1">名称</label>
                <input
                  type="text"
                  value={newAccount.name}
                  onChange={(e) => setNewAccount({ ...newAccount, name: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">WebDAV URL</label>
                <input
                  type="text"
                  value={newAccount.url}
                  onChange={(e) => setNewAccount({ ...newAccount, url: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">用户名</label>
                <input
                  type="text"
                  value={newAccount.username}
                  onChange={(e) => setNewAccount({ ...newAccount, username: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">密码</label>
                <input
                  type="password"
                  value={newAccount.password}
                  onChange={(e) => setNewAccount({ ...newAccount, password: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white"
                />
              </div>
              <button
                onClick={handleAddAccount}
                className="w-full px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
              >
                保存
              </button>
            </div>
          </div>
        )}

        {accounts.length === 0 && (
          <p className="text-gray-600 dark:text-gray-300">
            暂无云存储服务，请添加一个。
          </p>
        )}

        {accounts.length > 0 && (
          <div className="space-y-4">
            {accounts.map((account) => (
              <div key={account.id} className="flex justify-between items-center p-4 border border-gray-200 dark:border-gray-700 rounded-md">
                <div>
                  <h4 className="font-medium">{account.name}</h4>
                  <p className="text-sm text-gray-500 dark:text-gray-400">{account.url}</p>
                </div>
                <div className="flex space-x-2">
                  <button
                    onClick={() => handleDeleteAccount(account.id)}
                    className="px-3 py-1 bg-red-600 text-white rounded-md hover:bg-red-700 text-sm"
                  >
                    删除
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
        <h3 className="text-lg font-medium mb-4">关于</h3>
        <p className="text-gray-600 dark:text-gray-300 mb-4">
          书库 v1.0.0
        </p>
        <p className="text-gray-600 dark:text-gray-300">
          一款基于Web的书籍管理软件，支持本地存储和云存储同步。
        </p>
      </div>
    </div>
  );
};

export default SettingsPage;
