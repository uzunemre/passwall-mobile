import 'package:Passwall/utils/objects.dart';
import 'package:Passwall/widgets/create_fab_widget.dart';
import 'package:Passwall/widgets/detail_widget.dart';
import 'package:Passwall/widgets/list_widget.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:Passwall/pages/about_page.dart';
import 'package:Passwall/utils/antenna.dart';
import 'package:Passwall/localization/localization.dart';
import 'package:Passwall/pages/login_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Credential selectedValue;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("PassWall", style: TextStyle(fontFamily: "serif", fontWeight: FontWeight.w900)),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 0, child: Text(AppLocalizations.of(context).trans('import'))),
              PopupMenuItem(value: 1, child: Text(AppLocalizations.of(context).trans('export'))),
              PopupMenuItem(value: 2, child: Text(AppLocalizations.of(context).trans('about'))),
              PopupMenuItem(value: 3, child: Text(AppLocalizations.of(context).trans('logout'), style: TextStyle(color: Colors.red))),
            ],
            onSelected: (value) async {
              switch (value) {
                case 0:
                  {
                    File file;
                    file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['csv']);
                    await Antenna().import(file);
                    setState(() {});
                    //TODO: Add a snackbar
                    break;
                  }
                case 1:
                  {
                    Antenna().export();
                    break;
                  }
                case 2:
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => new AboutPage()));
                    break;
                  }
                case 3:
                  {
                    print("Loging out");
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    preferences.remove("token");
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new LoginPage()));
                  }
              }
            },
          )
        ],
      ),
      body: Row(
        children: <Widget>[
          Material(
            elevation: 4,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ListWidget(onItemSelected: (value) {
                setState(() {
                  selectedValue = value;
                });
              }),
            ),
          ),
          Expanded(
            child: DetailWidget(selectedValue),
          )
        ],
      ),
      floatingActionButton: FABWidget(hasAdded),
    );
  }

  hasAdded(data) {
    if (data) {
      setState(() {});
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).trans('success_added')))
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).trans('swr')))
      );
    }
  }
}
