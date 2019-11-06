import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ux_prototype/data_models/route.dart';
import 'package:ux_prototype/ui_elements/buttom_navigation.dart';
import 'package:ux_prototype/ui_elements/route_map.dart';

class CurrentHike extends StatefulWidget {
  CurrentHike({Key key}) : super(key: key);

  @override
  State<CurrentHike> createState() => _CurrentHikeState();
}

class _CurrentHikeState extends State<CurrentHike> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: CircularProgressIndicator(),
          ),
          RouteMap(
            route: HikingRoute.fromID("id"),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                onPressed: null,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: Colors.green,
                child: const Icon(Icons.add_location, size: 36.0),
              ),
            ),
          ),
        ],
      ),
      
    );
  }

}
