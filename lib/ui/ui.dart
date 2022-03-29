// ignore_for_file: prefer_const_constructors

import 'package:bottom_animation/bottom_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:notepad2/model/notemodel.dart';
import 'package:notepad2/ui/utilities.dart';
import '../database/dbmodel.dart';
import 'package:intl/intl.dart';

class UI extends StatefulWidget {
  const UI({Key? key}) : super(key: key);

  @override
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  Key key = Key("ade");

  var items = <BottomNavItem>[
    BottomNavItem(title: 'Home', widget: Icon(Icons.home_outlined)),
    BottomNavItem(title: 'Add note', widget: Icon(Icons.add)),
    BottomNavItem(title: 'Category', widget: Icon(Icons.category_outlined)),
  ];

  var cIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cIndex = 0;
    // textEditingController.text = editText;
  }

  PageController pageController = PageController();
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomAnimation(
            selectedIndex: cIndex,
            items: items,
            backgroundColor: Color(0xffea8c55),
            onItemSelect: (value) {
              setState(() {
                cIndex = value;
                pager(value);
              });
            },
            itemHoverColor: Color(0xfff5dd90),
            itemHoverColorOpacity: .5,
            activeIconColor: Colors.black,
            deActiveIconColor: Colors.black38,
            barRadius: 30,
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            itemHoverWidth: 135,
            itemHoverBorderRadius: 30,
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/inp');
          //   },
          //   child: Icon(Icons.add),
          // ),
          appBar: AppBar(
            title: const Text("Note Pad"),
          ),
          body: PageView(
            controller: pageController,
            onPageChanged: (val) {
              setState(() {
                currentIndex = val;
                pageController.jumpToPage(val);
              });
            },
            children: [Home(), MyInput(), Category()],
          ),
        ),
      ),
    );
  }
  void pager(index) {
    setState(() {
      currentIndex = index;
      pageController.jumpToPage(index);
    });
  }
}

var cat;
var cont;
var addNote;

class MyInput extends StatefulWidget {
  const MyInput({Key? key}) : super(key: key);

  @override
  _MyInputState createState() => _MyInputState();
}

class _MyInputState extends State<MyInput> {
  TextEditingController textEditingController = TextEditingController();
  var dateFormat = DateFormat();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity / 2,
          child: Column(
            children: [
              // ignore: prefer_const_literals_to_create_immutables
              DropdownButtonFormField(
                onChanged: (val) {
                  setState(() {
                    val == null ? cat = "Uncategorised" : cat = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Category",
                ),
                // ignore: prefer_const_literals_to_create_immutables
                items: [
                  DropdownMenuItem(
                    child: Text("Work"),
                    value: 'Work',
                  ),
                  DropdownMenuItem(
                    child: Text('School'),
                    value: 'School',
                  ),
                  DropdownMenuItem(
                    child: Text("Coding"),
                    value: 'Coding',
                  ),
                  DropdownMenuItem(child: Text('Others'), value: 'Others'),
                ],
                isExpanded: true,
              ),
              TextField(
                controller: textEditingController,
                onChanged: (val) {
                  // cont = textEditingController.value;
                },
                decoration: InputDecoration(
                  hintText: "Note...",
                ),
                maxLines: 10,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (textEditingController.text != '') {
              Note note = Note(
                content: textEditingController.text,
                category: cat,
                date: dateFormat.format(DateTime.now()),
              );
              await DbModel.db.addData(note);
              // addNote = note;
              setState(() {
                textEditingController.clear();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => UI()));
              });
            }
          },
          child: Icon(
            Icons.send_outlined,
          ),
        ),
      ),
    );
  }
}
