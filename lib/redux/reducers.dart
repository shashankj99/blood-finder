import 'package:blood_finder/models/app_state.dart';
import 'package:blood_finder/redux/actions.dart';

AppState appReducer(state, action) {
  return AppState(
    accessToken: authReducer(state.accessToken, action)
  );
}

/*
 * Authentication reducer
 */
authReducer(accessToken, action) {
  if (action is GetAuthAction)
    return action.accessToken;

  return accessToken;
}
