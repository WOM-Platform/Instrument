import 'package:flutter/material.dart';
import 'package:instrument/src/model/wom_request.dart';
import 'package:instrument/src/screens/request_confirm/summary_request.dart';

class RequestDetails extends StatelessWidget {
  final WomRequest womRequest;

  const RequestDetails({Key key, this.womRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(womRequest.name),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SummaryRequest(
        womRequest: womRequest,
      ),
    );
  }
}
