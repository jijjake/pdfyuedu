// 书籍模型
export interface Book {
  id: string;
  title: string;
  author: string;
  publisher: string;
  isbn: string;
  coverUrl: string;
  description: string;
  filePath: string; // 本地存储路径
  cloudPath: string; // 云存储路径
  categories: string[];
  tags: string[];
  readingProgress: number;
  isFavorite: boolean;
  addedAt: Date;
  lastReadAt: Date;
}

// 云存储账户模型
export interface CloudStorageAccount {
  id: string;
  type: string; // WebDAV等
  name: string;
  url: string;
  username: string;
  password: string; // 加密存储
  rootPath: string;
  isEnabled: boolean;
  lastSyncAt: Date;
}

// 文件信息模型
export interface FileInfo {
  name: string;
  path: string;
  isDirectory: boolean;
  size: number;
  lastModified: Date;
}
