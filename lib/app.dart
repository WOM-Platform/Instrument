import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/services/user_repository.dart';
import 'src/screens/home/bloc.dart';
import 'src/screens/home/home.dart';
import 'src/screens/login/authentication_bloc.dart';
import 'src/screens/splash/splash.dart';
import 'src/screens/login/authentication_event.dart';
import 'src/screens/login/authentication_state.dart';
import 'src/screens/login/login_indicator.dart';
import 'src/screens/login/login_screen.dart';

//class App extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return BlocProvider(
//      bloc: HomeBloc(),
//      child: MaterialApp(
//          theme: ThemeData(
//            primaryColor: Colors.green,
//            backgroundColor: Colors.red,
////        canvasColor: backgroundColor,
//          ),
//          home: SplashScreen(),
//          routes: {
////          '/': (context) => SplashScreen(),
////          '/home': (context) {
////            final homeProvider =
////                BlocProvider<HomeBloc>(child: HomeScreen(), bloc: HomeBloc());
////            return homeProvider;
////          },
////          '/generate': (context) {
////            return BlocProvider<GenerateWomBloc>(
////              child: GenerateWomScreen(),
////              bloc: GenerateWomBloc(),
////            );
////          },
////          '/intro': (context) {
////            return IntroScreen();
////          },
////          '/settings': (context) {
////            final settingsProvider = myBlocProvider.BlocProvider(
////                child: SettingsScreen(), bloc: SettingsBloc());
////            return settingsProvider;
////          },
//          }),
//    );
//  }
//}

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
        BlocProvider<AuthenticationBloc>(bloc: authenticationBloc),
        BlocProvider<HomeBloc>(bloc: homeBloc),
      ],
      child: MaterialApp(
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationUninitialized) {
              return SplashScreen();
            }
            if (state is AuthenticationAuthenticated) {
              return HomeScreen();
            }
            if (state is AuthenticationUnauthenticated) {
              return LoginScreen(userRepository: userRepository);
            }
//            if (state is AuthenticationLoading) {
//              return LoadingIndicator();
//            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    authenticationBloc.dispose();
    super.dispose();
  }
}
