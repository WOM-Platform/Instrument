import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:instrument/src/model/wom_request.dart';
import 'package:instrument/src/model/wom_request.dart';
import 'package:wom_package/wom_package.dart';

class CardRequest extends StatelessWidget {
  final WomRequest request;
  final Function onDelete;
  final Function onEdit;
  final Function onDuplicate;

  const CardRequest(
      {Key key, this.request, this.onDelete, this.onEdit, this.onDuplicate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
//      height: 200.0,
      child: Card(
        margin: const EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        color: request.status == RequestStatus.COMPLETE
            ? Colors.green
            : request.status == RequestStatus.DRAFT
                ? Colors.orange
                : Colors.red,
        child: Row(
//          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 10.0,
//              color: request.status == RequestStatus.COMPLETE
//                  ? Colors.green
//                  : request.status == RequestStatus.DRAFT
//                      ? Colors.orange
//                      : Colors.red,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MyRichText(
                    t1: 'ID: ',
                    t2: '#${request.id.toString()}',
                  ),
                  MyRichText(
                    t1: 'Name: ',
                    t2: request.name,
                  ),
                  MyRichText(
                    t1: 'Date: ',
                    t2: request.dateString,
                  ),
                  MyRichText(
                    t1: 'Amount:',
                    t2: request.amount.toString(),
                  ),
                  MyRichText(
                    t1: "Aim: ",
                    t2: request.aimName,
                  ),
                  MyRichText(
                    t1: "Password: ",
                    t2: request.password,
                  ),
                  MyRichText(
                    t1: "Position: ",
                    t2: "${request?.location?.latitude?.toStringAsFixed(2)},${request?.location?.longitude?.toStringAsFixed(2)}",
                  ),
                ],
              ),
            ),
            Expanded(child: Container(color: Colors.yellow,),),
            Container(
              color: Colors.white,
              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.share), onPressed: null),
                  IconButton(
                      icon: Icon(request.status == RequestStatus.COMPLETE
                          ? Icons.control_point_duplicate
                          : Icons.edit),
                      onPressed: request.status == RequestStatus.COMPLETE
                          ? onDuplicate
                          : onEdit),
                  IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyRichText extends StatelessWidget {
  final String t1;
  final String t2;

  const MyRichText({Key key, this.t1, this.t2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: t1,
        style: TextStyle(fontSize: 12.0, color: Colors.grey),
        children: <TextSpan>[
          TextSpan(
              text: t2, style: TextStyle(fontSize: 20, color: Colors.black)),
        ],
      ),
    );
  }
}

class CardRequest2 extends StatelessWidget {
  final WomRequest request;
  final Function onDelete;
  final Function onEdit;
  final Function onDuplicate;

  const CardRequest2(
      {Key key, this.request, this.onDelete, this.onEdit, this.onDuplicate})
      : super(key: key);

  /**/
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '${request.amount} WOM',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: request.status == RequestStatus.COMPLETE
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
//                  Expanded(
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.end,
//                      children: <Widget>[
//                        IconButton(
//                          icon: Icon(Icons.share, size: 20.0),
//                          onPressed: null,
//                        ),
//                        IconButton(
//                          icon: Icon(
//                            request.status == RequestStatus.COMPLETE
//                                ? Icons.control_point_duplicate
//                                : Icons.edit,
//                            size: 20.0,
//                          ),
//                          onPressed: request.status == RequestStatus.COMPLETE
//                              ? onDuplicate
//                              : onEdit,
//                        ),
//                        IconButton(
//                            icon: Icon(Icons.delete, size: 20.0),
//                            onPressed: onDelete),
//                      ],
//                    ),
//                  ),
//                  Hero(
//                    tag: Key(request.deepLink),
//                    child: QrImage(
//                      padding: EdgeInsets.all(0),
//                      data: request.deepLink,
//                      version: 4,
//                      size: 50.0,
//                    ),
//                  ),
                ],
              ),
              Divider(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  request.name,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              Row(
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
//                Spacer(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        ItemRow(t1: 'id ', t2: request.id.toString()),
                        ItemRow(t1: 'aim ', t2: request?.aim?.title ?? '-'),
                        ItemRow(t1: 'date ', t2: request.dateString),
                      ],
                    ),
                  ),
//                Spacer(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        ItemRow(t1: 'password ', t2: request?.password ?? '-'),
                        ItemRow(
                            t1: '- ',
                            t2: '-'),
                        ItemRow(
                            t1: 'bounding box ',
                            t2: request?.location?.toString() ??
                                '-'),
                      ],
                    ),
                  ),
//                Spacer(),
                ],
              ),
              SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemRow extends StatelessWidget {
  final String t1;
  final String t2;

  const ItemRow({Key key, this.t1, this.t2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
            child: AutoSizeText(
              ' $t1',
              style: TextStyle(color: Colors.grey),
              maxLines: 1,
              textAlign: TextAlign.end,
            )),
        Expanded(
            child: AutoSizeText(
              ' $t2',
              maxLines: 1,
              minFontSize: 9,
              stepGranularity: 0.1,
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
}
