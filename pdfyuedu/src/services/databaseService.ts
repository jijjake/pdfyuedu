import Dexie from 'dexie';
import type { Book, CloudStorageAccount } from '../types';

class BookLibraryDatabase extends Dexie {
  books!: Dexie.Table<Book, string>;
  cloudStorageAccounts!: Dexie.Table<CloudStorageAccount, string>;

  constructor() {
    super('BookLibraryDatabase');
    this.version(1).stores({
      books: 'id, title, author, publisher, isbn, coverUrl, description, filePath, cloudPath, categories, tags, readingProgress, isFavorite, addedAt, lastReadAt',
      cloudStorageAccounts: 'id, type, name, url, username, password, rootPath, isEnabled, lastSyncAt'
    });
  }
}

export const db = new BookLibraryDatabase();

// 书籍相关操作
export const bookService = {
  async addBook(book: Book): Promise<void> {
    await db.books.add(book);
  },

  async getAllBooks(): Promise<Book[]> {
    return await db.books.toArray();
  },

  async getBookById(id: string): Promise<Book | undefined> {
    return await db.books.get(id);
  },

  async updateBook(book: Book): Promise<void> {
    await db.books.put(book);
  },

  async deleteBook(id: string): Promise<void> {
    await db.books.delete(id);
  },

  async searchBooks(query: string): Promise<Book[]> {
    const lowerQuery = query.toLowerCase();
    return await db.books.filter(book => 
      book.title.toLowerCase().includes(lowerQuery) ||
      book.author.toLowerCase().includes(lowerQuery) ||
      book.isbn.includes(query)
    ).toArray();
  }
};

// 云存储账户相关操作
export const cloudStorageService = {
  async addAccount(account: CloudStorageAccount): Promise<void> {
    await db.cloudStorageAccounts.add(account);
  },

  async getAllAccounts(): Promise<CloudStorageAccount[]> {
    return await db.cloudStorageAccounts.toArray();
  },

  async getAccountById(id: string): Promise<CloudStorageAccount | undefined> {
    return await db.cloudStorageAccounts.get(id);
  },

  async updateAccount(account: CloudStorageAccount): Promise<void> {
    await db.cloudStorageAccounts.put(account);
  },

  async deleteAccount(id: string): Promise<void> {
    await db.cloudStorageAccounts.delete(id);
  }
};
