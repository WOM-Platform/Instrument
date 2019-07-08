import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instrument/src/screens/generate_wom/bloc.dart';
import 'package:instrument/src/utils.dart';

class AmountSelectionPage extends StatefulWidget {
  @override
  _AmountSelectionPageState createState() => _AmountSelectionPageState();
}

class _AmountSelectionPageState extends State<AmountSelectionPage> {
  GenerateWomBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<GenerateWomBloc>(context);
    final isValid = bloc.isValidAmount;
    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor:Theme.of(context).primaryColor,
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
                    "How many WOMs do you need?",
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
                    textInputAction: TextInputAction.go,
                    controller: bloc.amountController,
                    onChanged: (value) {
                      if (isValid != bloc.isValidAmount) {
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
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp("[0-9]")),
                    ],
                    keyboardType: TextInputType.number,
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
                      hintText: 'How many wom?',
                      errorText: isValid ? null : 'Value Can\'t Be 0',
                    ),
                  ),
                ),
//                SizedBox(
//                  height: 10.0,
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Text(
//                    lorem,
//                    style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 20.0,
//                        fontWeight: FontWeight.w500),
//                  ),
//                ),
                Spacer(),
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  height: 50.0,
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => bloc.goToPreviousPage(),
                    child: Text(
                      "Back",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: isValid
              ? FloatingActionButton(child: Icon(Icons.arrow_forward_ios),onPressed: () => bloc.goToNextPage())
              : null,
        ),
      ),
    );
  }
}
