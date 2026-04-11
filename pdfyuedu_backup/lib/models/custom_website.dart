class CustomWebsite {
  String id;
  String name;
  String url;
  String category;
  String searchPattern;
  String downloadPattern;
  bool isEnabled;

  CustomWebsite({
    required this.id,
    required this.name,
    required this.url,
    this.category = '',
    this.searchPattern = '',
    this.downloadPattern = '',
    this.isEnabled = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'category': category,
      'searchPattern': searchPattern,
      'downloadPattern': downloadPattern,
      'isEnabled': isEnabled ? 1 : 0,
    };
  }

  factory CustomWebsite.fromMap(Map<String, dynamic> map) {
    return CustomWebsite(
      id: map['id'],
      name: map['name'],
      url: map['url'],
      category: map['category'],
      searchPattern: map['searchPattern'],
      downloadPattern: map['downloadPattern'],
      isEnabled: map['isEnabled'] == 1,
    );
  }
}
