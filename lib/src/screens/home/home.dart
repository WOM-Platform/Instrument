import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instrument/src/model/wom_request.dart';
import 'package:instrument/src/screens/generate_wom/bloc.dart';
import 'package:instrument/src/screens/generate_wom/generate_wom.dart';
import 'package:instrument/src/screens/home/bloc.dart';
import 'package:instrument/src/screens/home/home_event.dart';
import 'package:instrument/src/screens/home/widgets/home_list.dart';
import 'package:instrument/src/screens/home/home_state.dart';
import 'package:instrument/src/screens/login/authentication_bloc.dart';
import 'package:instrument/src/screens/login/authentication_event.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc bloc;
  GenerateWomBloc _generateWomBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Home build()");
    bloc = BlocProvider.of<HomeBloc>(context);

    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => authenticationBloc.dispatch(
                  LoggedOut(),
                ),
          ),
        ],
      ),
      body: BlocBuilder(
        bloc: bloc,
        builder: (BuildContext context, HomeState state) {
          if (state is RequestLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is RequestLoaded) {
            if (state.requests.isEmpty) {
              return Center(
                child: Text("There aren't requests"),
              );
            }
            return HomeList(
              requests: state.requests,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final provider = BlocProvider(
            child: GenerateWomScreen(),
            bloc: GenerateWomBloc(draftRequest: null),
          );
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => provider));
          debugPrint("return to the home");
        },
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
