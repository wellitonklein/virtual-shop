class SectionItem {
  dynamic image;
  String productId;

  SectionItem({this.image, this.productId});

  SectionItem.fromMap(Map<String, dynamic> item) {
    image = item['image'] as String;
    productId = item['product_id'] as String;
  }

  SectionItem clone() {
    return SectionItem(
      image: image,
      productId: productId,
    );
  }

  Map<String, dynamic> toMap() => {
        'image': image,
        'product_id': productId,
      };

  @override
  String toString() {
    return 'SectionItem{productId: $productId, image: $image}';
  }
}
