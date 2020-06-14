import 'package:flutter/material.dart';

void main() => runApp(TourMendApp());

class TourMendApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TourMend",
      // theme: ,
      home: _MyLoginPage(),
    );
  }
}

class _MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<_MyLoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController _logoAnimationController;
  Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
    _logoAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 100),
    );

    _logoAnimation = new CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeOut,
    );

    _logoAnimation.addListener(() => this.setState(() {}));
    _logoAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.greenAccent,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // Image(
            //   image: AssetImage(''),
            // ),
            Column(              
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterLogo(
                  size: _logoAnimation.value * 100,
                ),
                Container(
                  padding: EdgeInsets.only(top: 50),
                  child: Text(
                    "TOURMEND",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontFamily: 'Google Sans',
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                )
              ],
            ),

            Container(
              padding: EdgeInsets.only(bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                        color: Colors.white,
                        minWidth: 100,
                        elevation: 10,
                        onPressed: () => {},
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Google Sans',
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      MaterialButton(
                        color: Colors.white,
                        minWidth: 100,
                        elevation: 10,
                        onPressed: () => {},
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Google Sans',
                            color: Colors.black87,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
