import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import './loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences logindata;
  String username;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username');
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actionsPadding: EdgeInsets.all(10.0),
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit TourMend'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: _handleLogout,
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _handleLogout() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    logindata.remove("user_email");
    logindata.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  static const TextStyle optionStyle = TextStyle(fontSize: 30);
  static const List<Widget> _widgetOption = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Places',
      style: optionStyle,
    ),
    Text(
      'Index 2: News',
      style: optionStyle,
    ),
    Text(
      'Index 3: Saved',
      style: optionStyle,
    ),
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        appBar: new AppBar(
          title: Center(
              child: Text("TourMend", style: TextStyle(color: Colors.white))),
          actions: <Widget>[
            FlatButton(
                onPressed: () {},
                child: Icon(Icons.notifications, color: Colors.white)),
          ],
        ),
        body: Center(child: _widgetOption.elementAt(_selectedIndex)),
        drawer: Drawer(
            child: ListView(children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Colors.deepOrange, Colors.orangeAccent])),
              child: Container(
                child: Column(children: <Widget>[
                  Material(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      elevation: 10,
                      child: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: CircleAvatar(
                            backgroundImage: ExactAssetImage(''),
                            radius: 50.0,
                            child: Image.asset(
                              'lib/assets/leo_messi.jpg',
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                            ),
                          )))
                ]),
              )),
          CustomListTile(Icons.person, 'Profile', () => {}),
          CustomListTile(Icons.notifications, 'Notification', () => {}),
          CustomListTile(Icons.settings, 'Setting', () => {}),
          CustomListTile(
            Icons.lock,
            'Log Out',
            _onBackPressed,
          )
        ])),
        bottomNavigationBar: FFNavigationBar(
          theme: FFNavigationBarTheme(
            barBackgroundColor: Colors.white70,
            selectedItemBorderColor: Colors.yellow,
            selectedItemBackgroundColor: Colors.green,
            selectedItemIconColor: Colors.white,
            selectedItemLabelColor: Colors.black,
          ),
          selectedIndex: _selectedIndex,
          onSelectTab: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            FFNavigationBarItem(
              iconData: Icons.home,
              label: 'Home',
            ),
            FFNavigationBarItem(
              iconData: Icons.place,
              label: 'Places',
            ),
            FFNavigationBarItem(
              iconData: Icons.assignment,
              label: 'News',
            ),
            FFNavigationBarItem(
              iconData: Icons.save,
              label: 'Saved',
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;

  CustomListTile(this.icon, this.text, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: Container(
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey.shade400))),
            child: InkWell(
                splashColor: Colors.orangeAccent,
                onTap: onTap,
                child: Container(
                  height: 40,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Icon(icon),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              text,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ]),
                        Icon(Icons.arrow_right)
                      ]),
                ))));
  }
}
