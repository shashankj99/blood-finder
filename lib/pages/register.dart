import 'package:blood_finder/services/mobile_number_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  // create a global form & scaffold key
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // define form variables
  String _firstName, _lastName, _mobileNumberField, _password;

  // create a variable for obscure text property
  bool _isSubmitting = false, _obscureText = true;

  /*
   * Method to show the title widget for the form
   */
  Widget _showTitleText() {
    return Text(
      'Donor Registry',
      style: Theme.of(context).textTheme.headline1,
    );
  }

  /*
   * Method to show first name widget
   */
  Widget _showFirstNameInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _firstName = val,
        validator: (val) =>
            (val.length <= 0) ? 'First name cannot be blank' : null,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.face,
            color: Colors.red[800],
          ),
          border: OutlineInputBorder(),
          labelText: 'First Name',
          hintText: 'Enter first name of the user',
        ),
      ),
    );
  }

  /*
   * Method to show last name widget
   */
  Widget _showLastNameInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _lastName = val,
        validator: (val) =>
            (val.length <= 0) ? 'Last name cannot be blank' : null,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.face,
            color: Colors.red[800],
          ),
          border: OutlineInputBorder(),
          labelText: 'Last Name',
          hintText: 'Enter last name of the user',
        ),
      ),
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
   * Method to create buttons in the register page
   */
  Widget _registerButtons() {
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
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _submit(),
                ),
          FlatButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            child: Text(
              'Already a donor? Try Logging In',
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
    // get the current state of the form
    final _form = _formKey.currentState;

    // proceed of validation succeeds
    if (_form.validate()) {
      _form.save();
      _registerUser();
    }
  }

  /*
   * Method to make APi call to register user
   */
  Future<void> _registerUser() async {
    setState(() => _isSubmitting = true);

    // make API call
    http.Response response = await http
        .post('https://secret-retreat-83337.herokuapp.com/register', body: {
      'first_name': _firstName,
      'last_name': _lastName,
      'mobile': _mobileNumberField,
      'password': _password,
    });

    // decode response body
    final responseData = json.decode(response.body);

    setState(() => _isSubmitting = false);

    // call method that displays message in the snack bar
    _showMessage(responseData);
  }

  /*
   * Method to show response message in snack bar
   */
  void _showMessage(responseData) {
    String _message;

    if (responseData['status'] == 422)
      _message = responseData['errors']['mobile'][0];
    else
      _message = responseData['message'];

    // create snack bar widget
    final _snackBar = SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          _message,
          style: TextStyle(
            color: (responseData['status'] == 200) ? Colors.green : Colors.red,
          ),
        ));

    // show the snack bar in the scaffold
    _scaffoldKey.currentState.showSnackBar(_snackBar);

    // reset form value &
    // navigate to otp verification if registered successfully
    if (responseData['status'] == 200) {
      _formKey.currentState.reset();

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/otp-verification');
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Blood Finder > Register New User'),
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
                  _showFirstNameInput(),
                  _showLastNameInput(),
                  _showMobileNumberInput(),
                  _showPassword(),
                  _registerButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
