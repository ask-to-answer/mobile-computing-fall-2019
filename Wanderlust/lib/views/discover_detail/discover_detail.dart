
import 'package:Wanderlust/data_models/user.dart';
import 'package:Wanderlust/views/discover_detail/rating_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Wanderlust/data_models/route.dart';
import 'package:Wanderlust/ui_elements/custom_button.dart';
import 'package:Wanderlust/ui_elements/image_scroller.dart';
import 'package:Wanderlust/ui_elements/route_info.dart';
import 'package:Wanderlust/util.dart';
import 'package:Wanderlust/views/current_hike/current_hike.dart';
import 'package:Wanderlust/views/edit_page/edit_page.dart';
import 'package:Wanderlust/views/master/master.dart';

class DiscoverDetail extends StatefulWidget {
  final Future<HikingRoute> route;
  final String heroTag;

  DiscoverDetail({Key key, @required this.route, this.heroTag})
   : super(key: key);

  @override
  State<DiscoverDetail> createState() {
    return _DiscoverDetailState();
  }
}

class _DiscoverDetailState extends State<DiscoverDetail> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: FloatingActionButton(
                heroTag: UUID(),
                backgroundColor: Theme.of(context).accentColor.withAlpha(200),
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back),
              )
            ),
          ),
          
          FutureBuilder(
            future: widget.route,
            builder: (c, snapshot) {
              //if hiking route not loaded or loaded woth error this shows appropiate message to user
              if (snapshot.connectionState != ConnectionState.done
                 || snapshot.hasError)
                return Container(
                  child: Center(
                    child: RouteInfo(route: widget.route, extended: false)
                  ),
                );

              //future is completed with data!
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: ImageScrollerWidget(
                        imageBuilder: () => snapshot.data.images,
                        heroTag: widget.heroTag==null?UUID():widget.heroTag,
                      )
                    ),
                    SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          CustomButton(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(8),
                            color: (CurrentHike.isActive||!User.isLoggedIn)?Colors.grey:Theme.of(context).accentColor,
                            text: "Start",
                            child: Icon(Icons.play_arrow, color:(CurrentHike.isActive||!User.isLoggedIn)?Colors.grey:Theme.of(context).accentColor, size: 18,),
                            onPressed: () {
                              if (CurrentHike.isActive) {
                                showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    content: Text("Please stop current active hike before starting a new one!"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Ok"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  )
                                );
                              } else if (!User.isLoggedIn) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("Ok"),
                                          onPressed: ()=>Navigator.pop(context),
                                        )
                                      ],
                                      content: Text("You must be logged in, in order to start a route!"),
                                    );
                                  }
                                );
                              } else {
                                Navigator.pop(context);
                                CurrentHike.setActiveWithRoute(snapshot.data);
                                MasterView.navigate(MasterView.CURRENT_HIKE);
                              }
                            },
                          ),
                          CustomButton(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(8),
                            color: User.isLoggedIn? Theme.of(context).accentColor: Colors.grey,
                            text: "Rate",
                            child: Icon(Icons.rate_review, color: User.isLoggedIn? Theme.of(context).accentColor: Colors.grey, size: 18,),
                            onPressed: () async {
                              if (!User.isLoggedIn) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("Ok"),
                                          onPressed: ()=>Navigator.pop(context),
                                        )
                                      ],
                                      content: Text("You must be logged in, in order to rate a route!"),
                                    );
                                  }
                                );
                                return;
                              }
                              await showRatingDialog(snapshot.data.routeID, context);
                              //update sum of rating when finished
                              setState(() {});
                            },
                          ),
                          CustomButton(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(8),
                            color:  User.isLoggedIn? Theme.of(context).accentColor: Colors.grey,
                            text: "Edit",
                            child: Icon(Icons.edit, color: User.isLoggedIn? Theme.of(context).accentColor: Colors.grey, size: 18,),
                            onPressed: () async {
                              if (!User.isLoggedIn) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("Ok"),
                                          onPressed: ()=>Navigator.pop(context),
                                        )
                                      ],
                                      content: Text("You must be logged in, in order to edit a route!"),
                                    );
                                  }
                                );
                                return;
                              }
                              HikingRoute route = await widget.route;
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HikeEditPage(oldroute: route)),
                              );
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                    RouteInfo(route: widget.route, extended: true,)
                  ],
                ),
              );
            }
          )          
        ].reversed.toList(),
      ),
    );
  }

}

