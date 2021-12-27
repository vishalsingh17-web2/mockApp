import 'package:flutter/material.dart';

import 'models/user_models.dart';

class Details extends StatelessWidget {
  User user;
  Details({ Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: ListTile(
          title: Text(user.name),
          subtitle: Text(user.atype),
          leading: Text(user.id.toString()),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Age: '+ user.age.toString()),
              Text('Gender: '+ user.gender.toString())
            ],
          ),
        ),
      )
    );
  }
}