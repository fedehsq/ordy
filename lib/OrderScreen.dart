
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ordy/class/PrintScreen.dart';

import 'class/Order.dart';
import 'class/Plate.dart';


class OrderScreen extends StatefulWidget {
  final Order order;

  const OrderScreen({Key? key, required this.order})
      : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late final bookingController;
  bool showModBar = false;
  late Plate selectedPlate;

  /// Build the plates view
  _buildPlateView(Plate p) {
    return ListTile(
      tileColor: showModBar && selectedPlate == p ? Colors.black12 : null,
      onTap: () => setState(() {
        showModBar = false;
      }),
      onLongPress: () {
        setState(() {
          showModBar = !showModBar;
          selectedPlate = p;
        });

      },
      title: Text(p.name),
      subtitle: p.name.contains("Bistecca") ? Text("${p.bill}€ al kg")
          : Text("${p.bill}€"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${p.quantity}"),
          IconButton(onPressed: () {
            setState(() {
              p.quantity++;
              p.bill += p.price;
              widget.order.bill += p.price;
            });
          }, icon: Icon(Icons.add_circle, color: Colors.green)
          ),
          IconButton(onPressed: () {
            setState(() {
              if (p.quantity > 0) {
                p.quantity--;
                p.bill -= p.price;
                widget.order.bill -= p.price;
              }
            });
          }, icon: Icon(Icons.remove_circle, color: Colors.red)
          )
        ],
      ),
    );
  }

  int count(List<Plate> plates) {
    int count = 0;
    for (var plate in plates) {
      count += plate.quantity;
    }
    return count;
  }

  @override
  void initState() {
    bookingController = TextEditingController(text: widget.order.booking);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int menus = count(widget.order.homeMenus);
    int starters = count(widget.order.starters);
    int firsts = count(widget.order.firstCourses);
    int seconds = count(widget.order.secondCourses);
    int sideDishes = count(widget.order.sideDishes);
    int drinks = count(widget.order.drinks);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.order.tableName}"),
        actions: [
          if (showModBar)
            IconButton(
                onPressed: () async {
                  await _buildModPlateDialog(selectedPlate);
                  setState(() {
                  });
                },
                icon: Icon(Icons.edit)),
          if (showModBar)
            IconButton(
                onPressed: () {
                  setState(() {
                    widget.order.bill -= selectedPlate.bill;
                    widget.order.firstCourses.remove(selectedPlate);
                    widget.order.secondCourses.remove(selectedPlate);
                    widget.order.desserts.remove(selectedPlate);
                    widget.order.sideDishes.remove(selectedPlate);
                    widget.order.drinks.remove(selectedPlate);
                    widget.order.starters.remove(selectedPlate);
                    widget.order.allPlates.remove(selectedPlate);
                    showModBar = false;
                  });
                },
                icon: Icon(Icons.delete)),
          if (!showModBar)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(child: Text("${widget.order.bill} €",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
              )),
            ),
          if (!showModBar)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: PopupMenuButton(
                  child: Icon(Icons.more_vert),
                  onSelected: (index) async {
                    if (index == 0) {
                      await _buildNameDialog();
                      setState(() {
                      });
                    }
                    if (index == 1) {
                      Navigator.pop(context, true);
                    }
                    if (index == 2) {
                      await _buildPlateDialog();
                      setState(() {
                      });
                    }
                  },
                  itemBuilder: (context) {
                    return List.generate(3, (index) {
                      switch (index) {
                        case 0 :
                          return PopupMenuItem(
                            value: index,
                            child: Text('Modifica nome'),
                          );
                        case 1 :
                          return PopupMenuItem(
                            value: index,
                            child: Text('Elimina tavolo'),
                          );
                        default:
                          return PopupMenuItem(
                              value: index,
                              child: Text("Aggiungi piatto"));
                      }
                    });
                  }),
            )
        ],
      ),
      body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) => widget.order.booking = value,
                controller: bookingController,
                decoration: InputDecoration(
                    labelText: 'Prenotazione'
                ),
              ),
            ),
            ExpansionTile(
                title: menus == 0
                    ? Text("Menù della casa") : Text("Menù della casa x$menus"),
                leading: Icon(Icons.menu_book),
                children: [
                  for (var p in widget.order.homeMenus)
                    _buildPlateView(p)
                ]),
            ExpansionTile(
                title: starters == 0 ? Text("Antipasti") : Text(
                    "Antipasti x$starters"),
                leading: Icon(Icons.tapas),
                children: [
                  for (var p in widget.order.starters)
                    _buildPlateView(p),
                  if (widget.order.starters.isEmpty)
                    ListTile(
                        title: Text("Aggiungi piatto"),
                      onTap: () async {
                        await _buildPlateDialog();
                        setState(() {
                        });
                      }
                    )
                ]
            ),
            ExpansionTile(
                title: firsts == 0 ? Text("Primi piatti") : Text(
                    "Primi piatti x$firsts"),
                leading: Icon(Icons.dinner_dining),
                children: [
                  for (var p in widget.order.firstCourses)
                    _buildPlateView(p)
                ]),
            ExpansionTile(
                title: seconds == 0 ? Text("Secondi piatti") : Text(
                    "Secondi piatti x$seconds"),
                leading: Icon(Icons.set_meal),
                children: [
                  for (var p in widget.order.secondCourses)
                    _buildPlateView(p)
                ]),
            ExpansionTile(
                title: sideDishes == 0 ? Text("Contorni") : Text(
                    "Contorni x$sideDishes"),
                leading: Icon(Icons.rice_bowl),
                children: [
                  for (var p in widget.order.sideDishes)
                    _buildPlateView(p)
                ]),
            ExpansionTile(
                title: Text("Dolci"),
                leading: Icon(Icons.cake),
                children: []),
            ExpansionTile(
                title: drinks == 0 ? Text("Bibite") : Text("Bibite x$drinks"),
                leading: Icon(Icons.local_bar),
                children: [
                  for (var p in widget.order.drinks)
                    _buildPlateView(p)
                ]),

          ]),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PrintScreen(order: widget.order)
          ),
        );
      },
        child: Icon(Icons.print),),
    );
  }

  Future<void> _buildPlateDialog() async {
    int _value = 1;
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          TextEditingController name = TextEditingController();
          TextEditingController price = TextEditingController();
          return StatefulBuilder(
              builder: (context, setState) {
                return SimpleDialog(
                  title: Text('Aggiungi piatto'),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                          });
                        },
                        controller: name,
                        decoration: InputDecoration(
                            errorText: name.text.isEmpty ? "Richiesto" : null,
                            labelText: 'Nome'
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                          });
                        },
                        controller: price,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            errorText: price.text.isEmpty ? "Richiesto" : null,
                            labelText: 'Prezzo'
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: DropdownButton(
                          value: _value,
                          items: [
                            DropdownMenuItem(
                              child: Text("Menù della casa"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Antipasto"),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text("Primo piatto"),
                              value: 3,
                            ),
                            DropdownMenuItem(
                                child: Text("Secondo piatto"),
                                value: 4
                            ),
                            DropdownMenuItem(
                                child: Text("Dolce"),
                                value: 5
                            ),
                            DropdownMenuItem(
                                child: Text("Contorno"),
                                value: 6
                            ),
                            DropdownMenuItem(
                                child: Text("Bibita"),
                                value: 7
                            )
                          ],
                          onChanged: (v) {
                            setState(() {
                              _value = v as int;
                            });
                          }),
                    ),
                    TextButton(
                        onPressed: () {
                          if (name.text.isNotEmpty && price.text.isNotEmpty) {
                            widget.order.allPlates.add(Plate(
                                name.text, double.parse(price.text)));
                            switch (_value) {
                              case 1 :
                                widget.order.homeMenus.add(Plate(
                                    name.text, double.parse(price.text)));
                                break;
                              case 2 :
                                widget.order.starters.add(Plate(
                                    name.text, double.parse(price.text)));
                                break;
                              case 3 :
                                widget.order.firstCourses.add(Plate(
                                    name.text, double.parse(price.text)));
                                break;
                              case 4 :
                                widget.order.secondCourses.add(Plate(
                                    name.text, double.parse(price.text)));
                                break;
                              case 5 :
                                widget.order.desserts.add(Plate(
                                    name.text, double.parse(price.text)));
                                break;
                              case 6 :
                                widget.order.sideDishes.add(Plate(
                                    name.text, double.parse(price.text)));
                                break;
                              case 7 :
                                widget.order.drinks.add(Plate(
                                    name.text, double.parse(price.text)));
                                break;
                            }
                            Navigator.pop(context);
                          } else {
                            final snackBar = SnackBar(content: Text('Hai dimenticato qualcosa...'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        child: Text("Aggiungi"))
                  ],
                );
              }
          );
        });
  }

  Future<void> _buildModPlateDialog(Plate plate) async {
    int _value = 1;
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          TextEditingController name = TextEditingController(text: plate.name);
          TextEditingController price = TextEditingController(text: plate.price.toString());
          return StatefulBuilder(
              builder: (context, setState) {
                return SimpleDialog(
                  title: Text('Modifica piatto'),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                          });
                        },
                        controller: name,
                        decoration: InputDecoration(
                            errorText: name.text.isEmpty ? "Richiesto" : null,
                            labelText: 'Nome'
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: TextField(
                        controller: price,
                        onChanged: (value) {
                          setState(() {
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            errorText: price.text.isEmpty ? "Richiesto" : null,
                            labelText: 'Prezzo'
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: DropdownButton(
                          value: _value,
                          items: [
                            DropdownMenuItem(
                              child: Text("Menù della casa"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Antipasto"),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text("Primo piatto"),
                              value: 3,
                            ),
                            DropdownMenuItem(
                                child: Text("Secondo piatto"),
                                value: 4
                            ),
                            DropdownMenuItem(
                                child: Text("Dolce"),
                                value: 5
                            ),
                            DropdownMenuItem(
                                child: Text("Contorno"),
                                value: 6
                            ),
                            DropdownMenuItem(
                                child: Text("Bibita"),
                                value: 7
                            )
                          ],
                          onChanged: (v) {
                            setState(() {
                              _value = v as int;
                            });
                          }),
                    ),
                    TextButton(
                        onPressed: () {
                          if (name.text.isNotEmpty && price.text.isNotEmpty) {
                            Plate p = Plate(name.text, double.parse(price.text));
                            switch (_value) {
                              case 1 :
                                widget.order.homeMenus.add(p);
                                break;
                              case 2 :
                                widget.order.starters.add(p);
                                break;
                              case 3 :
                                widget.order.firstCourses.add(p);
                                break;
                              case 4 :
                                widget.order.secondCourses.add(p);
                                break;
                              case 5 :
                                widget.order.desserts.add(p);
                                break;
                              case 6 :
                                widget.order.sideDishes.add(p);
                                break;
                              case 7 :
                                widget.order.drinks.add(p);
                                break;
                            }
                            widget.order.bill -= plate.bill;
                            widget.order.homeMenus.remove(plate);
                            widget.order.firstCourses.remove(plate);
                            widget.order.secondCourses.remove(plate);
                            widget.order.desserts.remove(plate);
                            widget.order.sideDishes.remove(plate);
                            widget.order.drinks.remove(plate);
                            widget.order.starters.remove(plate);
                            widget.order.allPlates.remove(plate);
                            widget.order.allPlates.add(p);
                            showModBar = false;
                            Navigator.pop(context);
                          } else {
                            final snackBar = SnackBar(content: Text('Hai dimenticato qualcosa...'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        child: Text("Modifica"))
                  ],
                );
              }
          );
        });
  }

  Future<void> _buildNameDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          TextEditingController name = TextEditingController();
          return StatefulBuilder(
              builder: (context, setState) {
                return SimpleDialog(
                  title: const Text('Nome tavolo'),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                          });
                        },
                        controller: name,
                        decoration: InputDecoration(
                            errorText: name.text.isEmpty ? "Richiesto" : null,
                            labelText: 'Nome'
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          if (name.text.isNotEmpty) {
                            widget.order.tableName = name.text;
                            Navigator.pop(context);
                          } else {
                            final snackBar = SnackBar(content: Text('Hai dimenticato qualcosa...'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        child: Text("Conferma"))
                  ],
                );
              }
          );
        });
  }
}