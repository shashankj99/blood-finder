import 'package:blood_finder/components/mobile_number_validator.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  // create a global form key
  final _formKey = GlobalKey<FormState>();

  // define form variables
  String _fullName, _mobileNumberField, _password;

  // create a variable for obscure text property
  bool _obscureText = true;

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
   * Method to show full name widget
   */
  Widget _showFullNameInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _fullName = val,
        validator: (val) =>
            (val.length <= 0) ? 'Full name cannot be blank' : null,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.face,
            color: Colors.red[800],
          ),
          border: OutlineInputBorder(),
          labelText: 'Full Name',
          hintText: 'Enter full name of the user',
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
   * Method to create buttons in the register page
   */
  Widget _registerButtons() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          RaisedButton(
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
      print ('Full name: $_fullName, Mobile Number: $_mobileNumberField, Password: $_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  _showFullNameInput(),
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
