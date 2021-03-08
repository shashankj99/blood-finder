import 'package:blood_finder/models/app_state.dart';
import 'package:blood_finder/pages/dashboard.dart';
import 'package:blood_finder/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LandingPage extends StatefulWidget {
  // function of type void
  // called as soon as the app is loaded
  final void Function() onInit;

  // Landing Page Constructor
  LandingPage({this.onInit});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // initial state function
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        if (state.accessToken == null)
          return LoginPage();
        else
          return Dashboard();
      },
    );
  }
}
