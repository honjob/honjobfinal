import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CloudFirestoreSearch extends StatefulWidget {
  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  String name = "";
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String downloadURL = "";

  Stream<QuerySnapshot> currentStream = FirebaseFirestore.instance
      .collection('product')
      .orderBy('price', descending: false)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "" && name != null)
            ? FirebaseFirestore.instance
            .collection('product')
            .where("searchKeywords", arrayContains: name)
            .snapshots()
            : FirebaseFirestore.instance.collection("items").snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot data = snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
              return Card(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      data['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: searchPageHeader(),
//       body: futureSearchResults == null ? displayNoSearchResultScreen() : displayUsersFoundScreen(),
//     );
//   }
//   TextEditingController searchTextEditingController = TextEditingController();
// // DB에서 검색된 사용자를 가져오는데 활용되는 변수
//   Future<QuerySnapshot>? futureSearchResults;
//
// // X 아이콘 클릭시 검색어 삭제
//   emptyTheTextFormField() {
//     searchTextEditingController.clear();
//   }
//
// // 검색어 입력후 submit하게되면 DB에서 검색어와 일치하거나 포함하는 결과 가져와서 future변수에 저장
//   controlSearching(str) {
//     print(str);
//     Future<QuerySnapshot> allUsers = userReference.where('profileName', isGreaterThanOrEqualTo: str).get();
//     setState(() {
//       futureSearchResults = allUsers;
//     });
//   }
//
// // 검색페이지 상단부분
//   AppBar searchPageHeader() {
//     return AppBar(
//         backgroundColor: Colors.black,
//         title: TextFormField(
//           controller: searchTextEditingController, // 검색창 controller
//           decoration: InputDecoration(
//               hintText: 'Search here....',
//               hintStyle: TextStyle(
//                 color: Colors.grey,
//               ),
//               enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.grey,)
//               ),
//               focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white,)
//               ),
//               filled: true,
//               prefixIcon: Icon(Icons.person_pin, color: Colors.white, size: 30),
//               suffixIcon: IconButton(icon: Icon(Icons.clear, color: Colors.white,), onPressed: emptyTheTextFormField)
//           ),
//           style: TextStyle(
//               fontSize: 18,
//               color: Colors.white
//           ),
//           onFieldSubmitted: controlSearching,
//         )
//     );
//   }
//
//   displayNoSearchResultScreen() {
//     final Orientation orientation = MediaQuery.of(context).orientation;
//     return Container(
//         child: Center(
//             child: ListView(
//               shrinkWrap: true,
//               children: <Widget>[
//                 Icon(Icons.group, color: Colors.grey, size: 150),
//                 Text(
//                   'Search Users',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 40
//                   ),
//                 ),
//               ],
//             )
//         )
//     );
//   }
//
//   displayUsersFoundScreen() {
//     return FutureBuilder(
//         future: futureSearchResults,
//         builder: (context, snapshot) {
//           if(!snapshot.hasData) {
//             return circularProgress();
//           }
//
//           List<UserResult> searchUserResult = [];
//           snapshot.data?.doc.forEach((document) {
//             User users = User.fromDocument(document);
//             UserResult userResult = UserResult(users);
//             searchUserResult.add(userResult);
//           });
//
//           return ListView(
//               children: searchUserResult
//           );
//         }
//     );
//   }
//
// }
// class UserResult extends StatelessWidget {
//   final User eachUser;
//   UserResult(this.eachUser);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.all(3),
//         child: Container(
//           color: Colors.white54,
//           child: Column(
//             children: <Widget>[
//               GestureDetector(
//                 onTap: () {
//                   print('tapped');
//                 },
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.black,
//                     backgroundImage: eachUser.url == null ? circularProgress() : CachedNetworkImageProvider(eachUser.url,),
//                   ),
//                   title: Text(eachUser.profileName, style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   )),
//                   subtitle: Text(eachUser.username, style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 13,
//                   )),
//                 ),
//               )
//             ],
//           ),
//         )
//     );
//   }
 }