import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  CustomWidget({
    Key key,
    this.title,
    this.sub1,
    this.sub2,
//    this.status,
    this.trailing,
  }) : super(key: key);

  final String title;
  final String sub1;
  final String sub2;
//  final String status;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {


    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(children: <Widget>[
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18.0),
              ), //Text

              const Padding(padding: EdgeInsets.only(bottom: 2.0)),

              Text(
                '$sub1 · $sub2',
                maxLines: 1,
                style: TextStyle(color: Colors.grey, fontSize: 15.0),
              ),

//              Text(
//                '$status',
//                style: TextStyle(fontSize: 15.0),
//              )
            ],
          ), //Column
    ),

              trailing,





//          Column(
//            children: <Widget>[
//            Row(
//              children: <Widget>[
//                 trailing
//              ],
//            )
//          ])
       ])
        );
  } //build()

}
