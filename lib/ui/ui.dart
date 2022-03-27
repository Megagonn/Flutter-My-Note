import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../database/dbmodel.dart';

class UI extends StatefulWidget {
  const UI({Key? key}) : super(key: key);

  @override
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Note Pad"),
          ),
          body: SingleChildScrollView(
            child: FutureBuilder(
              builder: DbModel.db.getData(),
            ),
          ),
        ),
      ),
    );
  }
}
