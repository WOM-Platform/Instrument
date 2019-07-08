import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
            onTap: widget.requests[index].status == RequestStatus.COMPLETE
                ? () => goToDetails(index)
                : null,
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: CardRequest2(
                request: widget.requests[index],
                onDelete: () => onDelete(index),
                onEdit: () => onEdit(index),
                onDuplicate: () => onDuplicate(index),
              ),
              actions: <Widget>[
                MySlideAction(
                  icon: Icons.share,
                  color: Colors.green,
                  onTap: () => _showSnackBar(context, 'Share'),
                ),
                widget.requests[index].status == RequestStatus.COMPLETE
                    ? MySlideAction(
                  icon: Icons.control_point_duplicate,
                  color: Colors.indigo,
                  onTap: () => onDuplicate(index),
                )
                    : MySlideAction(
                  icon: Icons.edit,
                  color: Colors.orange,
                  onTap: () => onEdit(index),
                ),

              ],
              secondaryActions: <Widget>[
                MySlideAction(
                  icon: Icons.archive,
                  color: Colors.yellow,
                  onTap: () => _showSnackBar(context, 'Archive'),
                ),
                MySlideAction(
                  icon: Icons.delete,
                  color: Colors.red,
                  onTap: () => onDelete(index),
                ),
              ],
            ),
          );
        });

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

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
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
      builder:(context)=>  GenerateWomBloc(draftRequest: widget.requests[index]),
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

class MySlideAction extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final Color color;

  const MySlideAction({Key key, this.onTap, this.icon, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Card(
          color: color,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}


