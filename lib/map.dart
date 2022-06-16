// import 'package:flutter/material.dart';
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
//
// void main(){
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Home(),
//     );
//   }
// }
//
// class Home extends StatefulWidget{
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   String googleApikey = " ";
//   GoogleMapController? mapController; //contrller for Google map
//   CameraPosition? cameraPosition;
//   LatLng startLocation = LatLng(27.6602292, 85.308027);
//   String location = "Search Location";
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//         appBar: AppBar(
//           title: Text("Place Search Autocomplete Google Map"),
//           backgroundColor: Colors.deepPurpleAccent,
//         ),
//         body: Stack(
//             children:[
//
//               GoogleMap( //Map widget from google_maps_flutter package
//                 zoomGesturesEnabled: true, //enable Zoom in, out on map
//                 initialCameraPosition: CameraPosition( //innital position in map
//                   target: startLocation, //initial position
//                   zoom: 14.0, //initial zoom level
//                 ),
//                 mapType: MapType.normal, //map type
//                 onMapCreated: (controller) { //method called when map is created
//                   setState(() {
//                     mapController = controller;
//                   });
//                 },
//               ),
//
//
//
//               //search autoconplete input
//               Positioned(  //search input bar
//                   top:10,
//                   child: InkWell(
//                       onTap: () async {
//                         var place = await PlacesAutocomplete.show(
//                             context: context,
//                             apiKey: googleApikey,
//                             mode: Mode.overlay,
//                             types: [],
//                             strictbounds: false,
//                             components: [Component(Component.country, 'np')],
//                             //google_map_webservice package
//                             onError: (err){
//                               print(err);
//                             }
//                         );
//
//                         if(place != null){
//                           setState(() {
//                             location = place.description.toString();
//                           });
//
//                           //form google_maps_webservice package
//                           final plist = GoogleMapsPlaces(apiKey:googleApikey,
//                             apiHeaders: await GoogleApiHeaders().getHeaders(),
//                             //from google_api_headers package
//                           );
//                           String placeid = place.placeId ?? "0";
//                           final detail = await plist.getDetailsByPlaceId(placeid);
//                           final geometry = detail.result.geometry!;
//                           final lat = geometry.location.lat;
//                           final lang = geometry.location.lng;
//                           var newlatlang = LatLng(lat, lang);
//
//
//                           //move map camera to selected place with animation
//                           mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
//                         }
//                       },
//                       child:Padding(
//                         padding: EdgeInsets.all(15),
//                         child: Card(
//                           child: Container(
//                               padding: EdgeInsets.all(0),
//                               width: MediaQuery.of(context).size.width - 40,
//                               child: ListTile(
//                                 title:Text(location, style: TextStyle(fontSize: 18),),
//                                 trailing: Icon(Icons.search),
//                                 dense: true,
//                               )
//                           ),
//                         ),
//                       )
//                   )
//               )
//
//
//             ]
//         )
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Your api key storage.
//import 'keys.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Light Theme
  final ThemeData lightTheme = ThemeData.light().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.white,
    buttonTheme: ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.black,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // Dark Theme
  final ThemeData darkTheme = ThemeData.dark().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.grey,
    buttonTheme: ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.yellow,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: MapPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  PickResult? selectedPlace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("Load Google Map"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlacePicker(
                          apiKey: "AIzaSyAoQWv0WmDqO3PTMCvBowEGh-js5e_lEn0",
                          initialPosition: MapPage.kInitialPosition,
                          useCurrentLocation: true,
                          selectInitialPosition: true,

                          //usePlaceDetailSearch: true,
                          onPlacePicked: (result) {
                            selectedPlace = result;
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          forceSearchOnZoomChanged: true,
                          automaticallyImplyAppBarLeading: false,
                          autocompleteLanguage: "ko",
                          region: 'au',
                          //selectInitialPosition: true,
                          selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                            print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                            return isSearchBarFocused
                                ? Container()
                                : FloatingCard(
                              bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                              leftPosition: 0.0,
                              rightPosition: 0.0,
                              width: 500,
                              borderRadius: BorderRadius.circular(12.0),
                              child: state == SearchingState.Searching
                                  ? Center(child: CircularProgressIndicator())
                                  : RaisedButton(
                                child: Text("Pick Here"),
                                onPressed: () {
                                  // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                  //            this will override default 'Select here' Button.
                                  print("do something with [selectedPlace] data");
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                          pinBuilder: (context, state) {
                            if (state == PinState.Idle) {
                              return Icon(Icons.favorite_border);
                            } else {
                              return Icon(Icons.favorite);
                            }
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              selectedPlace == null ? Container() : Text(selectedPlace?.formattedAddress ?? ""),
            ],
          ),
        ));
  }
}