import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instrument/src/screens/generate_wom/bloc.dart';
import 'package:instrument/src/utils.dart';

class NameSelectionPage extends StatefulWidget {
  @override
  _NameSelectionPageState createState() => _NameSelectionPageState();
}

class _NameSelectionPageState extends State<NameSelectionPage> {
  GenerateWomBloc bloc;

  @override
  Widget build(BuildContext context) {
    print("NameSelectionPage build");
    bloc = BlocProvider.of<GenerateWomBloc>(context);

    final isValid = bloc.isValidName;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).primaryColor,
//        backgroundColor:Colors.gre,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Generation request name",
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: bloc.nameController,
                  textInputAction: TextInputAction.go,
                  onChanged: (value) {
                    if (isValid != bloc.isValidName) {
                      setState(() {});
                    }
                  },
                  onEditingComplete: () {
                    print("onEditingComplete");
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    if (isValid) {
                      bloc.goToNextPage();
                    }
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    errorStyle: TextStyle(color: Colors.yellow),
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(),
                    hintText: 'What is the request name?',
                    errorText: isValid ? null : 'Name too short',
                  ),
                ),
              ),
//              SizedBox(
//                height: 10.0,
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  "Examples: \n\n- Discount 10%\n\n- Student free ride\n\n- Free parking",
//                  style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 20.0,
//                      fontWeight: FontWeight.w500),
//                ),
//              ),
//              SizedBox(
//                height: 50.0,
//              ),
            ],
          ),
        ),
        floatingActionButton: isValid
            ? FloatingActionButton(
                child: Icon(Icons.arrow_forward_ios),
                onPressed: () => bloc.goToNextPage())
            : null,
      ),
    );
  }
}
