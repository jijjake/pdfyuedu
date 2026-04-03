import { useState } from 'react';
import './App.css';
import LibraryPage from './pages/LibraryPage';
import ImportPage from './pages/ImportPage';
import SearchPage from './pages/SearchPage';
import SettingsPage from './pages/SettingsPage';
import ReaderPage from './pages/ReaderPage';
import type { Book } from './types';

function App() {
  const [currentPage, setCurrentPage] = useState<string>('library');
  const [selectedBook, setSelectedBook] = useState<Book | null>(null);

  const handleBookSelect = (book: Book) => {
    setSelectedBook(book);
    setCurrentPage('reader');
  };

  const renderPage = () => {
    switch (currentPage) {
      case 'library':
        return <LibraryPage onBookSelect={handleBookSelect} />;
      case 'import':
        return <ImportPage />;
      case 'search':
        return <SearchPage onBookSelect={handleBookSelect} />;
      case 'settings':
        return <SettingsPage />;
      case 'reader':
        return selectedBook ? <ReaderPage book={selectedBook} /> : <LibraryPage onBookSelect={handleBookSelect} />;
      default:
        return <LibraryPage onBookSelect={handleBookSelect} />;
    }
  };

  return (
    <div className="min-h-screen bg-gray-100 dark:bg-gray-900 text-gray-900 dark:text-gray-100">
      {/* 顶部导航栏 */}
      <header className="bg-white dark:bg-gray-800 shadow-md">
        <div className="container mx-auto px-4 py-3 flex justify-between items-center">
          <h1 className="text-xl font-bold">书库</h1>
          <nav>
            <ul className="flex space-x-6">
              <li>
                <button
                  onClick={() => setCurrentPage('library')}
                  className={`${currentPage === 'library' ? 'text-blue-600 dark:text-blue-400' : ''} hover:text-blue-600 dark:hover:text-blue-400`}
                >
                  书库
                </button>
              </li>
              <li>
                <button
                  onClick={() => setCurrentPage('import')}
                  className={`${currentPage === 'import' ? 'text-blue-600 dark:text-blue-400' : ''} hover:text-blue-600 dark:hover:text-blue-400`}
                >
                  导入
                </button>
              </li>
              <li>
                <button
                  onClick={() => setCurrentPage('search')}
                  className={`${currentPage === 'search' ? 'text-blue-600 dark:text-blue-400' : ''} hover:text-blue-600 dark:hover:text-blue-400`}
                >
                  搜索
                </button>
              </li>
              <li>
                <button
                  onClick={() => setCurrentPage('settings')}
                  className={`${currentPage === 'settings' ? 'text-blue-600 dark:text-blue-400' : ''} hover:text-blue-600 dark:hover:text-blue-400`}
                >
                  设置
                </button>
              </li>
            </ul>
          </nav>
        </div>
      </header>

      {/* 主内容区域 */}
      <main className="container mx-auto px-4 py-6">
        {renderPage()}
      </main>

      {/* 底部导航栏（移动端） */}
      <footer className="md:hidden fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-800 shadow-md">
        <div className="flex justify-around py-3">
          <button
            onClick={() => setCurrentPage('library')}
            className={`flex flex-col items-center ${currentPage === 'library' ? 'text-blue-600 dark:text-blue-400' : ''}`}
          >
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
            </svg>
            <span className="text-xs mt-1">书库</span>
          </button>
          <button
            onClick={() => setCurrentPage('import')}
            className={`flex flex-col items-center ${currentPage === 'import' ? 'text-blue-600 dark:text-blue-400' : ''}`}
          >
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
            </svg>
            <span className="text-xs mt-1">导入</span>
          </button>
          <button
            onClick={() => setCurrentPage('search')}
            className={`flex flex-col items-center ${currentPage === 'search' ? 'text-blue-600 dark:text-blue-400' : ''}`}
          >
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
            <span className="text-xs mt-1">搜索</span>
          </button>
          <button
            onClick={() => setCurrentPage('settings')}
            className={`flex flex-col items-center ${currentPage === 'settings' ? 'text-blue-600 dark:text-blue-400' : ''}`}
          >
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
            <span className="text-xs mt-1">设置</span>
          </button>
        </div>
      </footer>
    </div>
  );
}

export default App;
