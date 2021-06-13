import 'package:bloc/bloc.dart';
import '../userProfile/myAccountsScreen.dart';
import '../welcomeScreen.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  MyAccountClickedEvent,
}

abstract class NavigationStates {}

/// Class to permit navigation between the WelcomeScreen and the MyAccountsPage, without loosing the sidebar.
class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  //NavigationStates get initialState => MyAccountsPage();

  NavigationBloc() : super(WelcomeScreen());

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield WelcomeScreen();
        break;
      case NavigationEvents.MyAccountClickedEvent:
        yield MyAccountsPage();
        break;
    }
  }
}
