import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:instrument/src/model/wom_request.dart';
import 'package:instrument/src/screens/request_confirm/request_confirm.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SummaryRequest extends StatelessWidget {
  final WomRequest womRequest;

  const SummaryRequest({Key key, this.womRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print(womRequest.deepLink);


    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
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
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Text(paymentRequest.dateTime
//                            .toIso8601String()
//                            .substring(0, 10),style: TextStyle(color: Colors.white),),
//                      ),
////                      Padding(
////                        padding: const EdgeInsets.all(8.0),
////                        child: Text("id ${paymentRequest.id}"),
////                      ),
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Text(paymentRequest.aimName ?? ""),
//                      ),
//
//                    ],
//                  ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: "${womRequest.amount} ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: "WOM",
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: height/2.5,
                  width: height/2.5,
                  child: Card(
                    child: QrImage(
                      padding: const EdgeInsets.all(20.0),
                      data: womRequest.deepLink,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'PIN ',
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Theme.of(context).primaryColor),
                      children: <TextSpan>[
                        TextSpan(
                            text: womRequest.password,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 80.0,),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      OutlineButton(
//                          child: Text('Duplicate'),
//                          onPressed: () {
//                            Navigator.of(context).pushReplacement(
//                              MaterialPageRoute(
//                                builder: (ctx) => RequestConfirmScreen(
//                                  paymentRequest: paymentRequest.copyFrom(),
//                                ),
//                              ),
//                            );
//                          }),
//                      OutlineButton.icon(
//                        color: Colors.white,
//                        splashColor: Colors.blue,
//                        highlightedBorderColor: Colors.green,
//                        disabledBorderColor: Colors.red,
//                        highlightColor: Colors.yellow,
//                        textColor: Colors.purple,
//                        highlightElevation: 4,
//                        onPressed: () {
//                          Navigator.of(context).pop();
//                        },
//                        icon: Icon(Icons.check),
//                        label: Text('Home'),
//                      ),
//                    ],
//                  ),
//                  Spacer(),
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => RequestConfirmScreen(
                    womRequest: womRequest.copyFrom(),
                  ),
                ),
              );
            },
            label: Text('Duplicate')),
      ),
    );

    /*return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("#${womRequest.id}"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(womRequest.aimName),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        womRequest.dateTime.toIso8601String().substring(0, 10)),
                  ),
                ],
              ),
              Spacer(),
              RichText(
                text: TextSpan(
                  text: "${womRequest.amount} ",
                  style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: "WOM",
                        style: TextStyle(fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              Container(
                height: 300.0,
                width: 300.0,
                child: Card(
                  child: QrImage(
                    padding: const EdgeInsets.all(30.0),
                    data: womRequest.deepLink,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Pin ',
                  style: TextStyle(fontSize: 30.0, color: Colors.red),
                  children: <TextSpan>[
                    TextSpan(
                        text: womRequest.password,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OutlineButton(
                      child: Text('Duplica'),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (ctx) => RequestConfirmScreen(
                                  womRequest: womRequest.copyFrom(),
                                ),
                          ),
                        );
                      }),
                  OutlineButton.icon(
                    color: Colors.white,
                    splashColor: Colors.blue,
                    highlightedBorderColor: Colors.green,
                    disabledBorderColor: Colors.red,
                    highlightColor: Colors.yellow,
                    textColor: Colors.purple,
                    highlightElevation: 4,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.check),
                    label: Text('Torna alla home'),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );*/
  }
}
