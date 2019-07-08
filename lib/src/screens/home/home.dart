
import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instrument/src/blocs/home/bloc.dart';
import 'package:instrument/src/screens/generate_wom/bloc.dart';
import 'package:instrument/src/screens/generate_wom/generate_wom.dart';
import 'package:instrument/src/screens/home/widgets/home_list.dart';
import 'package:wom_package/wom_package.dart';

import '../../../app.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc bloc;
  ScrollController _scrollViewController;
  GenerateWomBloc _generateWomBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Home build()");
    bloc = BlocProvider.of<HomeBloc>(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor,
        systemNavigationBarColor: Theme.of(context).primaryColor,
//        systemNavigationBarDividerColor: Colors.red,
//        systemNavigationBarIconBrightness: Brightness.dark,
//        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      )
    );

    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
//      appBar: AppBar(
//        title: Text("HOME",style: TextStyle(color: Colors.white),),
//        actions: <Widget>[
//          IconButton(
//            color: Colors.white,
//            icon: Icon(Icons.exit_to_app),
//            onPressed: () => authenticationBloc.dispatch(
//                  LoggedOut(),
//                ),
//          ),
//        ],
//      ),
      body:Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Arc(
              child: Container(
                color: Theme.of(context).primaryColor,
                height: MediaQuery.of(context).size.height / 2 - 50,
              ),
              height: 50,
            ),
          ),
          NestedScrollView(
            controller: _scrollViewController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  title: new Text('WOM POS'),
                  centerTitle: true,
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () => authenticationBloc.dispatch(
                        LoggedOut(),
                      ),
                    ),
//                    IconButton(
//                        icon: Icon(Icons.close),
//                        onPressed: () {
//                          AppDatabase.get().closeDatabase();
//                        },),
                  ],
                ),
              ];
            },
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
                      child: Text("No payment requests"),
                    );
                  }
                  return HomeList(
                    requests: state.requests,
                  );
                }

                return Container(
                  child: Center(child: Text("Error screen")),
                );
              },
            ),
          ),
        ],
      ),
//      body: BlocBuilder(
//        bloc: bloc,
//        builder: (BuildContext context, HomeState state) {
//          if (state is RequestLoading) {
//            return Center(
//              child: CircularProgressIndicator(),
//            );
//          }
//
//          if (state is RequestLoaded) {
//            if (state.requests.isEmpty) {
//              return Center(
//                child: Text("There aren't requests"),
//              );
//            }
//            return HomeList(
//              requests: state.requests,
//            );
//          }
//
//          return Container(child: Center(child: Text("Error screen")),);
//        },
//      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color:Colors.white),
        onPressed: () async {
          print(user.publicKey);
          final provider = BlocProvider(
            child: GenerateWomScreen(),
            builder:(context)=> GenerateWomBloc(draftRequest: null),
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
    super.dispose();
  }
}
