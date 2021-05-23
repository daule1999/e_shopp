import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/home/categoryCarousel.dart';
import '../components/header.dart';
import '../components/home/gridItemList.dart';
import '../components/home/snapEffectCarousel.dart';
import '../components/sidebar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    bool showCartIcon = true;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      title: Text('Are you sure ?'),
                      content: Text('Do you want to exit an App'),
                      actions: <Widget>[
                        // ignore: deprecated_member_use
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('No',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        // ignore: deprecated_member_use
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Yes',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                        )
                      ],
                    ))) ??
            false;
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: header('Shop Mart', _scaffoldKey, showCartIcon, context),
          drawer: sidebar(context),
          body: Container(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    // Container(height: 80.0, child: CategoryCarousal()),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 20.0),
                      child: Center(
                        child: Text(
                          'New Arrivals',
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              fontFamily: 'NovaSquare'),
                        ),
                      ),
                    ),
                    Container(height: 420.0, child: SnapEffectCarousel()),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0, bottom: 15.0),
                      child: Center(
                        child: Text(
                          'Featured',
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              fontFamily: 'NovaSquare'),
                        ),
                      ),
                    ),
                  ]),
                ),
                GridItemList(),
              ],
            ),
          )),
    );
  }
}
