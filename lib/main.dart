import 'package:blood_finder/models/app_state.dart';
import 'package:blood_finder/pages/dashboard.dart';
import 'package:blood_finder/pages/landing_page.dart';
import 'package:blood_finder/pages/login.dart';
import 'package:blood_finder/pages/register.dart';
import 'package:blood_finder/pages/verification.dart';
import 'package:blood_finder/redux/actions.dart';
import 'package:blood_finder/redux/reducers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [thunkMiddleware]
  );
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({this.store});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Blood Finder',
        routes: {
          '/login' : (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
          '/otp-verification': (BuildContext context) => Verification(),
          '/dashboard': (BuildContext context) => Dashboard(),
        },
        theme: ThemeData(
          cursorColor: Colors.red[800],
          primaryColor: Colors.red[800],
          accentColor: Colors.red[800],
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 64.0,
                fontWeight: FontWeight.bold
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LandingPage(
          onInit: () => StoreProvider.of<AppState>(context).dispatch(getAuthAction),
        ),
      ),
    );
  }
}
