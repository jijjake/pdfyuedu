import * as pdfjsLib from 'pdfjs-dist';
import type { Book } from '../types';
import { bookService } from './databaseService';

// 设置PDF.js的worker路径
pdfjsLib.GlobalWorkerOptions.workerSrc = `//cdnjs.cloudflare.com/ajax/libs/pdf.js/${pdfjsLib.version}/pdf.worker.min.js`;

export class ReaderService {
  private pdfDocument: pdfjsLib.PDFDocumentProxy | null = null;

  async loadPDF(filePath: string): Promise<pdfjsLib.PDFDocumentProxy> {
    try {
      // 从本地文件加载PDF
      const file = await fetch(filePath);
      const arrayBuffer = await file.arrayBuffer();
      
      this.pdfDocument = await pdfjsLib.getDocument({
        data: arrayBuffer,
      }).promise;

      return this.pdfDocument;
    } catch (error) {
      console.error('加载PDF失败:', error);
      throw error;
    }
  }

  async getPage(pageNumber: number): Promise<pdfjsLib.PDFPageProxy> {
    if (!this.pdfDocument) {
      throw new Error('PDF文档未加载');
    }

    return await this.pdfDocument.getPage(pageNumber);
  }

  async getPageCount(): Promise<number> {
    if (!this.pdfDocument) {
      throw new Error('PDF文档未加载');
    }

    return this.pdfDocument.numPages;
  }

  async saveReadingProgress(book: Book, progress: number): Promise<void> {
    book.readingProgress = progress;
    book.lastReadAt = new Date();
    await bookService.updateBook(book);
  }

  dispose(): void {
    this.pdfDocument?.destroy();
    this.pdfDocument = null;
  }
}

export const readerService = new ReaderService();
