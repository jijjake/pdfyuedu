import axios from 'axios';
import type { Book } from '../types';

export class BookInfoService {
  async getBookInfoByISBN(isbn: string): Promise<Partial<Book>> {
    try {
      // 使用 Open Library API 获取书籍信息
      const response = await axios.get(`https://openlibrary.org/api/books?bibkeys=ISBN:${isbn}&format=json&jscmd=data`);
      const bookData = response.data[`ISBN:${isbn}`];

      if (bookData) {
        return {
          title: bookData.title || '',
          author: bookData.authors?.map((author: any) => author.name).join(', ') || '',
          publisher: bookData.publishers?.map((publisher: any) => publisher.name).join(', ') || '',
          description: bookData.subtitle || '',
          coverUrl: bookData.cover?.medium || ''
        };
      }
    } catch (error) {
      console.error('通过ISBN获取书籍信息失败:', error);
    }

    // 返回默认值
    return {};
  }

  async getBookInfoByTitle(title: string): Promise<Partial<Book>> {
    try {
      // 使用 Open Library API 搜索书籍
      const response = await axios.get(`https://openlibrary.org/search.json?q=${encodeURIComponent(title)}&limit=1`);
      const bookData = response.data.docs?.[0];

      if (bookData) {
        return {
          title: bookData.title || '',
          author: bookData.author_name?.join(', ') || '',
          publisher: bookData.publisher?.join(', ') || '',
          isbn: bookData.isbn?.[0] || '',
          description: bookData.subtitle || '',
          coverUrl: bookData.cover_i ? `https://covers.openlibrary.org/b/id/${bookData.cover_i}-M.jpg` : ''
        };
      }
    } catch (error) {
      console.error('通过标题获取书籍信息失败:', error);
    }

    // 返回默认值
    return {};
  }

  async enrichBookInfo(book: Book): Promise<Book> {
    let enrichedData: Partial<Book> = {};

    if (book.isbn) {
      enrichedData = await this.getBookInfoByISBN(book.isbn);
    } else if (book.title) {
      enrichedData = await this.getBookInfoByTitle(book.title);
    }

    return {
      ...book,
      ...enrichedData
    };
  }
}

export const bookInfoService = new BookInfoService();
