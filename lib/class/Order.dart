import 'package:ordy/class/Plate.dart';

/// Class representing an order: table booking + Plate + bill
class Order {

  late final List<Plate> homeMenus;

  late final List<Plate> starters;

  late final List<Plate> firstCourses;

  late final List<Plate> secondCourses;

  late final List<Plate> sideDishes;

  late final List<Plate> drinks;

  late final List<Plate> desserts;

  final List<Plate> allPlates = [];

  double bill = 0;
  String tableName = "";
  String booking = "";

  Order(this.tableName, this.homeMenus, this.starters, this.firstCourses,
      this.secondCourses, this.sideDishes, this.drinks, this.desserts) {
    allPlates.addAll(homeMenus);
    allPlates.addAll(this.starters);
    allPlates.addAll(this.firstCourses);
    allPlates.addAll(this.secondCourses);
    allPlates.addAll(this.sideDishes);
    allPlates.addAll(this.drinks);
    allPlates.addAll(this.desserts);
  }

  Order.fromJson(Map<String, dynamic> json) {
    homeMenus = [];
    starters = [];
    firstCourses = [];
    secondCourses = [];
    sideDishes = [];
    drinks = [];
    desserts = [];
    tableName = json['tableName'];
    booking = json['booking'];
    bill = json['bill'];

    for (var menu in json['menus']) {
      homeMenus.add(Plate.fromJson(menu));
    }
    for (var starter in json['starters']) {
      starters.add(Plate.fromJson(starter));
    }
    for (var firstCourse in json['firstCourses']) {
      firstCourses.add(Plate.fromJson(firstCourse));
    }
    for (var secondCourse in json['secondCourses']) {
      secondCourses.add(Plate.fromJson(secondCourse));
    }
    for (var sideDish in json['sideDishes']) {
      sideDishes.add(Plate.fromJson(sideDish));
    }
    for (var drink in json['drinks']) {
      drinks.add(Plate.fromJson(drink));
    }
    for (var dessert in json['desserts']) {
      drinks.add(Plate.fromJson(dessert));
    }
    allPlates.addAll(this.homeMenus);
    allPlates.addAll(this.starters);
    allPlates.addAll(this.firstCourses);
    allPlates.addAll(this.secondCourses);
    allPlates.addAll(this.sideDishes);
    allPlates.addAll(this.drinks);
    allPlates.addAll(this.desserts);
  }

  Map<String, dynamic> toJson() {
    return {
      'tableName': tableName,
      'booking': booking,
      'bill': bill,
      'menus': homeMenus,
      'starters': starters,
      'firstCourses': firstCourses,
      'secondCourses': secondCourses,
      'sideDishes': sideDishes,
      'drinks': drinks,
      'desserts': desserts,
    };
  }
}