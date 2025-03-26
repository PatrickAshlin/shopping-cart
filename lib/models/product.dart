class Product {
  final int id;
  final String title;
  final double price;
  final double discountPercentage;
  final String thumbnail;
  int quantity; // New field

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.discountPercentage,
    required this.thumbnail,
    this.quantity = 1, // Default quantity to 1
  });

  double get discountedPrice => (price - (price * (discountPercentage / 100))) * quantity;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      thumbnail: json['thumbnail'],
      quantity: 1, // Default when fetched
    );
  }
}
