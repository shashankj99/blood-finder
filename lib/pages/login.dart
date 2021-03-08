import 'package:blood_finder/services/mobile_number_validator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // create a global form & scaffold key
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // create a variable for obscure text property
  bool _isSubmitting = false, _obscureText = true;

  // define form  variables
  String _mobileNumberField, _password;

  /*
   * Method to show the title widget for the form
   */
  Widget _showTitleText() {
    return Text(
      'Donor Log In',
      style: Theme.of(context).textTheme.headline1,
    );
  }

  /*
   * Method to show mobile number widget
   */
  Widget _showMobileNumberInput() {
    MobileNumberValidator _mobileNumberValidator = new MobileNumberValidator();
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        onSaved: (val) => _mobileNumberField = val,
        validator: (val) => _mobileNumberValidator.mobileNumberValidator(val),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.phone_android,
            color: Colors.red[800],
          ),
          border: OutlineInputBorder(),
          labelText: 'Mobile Number',
          hintText: 'Enter active mobile number of the user',
        ),
      ),
    );
  }

  /*
   * Method to show password widget
   */
  Widget _showPassword() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _password = val,
        validator: (val) => (val.length < 6)
            ? 'Password must be at least 6 characters in length'
            : null,
        obscureText: _obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.red[800],
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() => _obscureText = !_obscureText);
            },
            child:
                Icon((_obscureText) ? Icons.visibility : Icons.visibility_off),
          ),
          border: OutlineInputBorder(),
          labelText: 'Password',
          hintText: 'Enter a suitable password',
        ),
      ),
    );
  }

  /*
   * method to create buttons for login page
   */
  Widget _loginButton() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          _isSubmitting == true
              ? CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                )
              : RaisedButton(
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _submit(),
                ),
          FlatButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/register'),
            child: Text(
              'Not a donor? Try Registering',
              style: TextStyle(color: Colors.red[800]),
            ),
          ),
        ],
      ),
    );
  }

  /*
   * Method to handle validation and form save on clicking register
   */
  void _submit() {
    // get the form state
    final _form = _formKey.currentState;

    // save the form &
    // login user if form is validated
    if (_form.validate()) {
      _form.save();
      _loginUser();
    }
  }

  /*
   * Method to make API call to login the user
   */
  Future<void> _loginUser() async {
    setState(() => _isSubmitting = true);

    // make API call
    http.Response response = await http
        .post('https://secret-retreat-83337.herokuapp.com/login', body: {
      'mobile': _mobileNumberField,
      'password': _password,
    });

    // decode response body
    final responseData = json.decode(response.body);

    setState(() => _isSubmitting = false);

    // call method that displays message in the snack bar
    _showMessage(responseData);

    if (responseData['status'] == 409)
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/otp-verification');
      });

    // reset form value
    if (responseData['status'] == 200) {
      _formKey.currentState.reset();

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/dashboard');
      });

      // function to store access token in cache
      _storeAccessToken(responseData);
    }
  }

  /*
   * Method to store access token in cache
   */
  Future<void> _storeAccessToken(responseData) async {
    final sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setString('access_token', responseData['access_token']);
  }

  /*
   * Method to show response message in snack bar
   */
  void _showMessage(responseData) {
    // create snack bar widget
    final _snackBar = SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          responseData['message'],
          style: TextStyle(
            color: (responseData['status'] == 200) ? Colors.green : Colors.red,
          ),
        ));

    // show the snack bar in the scaffold
    _scaffoldKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Blood Finder > Sign In'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _showTitleText(),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  _showMobileNumberInput(),
                  _showPassword(),
                  _loginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
