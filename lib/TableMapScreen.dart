import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ordy/OrderScreen.dart';
import 'package:ordy/class/Plate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'class/Order.dart';
import 'class/Plate.dart';

class TableMapScreen extends StatefulWidget {
  final SharedPreferences? prefs;

  const TableMapScreen({Key? key, required this.prefs}) : super(key: key);

  @override
  _TableMapScreenState createState() => _TableMapScreenState();
}

class _TableMapScreenState extends State<TableMapScreen> with WidgetsBindingObserver {
  var _width;

  // List containing all table orders
  final List<Order> _orders = [];

  /// Fill initial orders value (default values)
  _addTable(String name) {
    final List<Plate> homeMenus = [Plate("Menù della casa", 35)];

    final List<Plate> starters = [
      Plate("Antipasti misti", 13),
    ];

    final List<Plate> firstCourses = [
      Plate("Tagliolini pesto, patate e fagiolini", 8),
      Plate("Tagliatelle al sugo di carne", 8),
    ];

    final List<Plate> secondCourses = [
      Plate("Bistecca di manzo", 45),
      Plate("Spezzatino di vitella e barbe", 10),
      Plate("Polletto alla brace", 8),
      Plate("Coniglio fritto", 13),
      Plate("Grigliata mista di carni", 15),
    ];

    final List<Plate> sideDishes = [
      Plate("Contorni", 4)
    ];

    final List<Plate> desserts = [
      Plate("Cheescake", 5),
      Plate("Tiramisù", 5),
    ];

    final List<Plate> drinks = [
      Plate("Acqua", 1.5),
      Plate("Vino bianco/rosso", 8),
      Plate("Bibita piccola", 2),
      Plate("Bibita 1L", 5),
      Plate("Birra 1L", 5),
      Plate("Caffè", 1),
      Plate("Liquore", 3),
    ];

    _orders.add(Order(
        name,
        homeMenus,
        starters,
        firstCourses,
        secondCourses,
        sideDishes,
        drinks,
        desserts));
  }

  /// Build gridview (map of table)
  _buildTable(Order order, String assetName) {
    return InkWell(
        onTap: () async {
          final toRemove = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderScreen(order: order)
            ),
          );
          setState(() => {
            if (toRemove != null) {
              if (toRemove) {
                _orders.remove(order)
              }
            }
          });
        },
        child: Card(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                    children: [
                      Image.asset("images/$assetName", height: 70),
                      Text("${order.tableName}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ))
                    ]),
                ExpansionTile(
                  tilePadding: EdgeInsets.only(left: 4, right: 4),
                  title: order.booking == "" ? Text("${order.tableName}") : Text("${order.booking}"),
                  subtitle: Text("${order.bill} €"),
                  children: [
                    if (order.bill > 0)
                      for (var plate in order.allPlates)
                        if (plate.bill != 0)
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 8),
                            title: Text("${plate.name} x${plate.quantity}",
                              style: TextStyle(fontSize: 15),),
                            subtitle: Text("${plate.quantity * plate.price} €"),
                          )
                  ],
                )
              ],
            )
        )
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    bool? firstAccess = widget.prefs!.getBool("firstAccess");
    String? stringOrders = widget.prefs!.getString("orders");
    // empty on the first access
    if (firstAccess == null) {
      widget.prefs!.setString("orders", jsonEncode(_orders));
      widget.prefs!.setBool("firstAccess", true);
    } else {
      for (var order in jsonDecode(stringOrders!)) {
        _orders.add(Order.fromJson(order));
      }
    }
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      widget.prefs!.setString("orders", jsonEncode(_orders));
    }
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
        appBar: AppBar(
            title: Text("Tavoli")
        ),
        body: ListView(
            children: [
              for (int i = 0; i < _orders.length; i += 3)
                _buildRow(i,  i + 3),
            ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _addTable("Tavolo ${_orders.length + 1}");
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  /// Build the lines of layout
  Row _buildRow(int start, int end) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = start; i < end; i++)
            if (i < _orders.length)
              SizedBox(
                width: _width / 3,
                child: _buildTable(
                    _orders[i], "wood.jpg"),
              ),
        ]);
  }
}
