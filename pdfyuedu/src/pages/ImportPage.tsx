import { useState } from 'react';
import type { Book } from '../types';
import { bookService } from '../services/databaseService';
import { bookInfoService } from '../services/bookInfoService';

const ImportPage: React.FC = () => {
  const [isImporting, setIsImporting] = useState(false);
  const [importStatus, setImportStatus] = useState<string>('');

  const handleFileUpload = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = event.target.files;
    if (!files || files.length === 0) return;

    setIsImporting(true);
    setImportStatus('正在导入书籍...');

    try {
      for (let i = 0; i < files.length; i++) {
        const file = files[i];
        
        // 创建书籍对象
        const book: Book = {
          id: crypto.randomUUID(),
          title: file.name.replace(/\.[^/.]+$/, ''),
          author: '',
          publisher: '',
          isbn: '',
          coverUrl: '',
          description: '',
          filePath: URL.createObjectURL(file),
          cloudPath: '',
          categories: [],
          tags: [],
          readingProgress: 0,
          isFavorite: false,
          addedAt: new Date(),
          lastReadAt: new Date()
        };

        // 尝试获取书籍信息
        const enrichedBook = await bookInfoService.enrichBookInfo(book);

        // 保存到数据库
        await bookService.addBook(enrichedBook);

        setImportStatus(`已导入 ${i + 1}/${files.length} 本书籍`);
      }

      setImportStatus('导入完成！');
    } catch (error) {
      console.error('导入书籍失败:', error);
      setImportStatus('导入失败，请重试');
    } finally {
      setIsImporting(false);
      // 清空文件输入
      event.target.value = '';
    }
  };

  return (
    <div className="max-w-2xl mx-auto">
      <h2 className="text-2xl font-bold mb-6">导入书籍</h2>

      <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
        <h3 className="text-lg font-medium mb-4">从本地导入</h3>
        
        <div className="border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-lg p-8 text-center">
          <svg xmlns="http://www.w3.org/2000/svg" className="h-16 w-16 mx-auto text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
          </svg>
          <p className="mt-4 text-gray-600 dark:text-gray-300">
            点击或拖拽文件到此处导入
          </p>
          <input
            type="file"
            accept=".pdf,.epub,.mobi"
            multiple
            className="hidden"
            id="file-upload"
            onChange={handleFileUpload}
          />
          <label
            htmlFor="file-upload"
            className="mt-4 inline-block px-6 py-3 bg-blue-600 text-white rounded-md hover:bg-blue-700 cursor-pointer"
          >
            选择文件
          </label>
          <p className="mt-2 text-sm text-gray-500 dark:text-gray-400">
            支持 PDF、EPUB、MOBI 格式
          </p>
        </div>

        {isImporting && (
          <div className="mt-6 p-4 bg-gray-100 dark:bg-gray-700 rounded-md">
            <div className="flex items-center">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mr-3"></div>
              <p>{importStatus}</p>
            </div>
          </div>
        )}

        {importStatus && !isImporting && (
          <div className="mt-6 p-4 bg-green-100 dark:bg-green-900 text-green-800 dark:text-green-200 rounded-md">
            <p>{importStatus}</p>
          </div>
        )}
      </div>

      <div className="mt-8 bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
        <h3 className="text-lg font-medium mb-4">从云存储导入</h3>
        <p className="text-gray-600 dark:text-gray-300">
          请先在设置中添加云存储服务，然后从云存储中导入书籍。
        </p>
      </div>
    </div>
  );
};

export default ImportPage;
