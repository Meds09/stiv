import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
final user = FirebaseAuth.instance.currentUser!;

//sign out user
  void signUserOut ()async {
  await FirebaseAuth.instance.signOut();
}

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout)),
          
        ],
      ),
      body: Center(
        child: Text('¡Bienvenido ${user.email}!'),
      ),
    );
  }
}

