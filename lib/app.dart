import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instrument/src/blocs/home/bloc.dart';
import 'package:wom_package/wom_package.dart';
import 'src/screens/home/home.dart';
import 'src/screens/splash/splash.dart';

User user;

class App extends StatefulWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc authenticationBloc;
  HomeBloc homeBloc;

  UserRepository get userRepository => widget.userRepository;

  @override
  void initState() {
    homeBloc = HomeBloc();
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
    authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<AuthenticationBloc>(
            builder: (context) => authenticationBloc),
        BlocProvider<HomeBloc>(builder: (context) => homeBloc),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.green,
//          primaryColorDark: Color(0xFFF57C00),
//          primaryColorLight: Color(0xFFFFE0B2),
          accentColor: Colors.orange,
//          iconTheme: IconThemeData(color: Color(0xFF212121)),
//          primaryTextTheme: TextTheme(
//            title: TextStyle(
//              color: Color(0xFF212121),
//            ),
//
//          ),
//          dividerColor: Color(0xFFBDBDBD),
        ),
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationUninitialized) {
              return SplashScreen();
            }
            if (state is AuthenticationAuthenticated) {
              userRepository.readUser().then((res) => user = res);
              return HomeScreen();
            }
            if (state is AuthenticationUnauthenticated) {
              user = null;
              return LoginScreen(userRepository: userRepository);
            }
            return Container(
              child: Center(
                child: Text("Error screen"),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    homeBloc.dispose();
    authenticationBloc.dispose();
    super.dispose();
  }
}
