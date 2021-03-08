import 'package:meta/meta.dart';

@immutable
class AppState {
  final String accessToken;

  AppState({@required this.accessToken});

  factory AppState.initial() {
    return AppState(accessToken: null);
  }
}