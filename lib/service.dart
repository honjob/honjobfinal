import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'home.dart';


class Service extends StatefulWidget {
  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String title = "";
  String phone = "";
  String description = "";

  final _formKey = GlobalKey<FormState>();

  void addProductInfo(String name, String phone, String description) {

    FirebaseFirestore.instance.collection('service').add({
      'title': title,
      'description': description,
      'phone':phone,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    }).then((value) => {
      FirebaseFirestore.instance.collection('service').doc(value.id).set({
        'title': title,
        'description': description,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'time' : Timestamp.now(),
        'docId': value.id,
        'phone':phone,
        'datetime': FieldValue.serverTimestamp(),
      })
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('고객의 소리',style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          actions: <Widget>[
          ],
        ),
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
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return '제목을 입력해 주세요.';
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
                      Text('연락처: '),
                      Flexible(
                        child: TextFormField(
                          autofocus: true,
                          cursorColor: Colors.white,
                          onSaved: (val) {
                            setState(() {
                              this.phone=val!;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, color: Colors.black),
                            ),
                            fillColor: Colors.white,
                            labelText: '답변을 받으실 번호를 입력해주세요.',
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return '답변을 받으실 번호를 입력해주세요.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Text('문의내용 '),
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
                        return '문의 내용을 입력해 주세요.';
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
                            desc: '불편을 드려 죄송합니다.',
                            buttonsTextStyle: const TextStyle(color: Colors.black),
                            showCloseIcon: true,
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              if (_formKey.currentState!.validate()) {
                                this._formKey.currentState!.save();
                                // print(this.description);
                                addProductInfo(this.title, this.phone,this.description);
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

class ServiceInfo {
  ServiceInfo({required this.title, required this.phone, required this.description, required this.userId, required this.docId});

  final String title;
  final String phone;
  final String description;
  final String userId;
  final String docId;
}