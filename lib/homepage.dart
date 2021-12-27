import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mock/models/boxes.dart';
import 'details.dart';
import 'models/user_models.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> readJson() async {
    List<User> _items = [];
    final String response = await rootBundle.loadString('assets/users.json');
    List<Welcome> welcome = welcomeFromJson(response);
    _items = welcome[0].users;
    if (Boxes.getUserBox().isEmpty) {
      for (int i = 0; i < _items.length; i++) {
        Boxes.getUserBox().put(_items[i].id, _items[i]);
      }
    }
  }

  @override
  void initState() {
    readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Box<User>>(
        valueListenable: Boxes.getUserBox().listenable(),
        builder: (context, Box<User> box, _) {
          var items = box.values.toList().cast<User>();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index].name),
                  subtitle: Text(items[index].atype),
                  onTap: () {
                    items[index].age != null
                        ? Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Details(
                                user: items[index],
                              ),
                            ),
                          )
                        : null;
                  },
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      primary: items[index].age == null
                          ? Colors.deepOrange.shade200
                          : Colors.green.shade200,
                    ),
                    onPressed: () {
                      items[index].age != null
                          ? Boxes.getUserBox().put(
                              items[index].id,
                              User(
                                name: items[index].name,
                                id: items[index].id,
                                atype: items[index].atype,
                                age: null,
                                gender: null,
                              ),
                            )
                          : _showMyDialog(items[index]);
                    },
                    child: Text(
                      items[index].age == null ? 'Sign In' : 'Sign Out',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _showMyDialog(User user) async {
    TextEditingController _ageController = TextEditingController();
    String dropdownValue = 'Male';
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Fill the form to Sign In'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Gender"),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        underline: Container(
                          height: 2,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['Male', 'Female', 'Others']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  child: const Text('Regiser'),
                  onPressed: () {
                    if (int.parse(_ageController.text) > 0) {
                      User storeUser = User(
                          name: user.name,
                          age: int.parse(_ageController.text),
                          atype: user.atype,
                          id: user.id,
                          gender: dropdownValue);
                      Boxes.getUserBox().put(storeUser.id, storeUser);
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => Details(user: storeUser),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
