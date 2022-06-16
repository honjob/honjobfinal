// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:io';
import 'map.dart';
import 'service.dart';
import 'search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fianllab/add.dart';
import 'package:fianllab/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'detail.dart';
import 'package:provider/provider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final orderList = ['Asc', 'Desc'];
  var selectedOrder = 'Asc';
  bool isDesc = false;
  GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();
  late String title;

  @override
  void initState() {
    title = "Home";
    super.initState();
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String downloadURL = "";

  Stream<QuerySnapshot> currentStream = FirebaseFirestore.instance
      .collection('product')
      .orderBy('price', descending: false)
      .snapshots();

  Future<String> url(String name) async {
    downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(name)
        .getDownloadURL();
    // Within your widgets:
    return 'https://' + downloadURL;
  }

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  int _selectedIndex = 1;
  static const TextStyle optionStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold
  );

  final List<Widget> _widgetOptions = <Widget>[
    Add(),
    AuthorList(),
    MyApp(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _bottomNavigator(){
    onItemClick: (title) {
      _key.currentState!.closeSlider();
      setState(() {
        this.title = title;
        if(title == 'add'){
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Add(),
            ),
          );
        }
        if(title == 'profile'){
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Profile(),
            ),
          );
        }
        if(title == 'home'){
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        }
        else{
          Navigator.pushNamed(context, '/$title');
        }
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SliderDrawer(
            appBar: SliderAppBar(
                appBarColor: Colors.white,
                title: Text(title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700))),
            key: _key,
            sliderOpenSize: 179,
            slider: _SliderView(
              onItemClick: (title) {
                _key.currentState!.closeSlider();
                setState(() {
                  this.title = title;
                  if(title == 'add'){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Add(),
                      ),
                    );
                  }
                  if(title == 'profile'){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Profile(),
                      ),
                    );
                  }
                  if(title == 'home'){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  }
                  if(title == 'service'){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Service(),
                      ),
                    );
                  }
                  if(title == 'LogOut'){
                    Navigator.pushNamed(context, '/login');
                  }
                  else{
                    Navigator.pushNamed(context, '/$title');
                  }
                });
              },
            ),
            child: _widgetOptions.elementAt(_selectedIndex),),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.react,
          items: [
            TabItem(icon: Icons.add, title: '공고 올리기'),
            TabItem(icon: Icons.home),
            TabItem(icon: Icons.map, title: '지도'),
          ],
          initialActiveIndex: _selectedIndex,
          onTap: _onItemTapped,

            //_bottomNavigator,
),

      ),
    );
  }
}

class _SliderView extends StatelessWidget {
  final Function(String)? onItemClick;

  const _SliderView({Key? key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            Name,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: 'BalsamiqSans'),
          ),
          SizedBox(
            height: 20,
          ),
          _SliderMenuItem(
              title: 'home', iconData: Icons.home, onTap: onItemClick),
          _SliderMenuItem(
              title: 'add',
              iconData: Icons.add_circle,
              onTap: onItemClick
              ),
          _SliderMenuItem(
              title: 'profile',
              iconData: Icons.people,
              onTap: onItemClick),
          _SliderMenuItem(
              title: 'service', iconData: Icons.phone, onTap: onItemClick),
          _SliderMenuItem(
              title: 'Setting', iconData: Icons.settings, onTap: onItemClick),
          _SliderMenuItem(
              title: 'LogOut',
              iconData: Icons.arrow_back_ios,
              onTap: onItemClick),
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function(String)? onTap;

  const _SliderMenuItem(
      {Key? key,
        required this.title,
        required this.iconData,
        required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title,
            style: TextStyle(
                color: Colors.black, fontFamily: 'BalsamiqSans_Regular')),
        leading: Icon(iconData, color: Colors.black),
        onTap: () => onTap?.call(title));
  }
}

class AuthorList extends StatefulWidget {
  @override
  _AuthorListState createState() => _AuthorListState();
}

class _AuthorListState extends State<AuthorList> {

  final orderList = ['Asc', 'Desc'];
  var selectedOrder = 'Asc';
  bool isDesc = false;
  GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();
  late String title;

  @override
  void initState() {
    title = "Home";
    super.initState();
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String downloadURL = "";

  Stream<QuerySnapshot> currentStream = FirebaseFirestore.instance
      .collection('product')
      .orderBy('pay', descending: false)
      .snapshots();

  Future<String> url(String name) async {
    downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(name)
        .getDownloadURL();
    // Within your widgets:
    return 'https://' + downloadURL;
  }

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: StreamBuilder<QuerySnapshot>(
              stream: currentStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return new Text('${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return Center(
                      child:
                      OrientationBuilder(builder: (context, orientation) {
                        return GridView.count(
                          crossAxisCount:
                          MediaQuery.of(context).orientation ==
                              Orientation.portrait
                              ? 1
                              : 2,
                          // padding: EdgeInsets.all(10),
                          childAspectRatio: 17.0 / 8.0,
                          children:
                          snapshot.data!.docs.map((DocumentSnapshot doc) {
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          16.0, 12.0, 16.0, 0.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            doc['title'],
                                            maxLines: 1,
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            doc['location'],
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            doc['pay'] + '원',
                                          ),
                                          Text(
                                            doc['description'],
                                            maxLines: 1,
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailPage(
                                                          docID: doc.id,
                                                        ),
                                                    settings: RouteSettings(
                                                      arguments: doc.id,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text("more"))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    );
                }
              }),
        ),
      ],
    );
  }
}

class Data {
  MaterialColor color;
  String title;
  String detail;

  Data(this.color, this.title, this.detail);
}

class ColoursHelper {
  static Color blue() => Color(0xff5e6ceb);

  static Color blueDark() => Color(0xff4D5DFB);
}