import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'edit.dart';
import 'map.dart';

class DetailPage extends StatefulWidget {
  final String docID;

  DetailPage({Key? key, required this.docID}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    CollectionReference Product =
        FirebaseFirestore.instance.collection('product');


    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    String Name = FirebaseAuth.instance.currentUser!.displayName.toString();
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return FutureBuilder<DocumentSnapshot>(
        future: Product.doc(widget.docID).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return new Text('${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              int numLike = snapshot.data!['like'];
              List<String> likedPeople = List.from(snapshot.data!['likedBy']);

              return MaterialApp(
                home: Scaffold(
                  key: _scaffoldKey,
                  appBar: AppBar(
                      backgroundColor: Colors.white,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      title: Center(
                        child: Text(snapshot.data!['title'],style: TextStyle(color: Colors.black),),
                      ),
                      actions: FirebaseAuth.instance.currentUser!.uid ==
                              snapshot.data!['userId']
                          ? <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.create,
                                  color: Colors.black,
                                  semanticLabel: 'filter',
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          edit(
                                            docID: widget.docID,
                                          ),
                                      settings: RouteSettings(
                                        arguments: widget.docID,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                  semanticLabel: 'filter',
                                ),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('product')
                                      .doc(widget.docID)
                                      .delete();
                                  firebase_storage.FirebaseStorage.instance
                                      .ref(snapshot.data!['title'])
                                      .delete();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ]
                          : <Widget>[]),
                  body: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        child: Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text("작성자:"),
                                        Text(Name),
                                      ],
                                    ),
                                    SizedBox(width: 25,),
                                    Row(
                                      children: [
                                        Text("작성 일자: "),
                                        Text(DateFormat('yy-MM-dd  kk:mm').format(snapshot.data!['datetime'].toDate())),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Text(
                                        '제목: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.0,
                                        ),
                                      ),Text(
                                        snapshot.data!['title'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                    Text(
                                      '근무지: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!['location'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(

                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  child: Text('지도에서 확인하기',
                                      style:TextStyle(color: Colors.black)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => MyApp(),
                                      ),
                                    );
                                  }
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                    Text(
                                      '근무 일정: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    Text(
                                      '주',
                                      style: TextStyle(

                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!['workday'],
                                      style: TextStyle(

                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      '회/',
                                      style: TextStyle(

                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!['worktime'],
                                      style: TextStyle(

                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      '시간',
                                      style: TextStyle(

                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Row(

                                    children: [
                                      Text(
                                        '급여:  ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      Text(
                                        snapshot.data!['pay'] + '원',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                    ]),
                              ],
                            ))
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(32.0,0.0,0.0,10.0),
                        child: Text('세부내용',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                      Container(
                        padding: const EdgeInsets.all(32.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 0, 10.0, 0),
                                    child: Text(
                                        snapshot.data!['description'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                              ],
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 200,
                      ),

                    ],
                  ),
                ));
          }
        });
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

