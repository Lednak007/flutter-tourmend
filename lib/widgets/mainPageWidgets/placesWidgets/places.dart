import 'dart:convert';
//import 'placeinfo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:photo_view/photo_view.dart';

class PlacesPage extends StatefulWidget {
  PlacesPage({Key key}) : super(key: key);

  @override
  PlacesPageState createState() => PlacesPageState();
}

class PlacesPageState extends State<PlacesPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Places'),
          ),
        ),
        body: JsonListView(),
      ),
    );
  }
}

class Placesdata {
  String id;
  String pName;
  String dst;
  String placesImageURL;
  String info;
  String itinerary;
  String map;

  Placesdata(
      {this.id,
      this.pName,
      this.dst,
      this.placesImageURL,
      this.info,
      this.itinerary,
      this.map});

  factory Placesdata.fromJson(Map<String, dynamic> json) {
    return Placesdata(
        id: json['id'],
        pName: json['placename'],
        dst: json['dst'],
        placesImageURL: json['placeimage'],
        info: json['info'],
        itinerary: json['Itinerary'],
        map: json['map']);
  }
}

class JsonListView extends StatefulWidget {
  JsonListViewWidget createState() => JsonListViewWidget();
}

class JsonListViewWidget extends State<JsonListView> {
  final String uri = "http://10.0.2.2/TourMendWebServices/placesJson.php";

  Future<List<Placesdata>> fetchPlaces() async {
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Placesdata> listOfFruits = items.map<Placesdata>((json) {
        return Placesdata.fromJson(json);
      }).toList();

      return listOfFruits;
    } else {
      throw Exception('Failed to load data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Placesdata>>(
      future: fetchPlaces(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        Positioned(
          top: 30,
          right: 15,
          left: 15,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        hintText: "Search here"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                ),
              ],
            ),
          ),
        );
        return ListView(
          children: snapshot.data
              .map((data) => Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                    child: Column(children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            var route = new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new NestedTabBar(value: data),
                            );

                            Navigator.of(context).push(route);
                          },
                          child: new Container(
                            padding: EdgeInsets.all(3.0),
                            margin: EdgeInsets.all(3.0),
                            child: Column(children: <Widget>[
                              Padding(
                                child: Image.network(
                                  data.placesImageURL,
                                  fit: BoxFit.cover,
                                ),
                                padding: EdgeInsets.only(bottom: 2.0),
                              ),
                              Row(children: <Widget>[
                                Padding(
                                    child: Text(
                                      data.pName,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      textAlign: TextAlign.right,
                                    ),
                                    padding: EdgeInsets.all(1.0)),
                                Text(" | "),
                                Padding(
                                    child: Text(
                                      data.dst,
                                      style: new TextStyle(
                                          fontStyle: FontStyle.italic),
                                      textAlign: TextAlign.right,
                                    ),
                                    padding: EdgeInsets.all(1.0)),
                              ]),
                              Divider(color: Colors.black),
                            ]),
                          ))
                    ]),
                  ))
              .toList(),
        );
      },
    );
  }
}

class NestedTabBar extends StatefulWidget {
  final Placesdata value;
  NestedTabBar({Key key, this.value}) : super(key: key);
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  TabController _nestedTabController;

  @override
  void initState() {
    super.initState();

    _nestedTabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 30.0,
              ),
            ),
            Text(
              'Back',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /* appBar: AppBar(
            title: Text(
          '${widget.value.pName}',
          style: TextStyle(fontSize: 20.0),
        )),*/
        body: SingleChildScrollView(
      child: new Center(
        child: Column(children: <Widget>[
          Padding(
            child: Stack(children: <Widget>[
              Image.network(
                '${widget.value.placesImageURL}',
                fit: BoxFit.cover,
                height: 250,
              ),
              Positioned(top: 30, child: _backButton()),
            ]),
            padding: EdgeInsets.only(
              bottom: 2.0,
            ),
          ),
          nestedTabBar(),
        ]),
      ),
    ));
  }

  Widget nestedTabBar() {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TabBar(
          controller: _nestedTabController,
          indicatorColor: Colors.teal,
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.black54,
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              text: "Info",
            ),
            Tab(
              text: "Itinerary",
            ),
            Tab(
              text: "Map",
            ),
          ],
        ),
        Container(
          height: screenHeight * 0.80,
          margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: TabBarView(
            controller: _nestedTabController,
            children: <Widget>[
              Container(
                child: Text(
                  '${widget.value.info}',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Container(
                child: Text(
                  '${widget.value.itinerary}',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              new PhotoView(
                  imageProvider: NetworkImage(
                    '${widget.value.map}',
                  ),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: 4.0),
            ],
          ),
        )
      ],
    );
  }
}
