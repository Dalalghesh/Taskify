import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taskify/Screens/sharedlistdetails.dart';
// import 'package:taskify/chat_group_users.dart';
import 'package:taskify/firebase_api.dart';
import 'package:taskify/models/chat_groups.dart';
import 'package:taskify/utils/app_colors.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chat_group_users.dart';

class SendMessagePage extends StatelessWidget {
  //final UserModel user;//

  final ChatGroups groups;
  final mainReference = FirebaseDatabase.instance.reference().child('Database');

  SendMessagePage({
    Key? key,
    required this.groups,
  }) : super(key: key);

  final RxBool isClickFloatingButton = false.obs;
  final TextEditingController _message = TextEditingController();
  XFile? _imageFileList;
  late File selectedImage;
  bool loading = false;
  String? imageUrl;
  dynamic _pickImageError;

  final ImagePicker _picker = ImagePicker();
  UploadTask? task;
  File? file;

  void _setImageFileListFromFile(XFile? value) async {
    String fileName = Uuid().v1();

    Map<String, dynamic> messages = {
      "sendby": FirebaseAuth.instance.currentUser!.uid,
      "message": 'uploading',
      "senderName": FirebaseAuth.instance.currentUser!.displayName,
      "type": 'image',
      "name": '',
      "time": DateTime.now().toString(),
    };

    //_message.clear();

    await FirebaseFirestore.instance
        .collection('chat-groups')
        .doc(groups.id)
        .collection('chats')
        .doc(fileName)
        .set(messages);

    _imageFileList = value;
    selectedImage = File(_imageFileList!.path);
    //BlocProvider.of<AuthCubit>(context).uploadServiceLicense(selectedImage);

    FirebaseStorage storage = FirebaseStorage.instance;
    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");
    // Reference ref = storage.ref().child("image${DateTime.now()}");
    UploadTask uploadTask = ref.putFile(selectedImage);
    uploadTask.then((res) async {
      imageUrl = await res.ref.getDownloadURL();

      //_message.clear();

      await FirebaseFirestore.instance
          .collection('chat-groups')
          .doc(groups.id)
          .collection('chats')
          .doc(fileName)
          .update({
        "message": imageUrl,
      });
      print('image link $_imageFileList');

      _imageFileList = null;
    });

    _launchURL(url) async {
      const url = 'https://flutter.dev/exapmle.pdf';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  void uploadFile(file) async {
    String fileName = Uuid().v1();

    Map<String, dynamic> messages = {
      "sendby": FirebaseAuth.instance.currentUser!.uid,
      "senderName": FirebaseAuth.instance.currentUser!.displayName,
      "message": 'uploading',
      "type": 'file',
      "name": '',
      "time": DateTime.now().toString(),
    };

    //_message.clear();

    await FirebaseFirestore.instance
        .collection('chat-groups')
        .doc(groups.id)
        .collection('chats')
        .doc(fileName)
        .set(messages);

    if (file == null) return;

    final fileNames = basename(file!.path);
    print(fileNames);
    final destination = 'files/$fileNames';

    task = FirebaseApi.uploadFile(destination, file!);
    // setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');

    await FirebaseFirestore.instance
        .collection('chat-groups')
        .doc(groups.id)
        .collection('chats')
        .doc(fileName)
        .update({
      "message": urlDownload,
      "name": fileNames,
    });
    print('image link $_imageFileList');

    _imageFileList = null;
    //  });
  }

  void getImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      print('picked file ===================' + pickedFile.toString());
      if (pickedFile != null) {
        print('yesssssssssssssssss====================================');
        // onSendMessage('uploading', 'image');

        _setImageFileListFromFile(pickedFile);
      }
    } catch (e) {
      _pickImageError = e;
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    file = File(path);

    uploadFile(file);
  }

  //SendNotification sendNotification = SendNotification();

  void onSendMessage(message, type) async {
    print(message);
    if (message.isNotEmpty) {
      Map<String, dynamic> messages = {
        "senderName": FirebaseAuth.instance.currentUser!.displayName,
        "sendby": FirebaseAuth.instance.currentUser!.uid,
        "message": message,
        "type": type,
        "name": '',
        "time": DateTime.now().toString(),
      };

      _message.clear();

      await FirebaseFirestore.instance
          .collection('chat-groups')
          .doc(groups.id)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  Future savePdf(List<int> asset, String name) async {
    Uint8List uint8List;
    String? url;
    uint8List = Uint8List.fromList(asset);
    var reference = FirebaseStorage.instance.ref().child(name);
    UploadTask uploadTask = reference.putData(uint8List);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() async {
      url = await reference.getDownloadURL();
    });
    print(url);

    documentFileUpload(url!);
    return url;
  }

  void documentFileUpload(String str) {
    var data = {
      "PDF": str,
    };
    mainReference.child("Documents").child('pdf').set(data).then((v) {});
  }

  launchUrlofDocument(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : '';
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Color(0xff7b39ed),
        elevation: 0.0,
        leadingWidth: 90,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        title: Text(
          groups.list,
          style: TextStyle(
              //fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 10, right: 16),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatGroupUsers(
                              category: groups.categorey, list: groups.list)
                          // ChatGroupUsers(chatGroups: groups)

                          ));
                },
                child: Icon(
                  Icons.group,
                  size: 24,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chat-groups')
                    .doc(groups.id)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    // print( '${snapshot.data!.docs.length} hello');
                    return Container(
                      //   margin: EdgeInsets.only(bottom: 80),
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            // width: MediaQuery
                            //     .of(context)
                            //     .size
                            //     .width,
                            // color: Colors.black,
                            alignment: snapshot.data!.docs[index]['sendby'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: snapshot.data!.docs[index]['type'] == 'text'
                                ? Column(
                                    crossAxisAlignment:
                                        snapshot.data!.docs[index]['sendby'] ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                    children: [
                                      snapshot.data!.docs[index]['sendby'] !=
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 14, top: 8),
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    ['senderName'],
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  //fontWeight: FontWeight.w500,
                                                  color:
                                                      snapshot.data!.docs[index]
                                                                  ['sendby'] ==
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid
                                                          ? Colors.black
                                                          : Colors.black,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 14),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: snapshot.data!.docs[index]
                                                        ['sendby'] ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? Color.fromARGB(
                                                    255, 133, 133, 133)
                                                : Color(0xff7b39ed)),
                                        child: Text(
                                          snapshot.data!.docs[index]['message'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: snapshot.data!.docs[index]
                                                        ['sendby'] ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? Colors.white
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : snapshot.data!.docs[index]['message'] ==
                                        'uploading'
                                    ? snapshot.data!.docs[index]['type'] ==
                                            'file'
                                        ? Container(
                                            height: 70,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.grey.shade300,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ))
                                        : Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.grey.shade300,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ))
                                    : snapshot.data!.docs[index]['type'] ==
                                            'file'
                                        ? GestureDetector(
                                            onTap: () {
                                              launchUrlofDocument(snapshot.data!
                                                  .docs[index]['message']);
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
                                              // color: Colors.deepPurple,

                                              decoration: BoxDecoration(
                                                color: Color(0xff7b39ed),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              margin: EdgeInsets.only(
                                                  right: 10, top: 10, left: 10),
                                              height: 70,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 10),
                                              alignment: Alignment.centerLeft,

                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.attach_file,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        ['name'],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              // Navigator.push(context, PageAnimationTransition(page:  ViewImageFull(image:snapshot
                                              //     .data!.docs[index]['message'],), pageAnimationType: RightToLeftTransition()));
                                            },
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 5),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['message']),
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                          ),
                          );
                        },
                      ),
                    );
                  }
                  return Container();
                }),
          ),
          Obx(
            () => isClickFloatingButton.value
                ? Container(
                    height: 140,
                    child: Center(
                      child: Text('No tasks added yet'),
                    )

                    // ListView.builder(
                    //   itemCount: 3,
                    //   scrollDirection: Axis.horizontal,
                    //   itemBuilder: (context, index) {
                    //     return Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Container(
                    //         width: 200,
                    //         height: 120,
                    //         decoration: BoxDecoration(
                    //             boxShadow: [
                    //               BoxShadow(
                    //                   color: Colors.black.withOpacity(0.1),
                    //                   spreadRadius: 2,
                    //                   blurRadius: 10)
                    //             ],
                    //             borderRadius: BorderRadius.circular(8),
                    //             image: const DecorationImage(
                    //                 fit: BoxFit.cover,
                    //                 image: const NetworkImage(
                    //                     "https://i.pinimg.com/736x/4c/26/dc/4c26dce84b66f7bb1f834c36411af3ed.jpg"))),
                    //       ),
                    //     );
                    //   },
                    // ),
                    //
                    )
                : Container(),
          ),
          Container(
            color: Colors.grey.shade300,
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // IconButton(
                  //   icon: Icon(Icons.emoji_emotions_outlined,
                  //       color: AppColors.darkGrey),
                  //   onPressed: () {
                  //     print('abc');
                  //     EmojiPicker(
                  //       onEmojiSelected: (category, emoji) {
                  //         // Do something when emoji is tapped (optional)
                  //       },
                  //       onBackspacePressed: () {
                  //         // Do something when the user taps the backspace button (optional)
                  //       },
                  //       textEditingController:
                  //           _message, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                  //       config: Config(
                  //         columns: 7,
                  //         emojiSizeMax: 32 *
                  //             (Platform.isIOS
                  //                 ? 1.30
                  //                 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                  //         verticalSpacing: 0,
                  //         horizontalSpacing: 0,
                  //         gridPadding: EdgeInsets.zero,
                  //         initCategory: Category.RECENT,
                  //         bgColor: Color(0xFFF2F2F2),
                  //         indicatorColor: Colors.blue,
                  //         iconColor: Colors.grey,
                  //         iconColorSelected: Colors.blue,
                  //         progressIndicatorColor: Colors.blue,
                  //         backspaceColor: Colors.blue,
                  //         skinToneDialogBgColor: Colors.white,
                  //         skinToneIndicatorColor: Colors.grey,
                  //         enableSkinTones: true,
                  //         showRecentsTab: true,
                  //         recentsLimit: 28,
                  //         noRecents: const Text(
                  //           'No Recents',
                  //           style:
                  //               TextStyle(fontSize: 20, color: Colors.black26),
                  //           textAlign: TextAlign.center,
                  //         ),
                  //         tabIndicatorAnimDuration: kTabScrollDuration,
                  //         categoryIcons: CategoryIcons(),
                  //         buttonMode: ButtonMode.MATERIAL,
                  //       ),
                  //     ); // emojiShowing.value = !emojiShowing.value;
                  //   },
                  // ),
                  IconButton(
                    onPressed: () {
                      getImage();
                    },
                    icon: Icon(
                      Icons.photo,
                      color: AppColors.deepPurple,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      selectFile();
                      // final path = await FlutterDocumentPicker.openDocument();
                      // print(path);
                      // File file = File(path);
                      //   getPdfAndUpload();
                      // final result = await FilePicker.platform.pickFiles();
                      // List<String>? files = result?.files
                      //     .map((file) => file.path)
                      //     .cast<String>()
                      //     .toList();
                      // if (files == null) {
                      //   return;
                      // }
                      // print(files);
                      // await Share.shareFiles(files);
                    },
                    icon: Icon(
                      Icons.attach_file,
                      color: Color(0xff7b39ed),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: TextFormField(
                        //  maxLines: 10,
                        minLines: 1,
                        maxLines: 15,
                        controller: _message,
                        // validator: (val){
                        //   sendMessageController.validateMessage(val.toString());
                        // },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 15, right: 15),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'Type Message',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.send, color: Color(0xff7b39ed)),
                      onPressed: () {
                        onSendMessage(_message.text, 'text');
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
