import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google/navigationbar_screen.dart';
import 'package:google/Login/join_screen.dart';
import 'package:google/Login/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class choice extends StatefulWidget {
  @override
  _choice createState() => _choice();
}

class _choice extends State<choice> {

  Future result_uid() async {
    FirebaseFirestore.instance.collection('user')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: /*FirebaseFirestore.instance.collection('user')
              .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
              .snapshots(),*/
          FirebaseFirestore.instance.collection('user')
              .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
              .get(),
          builder: (BuildContext context, snapshot) {

            var item = snapshot.data?.docs ?? [];

            if (snapshot.hasData && item.length < 1) {
              return join_screen();
            } else if (snapshot.hasData && item.length >= 1) {
              return navigationbar_screen();
            } else {
              return loading();
            }
          },
        )
    );
  }

}