import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

String Uid = FirebaseAuth.instance.currentUser!.uid.toString();
String Email = FirebaseAuth.instance.currentUser!.email.toString();
String Name = FirebaseAuth.instance.currentUser!.displayName.toString();
String Message = FirebaseFirestore.instance.collection('user').doc('status_message').snapshots() as String;



class _ProfileState extends State<Profile> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String downloadURL = "";


  Future<String> downloadURLExample() async {
    downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('logo.png')
        .getDownloadURL();
    // Within your widgets:
    return 'https://' + downloadURL;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
        backgroundColor: Colors.white,
        actions: <Widget>[
          TextButton(
            child: Text('로그아웃',
               style:TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      body:  Center(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          FirebaseAuth.instance.currentUser!.photoURL.toString(),
                        )
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    Name
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    height: 20,
                    thickness: 3,
                    //indent: 20,
                    endIndent: 0,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('내가 올린 공고')
                ],
              ),
            )
    );
  }
}
