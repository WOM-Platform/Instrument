import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instrument/src/screens/generate_wom/bloc.dart';
import 'package:instrument/src/screens/generate_wom/pages/aim_selection/aim_selection_page.dart';
import 'package:instrument/src/screens/generate_wom/pages/name_selection/name_selection.dart';
import 'package:instrument/src/screens/generate_wom/pages/pin_selection/pin_page.dart';
import 'package:instrument/src/screens/generate_wom/pages/position_selection/position_selection_page.dart';
import 'package:instrument/src/screens/generate_wom/pages/amount_selection/amount_selection_page.dart';
import 'package:instrument/src/screens/home/bloc.dart';
import 'package:instrument/src/screens/home/home_event.dart';

class GenerateWomScreen extends StatefulWidget {
  @override
  _GenerateWomScreenState createState() => _GenerateWomScreenState();
}

class _GenerateWomScreenState extends State<GenerateWomScreen> {
  int page = 0;
  GenerateWomBloc bloc;
  HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onWillPop() {
    if (bloc.pageController.page.round() == bloc.pageController.initialPage) {
      return Future.value(true);
    }
    bloc.goToPreviousPage();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<GenerateWomBloc>(context);
    homeBloc = BlocProvider.of<HomeBloc>(context);
    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: <Widget>[
              PageView(
                controller: bloc.pageController,
                physics: new NeverScrollableScrollPhysics(),
                children: <Widget>[
                  NameSelectionPage(),
                  AmountSelectionPage(),
                  AimSelectionPage(),
                  PositionSelectionPage(),
                  Page4(),
                ],
              ),
              Positioned(
                top: 5.0,
                right: 5.0,
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (bloc.pageController.page.round() != 0) {
                       showAlert(context);
                    }else{
                      Navigator.of(context).pop();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showAlert(BuildContext context) async {

    bool result = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
            ),
            new FlatButton(
              child: new Text("Si"),
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
            ),
          ],
        );
      },
    );


    if (result ?? false) {
      await bloc.saveDraftRequest();
      homeBloc.dispatch(LoadRequest());
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
