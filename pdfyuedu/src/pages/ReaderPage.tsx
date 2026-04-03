import { useState, useEffect, useRef } from 'react';
import type { Book } from '../types';
import { readerService } from '../services/readerService';

interface ReaderPageProps {
  book: Book;
}

const ReaderPage: React.FC<ReaderPageProps> = ({ book }) => {
  const [isLoading, setIsLoading] = useState(true);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(0);
  const canvasRef = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    loadPDF();
    return () => {
      readerService.dispose();
    };
  }, [book]);

  useEffect(() => {
    if (totalPages > 0) {
      renderPage(currentPage);
    }
  }, [currentPage, totalPages]);

  const loadPDF = async () => {
    setIsLoading(true);
    try {
      await readerService.loadPDF(book.filePath);
      setTotalPages(await readerService.getPageCount());
      
      // 根据阅读进度设置初始页面
      if (book.readingProgress > 0) {
        const initialPage = Math.max(1, Math.floor((await readerService.getPageCount()) * book.readingProgress));
        setCurrentPage(initialPage);
      }
    } catch (error) {
      console.error('加载PDF失败:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const renderPage = async (pageNumber: number) => {
    if (!canvasRef.current) return;

    try {
      const page = await readerService.getPage(pageNumber);
      const viewport = page.getViewport({ scale: 1.0 });
      
      const canvas = canvasRef.current;
      const context = canvas.getContext('2d');
      if (!context) return;

      canvas.height = viewport.height;
      canvas.width = viewport.width;

      const renderContext = {
        canvasContext: context,
        viewport: viewport,
        canvas: canvas
      };

      await page.render(renderContext).promise;

      // 保存阅读进度
      const progress = pageNumber / totalPages;
      readerService.saveReadingProgress(book, progress);
    } catch (error) {
      console.error('渲染页面失败:', error);
    }
  };

  const handlePreviousPage = () => {
    if (currentPage > 1) {
      setCurrentPage(currentPage - 1);
    }
  };

  const handleNextPage = () => {
    if (currentPage < totalPages) {
      setCurrentPage(currentPage + 1);
    }
  };

  if (isLoading) {
    return (
      <div className="flex flex-col items-center justify-center h-96">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mb-4"></div>
        <p>正在加载书籍...</p>
      </div>
    );
  }

  return (
    <div className="flex flex-col h-[calc(100vh-120px)]">
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-xl font-bold truncate">{book.title}</h2>
        <div className="flex items-center space-x-4">
          <button
            onClick={handlePreviousPage}
            disabled={currentPage === 1}
            className="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-md hover:bg-gray-300 dark:hover:bg-gray-600 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            上一页
          </button>
          <span>{currentPage} / {totalPages}</span>
          <button
            onClick={handleNextPage}
            disabled={currentPage === totalPages}
            className="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-md hover:bg-gray-300 dark:hover:bg-gray-600 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            下一页
          </button>
        </div>
      </div>

      <div className="flex-1 overflow-auto bg-white dark:bg-gray-800 p-4 rounded-lg shadow-md">
        <canvas ref={canvasRef} className="mx-auto" />
      </div>

      <div className="mt-4 flex justify-center space-x-4">
        <button
          onClick={handlePreviousPage}
          disabled={currentPage === 1}
          className="px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          上一页
        </button>
        <button
          onClick={handleNextPage}
          disabled={currentPage === totalPages}
          className="px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          下一页
        </button>
      </div>
    </div>
  );
};

export default ReaderPage;
