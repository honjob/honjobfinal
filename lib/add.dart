import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'home.dart';


class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
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

  void addProductInfo(String name, String location, String workday, String worktime, String tag, String pay, String description) {

    FirebaseFirestore.instance.collection('product').add({
      'title': title,
      'location': location,
      'workday':workday,
      'worktime':worktime,
      'tag':tag,
      'pay':pay,
      'description': description,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'like': 0,
      'likedBy': []
    }).then((value) => {
      FirebaseFirestore.instance.collection('product').doc(value.id).set({
        'title': title,
        'location': location,
        'workday':workday,
        'worktime':worktime,
        'tag':tag,
        'pay':pay,
        'description': description,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'time' : Timestamp.now(),
        'docId': value.id,
        'like': 0,
        'datetime': FieldValue.serverTimestamp(),
        'likedBy' : []
      })
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: this._formKey,
          child: Container(
            //color: const Color.fromRGBO(255, 255, 255, 0),
            decoration: new BoxDecoration(
                color: Colors.white
            ),
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
                SizedBox(height: 30,),
                Column(
                  children: [
                    AnimatedButton(
                      text: '등록하기',
                      pressEvent: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.QUESTION,
                          headerAnimationLoop: false,
                          animType: AnimType.BOTTOMSLIDE,
                          title: '정말로 등록하시겠습니까?',
                          desc: '빠트린 내용은 없는지, 허위로 작성된 내용은 없는지 확인해주세요:)',
                          buttonsTextStyle: const TextStyle(color: Colors.black),
                          showCloseIcon: true,
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            if (_formKey.currentState!.validate()) {
                              this._formKey.currentState!.save();
                              // print(this.description);
                              addProductInfo(this.title, this.location,this.worktime, this.workday, this.tag,this.pay,this.description);
                              //uploadFile(_image!.path.toString(), this.title);
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => HomePage(),)
                              );
                            }
                          },
                        ).show();
                      },
                    ),
                    const SizedBox(height: 20,),
                    AnimatedButton(
                      text: '뒤로가기',
                      pressEvent: () {
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.QUESTION,
                            headerAnimationLoop: false,
                            animType: AnimType.BOTTOMSLIDE,
                            title: '정말로 뒤로가시겠습니까?',
                            desc: '작성한 내용이 모두 사라집니다!',
                            buttonsTextStyle: const TextStyle(color: Colors.black),
                            showCloseIcon: true,
                            btnCancelOnPress: () {
                              Navigator.pushNamed(context, '/home');
                            },
                            btnOkOnPress: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => HomePage(),)
                              );
                            }
                        ).show();
                      },
                    ),
                  ],
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