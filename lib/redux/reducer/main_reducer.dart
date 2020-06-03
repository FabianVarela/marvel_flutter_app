import 'package:marvel_flutter_app/redux/reducer/marvel_reducer.dart';
import 'package:marvel_flutter_app/redux/state/app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    characters: charactersReducer(state.characters, action),
  );
}
