
import 'package:hive/hive.dart';
import 'dart:convert';
 part 'user_models.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0) String name;
  @HiveField(1) String id;
  @HiveField(2) String atype;
  @HiveField(3) int? age;
  @HiveField(4) String? gender;

    User({
        required this.name,
        required this.id,
        required this.atype,
        this.age,
        this.gender
    });

  

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        id: json["id"],
        atype: json["atype"],
    );
}


List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));
class Welcome {
    Welcome({
        required this.users,
    });

    List<User> users;

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    );

    
}




