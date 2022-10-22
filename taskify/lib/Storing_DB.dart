import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../../firebase_options.dart';

addPhoto(File img, String ID) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform
      );
  String fileName = basename(img.path);

  //uploadImageToFirebase
  FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;

  Reference ref = firebaseStorageRef.ref().child('images/$fileName');
  UploadTask uploadTask = ref.putFile(img);

  final TaskSnapshot downloadUrl = (await uploadTask);

  final String url = await downloadUrl.ref.getDownloadURL();

  FirebaseFirestore.instance.collection('users1').doc(ID).update({
    "photo": url,
  });
}

@override
void initState() {
  initState();
}

/////Future getTags(String cat) async {
// }
//}