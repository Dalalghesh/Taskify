import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class received_inviations extends StatelessWidget {
  //const received_inviations({ Key? key }) : super(key: key);
    final _firestore = FirebaseFirestore.instance;

void getCategory() async{
  final Categorys = await _firestore.collection('Category').get();
  for (var Category in  Categorys.docs){
 print(Category.data());
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        leadingWidth: 50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
         ),
         body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text('Received Invitation',
               style: Theme.of(context).textTheme.headline4,
               ),
                  SizedBox(
              height: 16,
            ),
            ],
           
          )

         ),
    );
  }
}



