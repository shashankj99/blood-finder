import 'package:blood_finder/components/mobile_number_validator.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // create a global form key
  final _formKey = GlobalKey<FormState>();

  // create a variable for obscure text property
  bool _obscureText = true;

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
   * Method to show mobile number widget
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
            child: Icon(
                (_obscureText) ? Icons.visibility : Icons.visibility_off
            ),
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
          RaisedButton(
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
            onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
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
    final _form = _formKey.currentState;

    if (_form.validate()) {
      _form.save();
      print ('Mobile Number: $_mobileNumberField, Password: $_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
