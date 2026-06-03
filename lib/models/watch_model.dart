class WatchModel {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String description;
  final List<String> images;
  final String category;
  final Map<String, String> specifications;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final String sellerName;
  final String sellerInfo;

  WatchModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.description,
    required this.images,
    required this.category,
    required this.specifications,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
    required this.sellerName,
    required this.sellerInfo,
  });

  WatchModel copyWith({
    String? id,
    String? name,
    String? brand,
    double? price,
    String? description,
    List<String>? images,
    String? category,
    Map<String, String>? specifications,
    double? rating,
    int? reviewCount,
    bool? inStock,
    String? sellerName,
    String? sellerInfo,
  }) {
    return WatchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      description: description ?? this.description,
      images: images ?? this.images,
      category: category ?? this.category,
      specifications: specifications ?? this.specifications,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      inStock: inStock ?? this.inStock,
      sellerName: sellerName ?? this.sellerName,
      sellerInfo: sellerInfo ?? this.sellerInfo,
    );
  }
}