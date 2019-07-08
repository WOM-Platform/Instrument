import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instrument/src/screens/generate_wom/bloc.dart';

import 'package:instrument/src/screens/generate_wom/pages/aim_selection/bloc.dart';
import 'package:instrument/src/screens/generate_wom/pages/aim_selection/select_aim.dart';
import 'package:instrument/src/utils.dart';

class AimSelectionPage extends StatefulWidget {
  @override
  _AimSelectionPageState createState() => _AimSelectionPageState();
}

class _AimSelectionPageState extends State<AimSelectionPage> {
  GenerateWomBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<GenerateWomBloc>(context);
    final isValid = bloc.isValidAim;
    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).primaryColor,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "What\'s the AIM?",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                SelectAim(
                  bloc: bloc.aimSelectionBloc,
                  updateState: (){
                    if(isValid != bloc.isValidAim)
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Select the AIM of the WOMs being generated",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),

              ],
            ),
          ),
          floatingActionButton:  isValid
              ? FloatingActionButton(
              child: Icon(Icons.arrow_forward_ios),
              onPressed: () => bloc.goToNextPage())
              : null,
        ),
      ),
    );
  }
}
