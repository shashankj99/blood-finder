import 'package:blood_finder/models/app_state.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth Action
ThunkAction<AppState> getAuthAction = (Store<AppState> store) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final String accessToken = sharedPreferences.getString('access_token');

  store.dispatch(GetAuthAction(accessToken));
};

class GetAuthAction {
  final String _accessToken;

  // getter for reducer where we can call action.accessToken
  String get accessToken => this._accessToken;

  GetAuthAction(this._accessToken);
}
