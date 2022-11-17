class Product {
  Product({required this.id, required this.name, required this.price});

  int id;
  String name;
  int price;
// {}는 받을수도 안받을수도 있어서 null 허용한다고 ? 붙여줌
// 변수 앞에 _ 붙이면 private

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      price: json["price"],
    );
  }
  // json 데이터를 map으로 변환해서 넣으면 object로 바꿔줌

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
      };
  // json으로 변환
}
