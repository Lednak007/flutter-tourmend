import 'package:shared_preferences/shared_preferences.dart';
import '../services/loginSignup.dart';
import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'package:email_validator/email_validator.dart';

class SignUpPage extends StatefulWidget {
  final String title;

  SignUpPage({Key key, this.title}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  TextEditingController _username;
  TextEditingController _email;
  TextEditingController _password;
  TextEditingController _confirmpass;

  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();

    _username = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmpass = TextEditingController();

    _formKey = GlobalKey<FormState>();
  }

  void _clearValues() {
    _username.text = '';
    _email.text = '';
    _password.text = '';
    _confirmpass.text = '';
  }

  void _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _signUp() async {
    //using shared preferences to store some values
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('username', _username.text);
    sharedPreferences.setString('user_email', _email.text);

    LoginSignup.signup(_username.text, _email.text, _password.text)
        .then((result) {
      print(result);
      if (result == '1') {
        _clearValues();
        _showSnackBar(context, 'User successfully created!');
      } else if (result == '0') {
        _clearValues();
        _showSnackBar(context, 'Error while registering user!');
      } else {
        _showSnackBar(context, 'This email address already has an account');
      }
    });
  }

  Widget allTextField() {
    return Form(
      key: _formKey,
      child: Container(
        padding: new EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            new TextFormField(
              controller: _username,
              decoration: InputDecoration(
                  labelText: 'Username',
                  contentPadding: EdgeInsets.only(bottom: 10)),
              validator: (value) =>
                  value.isEmpty ? 'Username is required!' : null,
            ),
            SizedBox(
              height: 30,
            ),
            new TextFormField(
                controller: _email,
                decoration: InputDecoration(
                    labelText: 'Email',
                    contentPadding: new EdgeInsets.only(bottom: 1.0)),
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Email is required!';
                  } else if (!EmailValidator.Validate(val, true, true)) {
                    return 'Invalid email address!';
                  } else
                    return null;
                }),
            SizedBox(
              height: 30,
            ),
            new TextFormField(
              controller: _password,
              decoration: InputDecoration(
                  labelText: 'Password',
                  contentPadding: new EdgeInsets.only(bottom: 1.0)),
              validator: (val) => val.length < 6
                  ? 'Password must be atleast 6 characters long!'
                  : null,
              obscureText: true,
            ),
            SizedBox(
              height: 30,
            ),
            new TextFormField(
              controller: _confirmpass,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                contentPadding: new EdgeInsets.only(bottom: 1.0),
              ),
              validator: (val) {
                if (val.isEmpty) return 'Enter the password for confirmation!';
                if (val != _password.text) return 'Password didn\'t match!';
                return null;
              },
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
        onTap: () {
          if (_formKey.currentState.validate()) {
            _signUp();
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              color: Color(0xff00BFFF)),
          child: Text(
            'Register Now',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
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

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              'Login',
              style: TextStyle(
                  color: Color(0xff00BFFF),
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Container _title() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      alignment: Alignment.center,
      child: Text("TourMend",
          style: TextStyle(
              color: Color(0xfff00BFFF),
              fontSize: 40.0,
              fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height,
        child: new Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  _title(),
                  SizedBox(
                    height: 30,
                  ),
                  allTextField(),
                  SizedBox(
                    height: 40,
                  ),
                  _submitButton(),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 0,
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _loginAccountLabel(),
            ),
            Positioned(top: 30, left: 10, child: _backButton()),
          ],
        ),
      )),
    );
  }
}
