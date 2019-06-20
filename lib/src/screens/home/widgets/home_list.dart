import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instrument/src/blocs/home/bloc.dart';
import 'package:instrument/src/model/wom_request.dart';
import 'package:instrument/src/screens/generate_wom/bloc.dart';
import 'package:instrument/src/screens/generate_wom/generate_wom.dart';
import 'package:instrument/src/screens/home/widgets/card_request.dart';
import 'package:instrument/src/screens/request_confirm/request_confirm.dart';
import 'package:instrument/src/screens/request_datails/request_datail.dart';
import 'package:wom_package/wom_package.dart';


class HomeList extends StatefulWidget {
  final List<WomRequest> requests;

  HomeList({Key key, this.requests}) : super(key: key);

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  HomeBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<HomeBloc>(context);
    return ListView.builder(
        itemCount: widget.requests.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: widget.requests[index].status == RequestStatus.COMPLETE ? () => goToDetails(index) : null,
            child: CardRequest(
              request: widget.requests[index],
              onDelete: () => onDelete(index),
              onEdit: () => onEdit(index),
              onDuplicate: () => onDuplicate(index),
            ),
          );
        });
  }

  goToDetails(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RequestDetails(
              womRequest: widget.requests[index],
            ),
      ),
    );
  }

  onDuplicate(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RequestConfirmScreen(
              womRequest: widget.requests[index].copyFrom(),
            ),
      ),
    );
  }

  onEdit(int index) {
    final provider = BlocProvider(
      child: GenerateWomScreen(),
      bloc: GenerateWomBloc(draftRequest: widget.requests[index]),
    );
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => provider));
  }

  onDelete(int index) async {
    debugPrint("onDelete");
    final result = await bloc.deleteRequest(widget.requests[index].id);
    debugPrint("onDelete from DB complete: $result");
    if (result > 0) {
      setState(() {
        widget.requests.removeAt(index);
      });
    }
  }
}
