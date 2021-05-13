import 'package:bloc/bloc.dart';
import 'package:civic_points/EventListState.dart';
import 'package:civic_points/eventDetailsPage.dart';
import 'package:civic_points/ProjectOptionsCivicPoints.dart';
import 'package:civic_points/eventCreate.dart';
import 'package:flutter/material.dart';
import '../pages/myaccountspage.dart';
import '../WelcomeScreen.dart';

import '../pages/homepage.dart';
import '../signIn.dart';
import '../login.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  MyAccountClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  //NavigationStates get initialState => MyAccountsPage();

  NavigationBloc() : super(WelcomeScreen());


  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        //yield HomePage();
        yield WelcomeScreen();
        break;
      case NavigationEvents.MyAccountClickedEvent:
        yield MyAccountsPage();
        break;
    }
  }
}
