import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _code;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            PinFieldAutoFill(
              decoration: UnderlineDecoration(
                textStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black
                ),
                colorBuilder: FixedColorBuilder(
                  Colors.black.withOpacity(0.3)
                ),
              ),
              currentCode: _code,
              onCodeSubmitted: (code) {},
              onCodeChanged: (code) {
                if (code.length == 6)
                  FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
            Spacer(),
            FlatButton(
              child: Text(
                'Proceed to verification',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                final _snackBar = SnackBar(
                  content: Text('Proceed to verification clicked'),
                );
                _scaffoldKey.currentState.showSnackBar(_snackBar);
              },
            ),
          ],
        ),
      ),
    );
  }
}

