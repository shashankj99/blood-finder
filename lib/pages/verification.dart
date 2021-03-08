import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  // global key for scaffold state
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // declare _code var of type String
  String _code;

  // set is submitting value to false
  bool _isSubmitting = false;

  // initial state function
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  /*
   * Method to make API call for user verification
   */
  Future<void> _verifyUser() async {
    setState(() => _isSubmitting = true);

    // make API call
    http.Response response = await http
        .post('https://secret-retreat-83337.herokuapp.com/verify', body: {
      'otp': _code,
    });

    // decode response body
    final responseData = json.decode(response.body);

    setState(() => _isSubmitting = false);

    // show response message in snack bar
    _showMessage(responseData);

    if (responseData['status'] == 200) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/dashboard');
      });

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

  void _cannotClickButton() {
    // create snack bar widget
    final _snackBar = SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          'You can not send this otp',
          style: TextStyle(
            color: Colors.red,
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
        title: Text('Blood Finder > OTP Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20.0)),
              PinFieldAutoFill(
                decoration: UnderlineDecoration(
                  textStyle: TextStyle(fontSize: 20.0, color: Colors.black),
                  colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
                ),
                currentCode: _code,
                onCodeSubmitted: (code) {},
                onCodeChanged: (code) {
                  if (code.length == 6)
                    setState(() {
                      _code = code;
                    });
                },
              ),
              Padding(padding: EdgeInsets.only(top: 60.0)),
              _isSubmitting == true
                  ? CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    )
                  : FlatButton(
                      child: Text(
                        'Proceed to verification',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        if (_code == null || _code.length < 6)
                          _cannotClickButton();
                        else
                          _verifyUser();
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
