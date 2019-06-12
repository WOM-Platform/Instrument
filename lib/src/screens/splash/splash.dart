import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instrument/src/screens/home/bloc.dart';
import 'package:instrument/src/screens/home/home.dart';
import 'package:instrument/src/screens/login/login_screen.dart';
import 'package:instrument/src/screens/splash/bloc.dart';

class SplashScreen extends StatelessWidget {
  final SplashBloc _bloc = SplashBloc();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocListener(
        bloc: _bloc,
        listener: (context, state) {
          if (state == SplashState.END) {
//          Navigator.of(context).pushReplacementNamed('/home');
//          final homeProvider = BlocProvider<HomeBloc>(child: HomeScreen(), bloc: HomeBloc());
//            Navigator.of(context).pushReplacement(
//                MaterialPageRoute(builder: (_) => LoginScreen()));
          }
        },
        child: BlocBuilder(
          bloc: _bloc,
          builder: (context, splashState) {
            print("builder state: $splashState");
            if (splashState == SplashState.START) {
              return Center(
                child: Text(
                  "INSTRUMENT",
                  style: TextStyle(color: Colors.green, fontSize: 50.0),
                ),
              );
            }
            if (splashState == SplashState.LOADING) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
