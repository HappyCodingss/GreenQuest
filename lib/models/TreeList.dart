class Tree {
  int? treeId;
  String title;
  String imageUrl;
  int price;

  Tree({
    this.treeId,
    required this.title,
    required this.imageUrl,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'treeId': treeId,
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory Tree.fromMap(Map<String, dynamic> map) {
    return Tree(
      treeId: map['treeId'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      price: map['price'],
    );
  }
}