class Cart {
  late final int? id;
  final String? productId;
  final String? productName;
  final int? initialPrice;
  final int? productPrice;
  final int? quantity;
  final String? unitTag;
  final String? image;

  Cart({
    required this.id, // Dùng 'required' để yêu cầu giá trị khi khởi tạo
    required this.productId,
    required this.productName,
    required this.initialPrice,
    required this.productPrice,
    required this.quantity,
    required this.unitTag,
    required this.image,
  });

  Cart.fromMap(Map<dynamic, dynamic> res)
      : id = res["id"],
        productId = res["productId"] as String?,
        productName = res["productName"] as String?,
        initialPrice = res["initialPrice"] as int?,
        productPrice = res["productPrice"] as int?,
        quantity = res["quantity"] as int?,
        unitTag = res["unitTag"] as String?,
        image = res["image"] as String?;

  // (Tùy chọn) Chuyển đổi đối tượng về Map
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'initialPrice': initialPrice,
      'productPrice': productPrice,
      'quantity': quantity,
      'unitTag': unitTag,
      'image': image,
    };
  }
}
