/// Class representing a plate: name + price

class Plate {
  final String name;
  final double price;
  int quantity = 0;
  // quantity * price
  double bill = 0;

  Plate(this.name, this.price);

  Plate.fromJson(Map<String, dynamic> json):
      name = json['name'],
      price = json['price'],
      quantity = json['quantity'],
      bill = json['bill'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'bill': bill
    };
  }
}
