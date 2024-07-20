




class ProductModal{
  final int? productId;
  final int? categoryId;
  final String? categoryName;
  final String? productName;
  final double? productPrice;
  final String? productDescription;
  final String? imagePath;

  ProductModal({required this.productId,required this.categoryId,required this.categoryName,required this.productName,required
  this.productPrice,required this.productDescription,required this.imagePath});

  factory ProductModal.fromJson(Map<String, dynamic> json) {
    return ProductModal(
      productId: json["pId"],
      categoryId: json["catId"],
      categoryName: json["catName"],
      productName: json["pName"],
      productPrice: json["pPrice"]?.toDouble(), // Convert to double, handle null with a default value
      productDescription: json["pDesc"],
      imagePath: json["image_path"]
    );
  }

}