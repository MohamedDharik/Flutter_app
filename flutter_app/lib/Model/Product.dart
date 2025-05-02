class Product {
  final String id;
  final String title;
  final String description;
  final String price;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        id: json['_id'].toString(),
        title: json['ProductName'] ?? json['title'] ?? 'No title',
        description:
            json['Description'] ?? json['description'] ?? 'No description',
        price: (json['Price'] ?? json['price'] ?? '0').toString(),
      );
    } catch (e) {
      throw FormatException("Invalid product format: $e");
    }
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'price': price,
  };
}
