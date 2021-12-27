import 'package:hive_flutter/hive_flutter.dart';
import 'package:mock/models/user_models.dart';

class Boxes{
  static init()async{
    Hive.registerAdapter(UserAdapter());
    await Hive.openBox<User>('User');
  }
  static const String _user = 'User';
  static Box<User> getUserBox() => Hive.box<User>(_user);
}