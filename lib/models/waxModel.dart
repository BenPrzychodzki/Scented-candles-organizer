import 'dart:convert';

WaxModel waxFromJson(String str) => WaxModel.fromJson(json.decode(str));
String waxToJson(WaxModel data) => json.encode(data.toJson());



class WaxModel {
  int id;
  String propType;
  String name;
  String brand;
  String description;
  int power;
  int rating;
  int amount;
  int color;

  WaxModel({this.id, this.propType, this.name, this.brand, this.description,
    this.power, this.rating, this.amount, this.color});

  factory WaxModel.fromJson(Map<String, dynamic> json) => new WaxModel(
    id: json['id'],
    propType: json['propType'],
    name: json['name'],
    brand: json['brand'],
    description: json['description'],
    power: json['power'],
    rating: json['rating'],
    amount: json['amount'],
    color: json['color'],
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propType': propType,
      'name': name,
      'brand': brand,
      'description': description,
      'power': power,
      'rating': rating,
      'amount': amount,
      'color': color,
    };
  }
}