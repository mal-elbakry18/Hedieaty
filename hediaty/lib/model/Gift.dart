class Gift {
  int? id;
  String name;
  String? description;
  String? category;
  double? price;
  String? image; // File path or base64-encoded string

  Gift({
    this.id,
    required this.name,
    this.description,
    this.category,
    this.price,
    this.image,
  });

  // Convert a Gift object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'image': image,
    };
  }

  // Create a Gift object from a Map
  factory Gift.fromMap(Map<String, dynamic> map) {
    return Gift(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      price: map['price'],
      image: map['image'],
    );
  }
}
