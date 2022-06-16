import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

import 'home.dart';

class edit extends StatefulWidget {
  final String docID;

  edit({Key? key, required this.docID}) : super(key: key);

  @override
  _editState createState() => _editState();
}


class _editState extends State<edit> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String downloadURL = "";

  String title = "";
  String location = "";
  String workday ="";
  String worktime="";
  String tag="";
  String pay="";
  String description = "";

  final _formKey = GlobalKey<FormState>();

  File? _image;
  final picker = ImagePicker();

  Future<void> uploadFile(String filePath, String filename) async {
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(filename)
          .putFile(file);
    } catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> downloadURLExample(String name) async {
    downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(name)
        .getDownloadURL();

    return 'https://'+downloadURL;
  }

  void updateProductInfo(String name, String location, String workday, String worktime, String tag, String pay, String description) {
    FirebaseFirestore.instance.collection('product').doc(widget.docID).set({
      'title': title,
      'location': location,
      'workday':workday,
      'worktime':worktime,
      'tag':tag,
      'pay':pay,
      'description': description,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'time' : Timestamp.now(),
      'docId': widget.docID,
      'like': 0,
      'datetime': FieldValue.serverTimestamp(),
      'likedBy' : []
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: TextButton(
              child: Text('Cancel',
                  style: TextStyle(color: Colors.white, fontSize: 13.0)),
              // onPressed: () {
              //   Navigator.pushNamed(context, '/first');
              // }
            onPressed: () => Navigator.of(context).pop(),
              ),
          actions: <Widget>[
            TextButton(
                child: Text('Save',
                    style: TextStyle(color: Colors.white, fontSize: 15.0)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    this._formKey.currentState!.save();
                    updateProductInfo(this.title, this.location,this.worktime, this.workday, this.tag,this.pay,this.description);
                    FirebaseFirestore.instance
                        .collection('product')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({'datetime': DateTime.now().toString(),});
                    // FirebaseFirestore.instance
                    //     .collection('product')
                    //     .doc(widget.docID)
                    //     .delete();
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => HomePage(),)
                    );
                    Navigator.pushNamed(context, '/home');
                  }
                }),
          ],
        ),
        body: Form(
            key: this._formKey,
            child: Container(
              color: const Color.fromRGBO(255, 255, 255, 0),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.0),

                children: <Widget>[
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Text('제목:'),
                      Flexible(
                        child: TextFormField(
                          onSaved: (val) {
                            setState(() {
                              this.title=val!;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, color: Colors.black),
                            ),
                            fillColor: Colors.white,
                            labelText: '제목을 입력하세요',
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please Enter Product Name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Text('근무지: '),
                      Flexible(
                        child: TextFormField(
                          autofocus: true,
                          cursorColor: Colors.white,
                          onSaved: (val) {
                            setState(() {
                              this.location=val!;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, color: Colors.black),
                            ),
                            fillColor: Colors.white,
                            labelText: '제목을 입력하세요',
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please Enter Price Name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Text('1주 근무일수: '),
                      Flexible(
                        child: TextFormField(
                          autofocus: true,
                          cursorColor: Colors.white,
                          onSaved: (val) {
                            setState(() {
                              this.workday=val!;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, color: Colors.black),
                            ),
                            fillColor: Colors.white,
                            //labelText: '제목을 입력하세요',
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please Enter Price Name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Text('일')
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Text('하루 근무시간: '),
                      Flexible(
                        child: TextFormField(
                          autofocus: true,
                          cursorColor: Colors.white,
                          onSaved: (val) {
                            setState(() {
                              this.worktime=val!;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, color: Colors.black),
                            ),
                            fillColor: Colors.white,
                            labelText: '제목을 입력하세요',
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please Enter Price Name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Text('시간')
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Text('급여 '),
                      Flexible(
                        child: TextFormField(
                          autofocus: true,
                          cursorColor: Colors.white,
                          onSaved: (val) {
                            setState(() {
                              this.pay=val!;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, color: Colors.black),
                            ),
                            fillColor: Colors.white,
                            labelText: '제목을 입력하세요',
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please Enter Price Name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Text('원'),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Text('태그 '),
                      Flexible(
                        child: TextFormField(
                          autofocus: true,
                          cursorColor: Colors.white,
                          onSaved: (val) {
                            setState(() {
                              this.tag=val!;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, color: Colors.black),
                            ),
                            fillColor: Colors.white,
                            labelText: '제목을 입력하세요',
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please Enter Price Name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Text('세부내용 '),
                  TextFormField(
                    autofocus: true,
                    cursorColor: Colors.white,
                    onSaved: (val) {
                      setState(() {
                        this.description=val!;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            style: BorderStyle.solid, color: Colors.black),
                      ),
                      fillColor: Colors.white,
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please Enter Price Name';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            )
        ));
  }
}

class ProductInfo {
  ProductInfo({required this.title, required this.location, required this.workday, required this.worktime,required this.tag,required this.pay, required this.description, required this.userId, required this.docId, required this.like, required this.likedBy});

  final String title;
  final String location;
  final String workday;
  final String worktime;
  final String tag;
  final String pay;
  final String description;
  final String userId;
  final String docId;
  final int like;
  final List<String> likedBy;
}