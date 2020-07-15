import 'package:flutter/material.dart';
import 'package:flutter_app/services/fetchPlaces.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/widgets/mainPageWidgets/placesWidgets/modal/places.dart';

class PlacesPage extends StatefulWidget {
  final String title;

  PlacesPage({Key key, this.title}) : super(key: key);
  @override
  _PlacesPageState createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  List<PlacesData> placesData;
  ScrollController _scrollController;
  int pageNumber;
  bool isLoading;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    placesData = List();
    pageNumber = 1;
    isLoading = true;

    _fetchPlaces().then((result) {
      for (var place in result) {
        placesData.add(place);
        setState(() {
          isLoading = false;
        });
      }
    });
    _scrollController.addListener(() {
      // print(_scrollController.position.extentAfter);
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          pageNumber++;
        });
        _fetchPlaces().then((result) {
          for (var place in result) {
            placesData.add(place);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder<List<PlacesData>>(
          initialData: placesData,
          future: _fetchPlaces(),
          builder: (context, snapshot) {
            if (isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: placesData.length,
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (snapshot.data != null) {
                    if (snapshot.data.length + 1 == index) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.all(10.0),
                      child: Column(children: <Widget>[
                        Padding(
                          child: Image.network(
                            placesData[index].placesImageURL,
                            fit: BoxFit.cover,
                          ),
                          padding: EdgeInsets.only(bottom: 2.0),
                        ),
                        Row(children: <Widget>[
                          Padding(
                              child: Text(
                                placesData[index].placeName,
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                                textAlign: TextAlign.right,
                              ),
                              padding: EdgeInsets.all(1.0)),
                          Text(" | "),
                          Padding(
                              child: Text(
                                placesData[index].destination,
                                style:
                                    new TextStyle(fontStyle: FontStyle.italic),
                                textAlign: TextAlign.right,
                              ),
                              padding: EdgeInsets.all(1.0)),
                        ]),
                        Divider(color: Colors.black),
                      ]),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  Future<List<PlacesData>> _fetchPlaces() {
    return FetchPlaces.fetchPlaces(pageNumber: pageNumber)
        .then((value) => value.places);
  }
}