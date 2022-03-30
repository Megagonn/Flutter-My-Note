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

///Search enabler
var searchIt = true;
bool isSearching() {
  return !searchIt;
}

///search result
var result;

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
    // searchIt = true;
    // textEditingController.text = editText;
  }

  TextEditingController textEditingController = TextEditingController();
  PageController pageController = PageController();
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xffea8c55),
        primaryColorLight: Color(0xfff5dd90),
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          ///Bottom NavBar
          bottomNavigationBar: BottomAnimation(
            selectedIndex: cIndex,
            items: items,
            backgroundColor: Color.fromARGB(255, 247, 185, 185),
            onItemSelect: (value) {
              setState(() {
                cIndex = value;
                pager(value);
              });
            },
            itemHoverColor: Color(0xfff5dd90),
            itemHoverColorOpacity: .5,
            activeIconColor: Colors.black,
            deActiveIconColor: Color.fromARGB(255, 0, 0, 0),
            barRadius: 30,
            textStyle: TextStyle(
              color: Color.fromARGB(255, 124, 115, 115),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            itemHoverWidth: 135,
            itemHoverBorderRadius: 30,
          ),

          ///AppBar
          appBar: AppBar(
            title: const Text("Note Pad"),

            ///actions
            actions: [
              isSearching()
                  ? SizedBox(
                      width: 140,
                      child: TextField(
                        controller: textEditingController,
                        onEditingComplete: () {
                          setState(() {
                            searchIt = true;
                            isSearching();
                            search(textEditingController.text);
                            // result;
                            returnResult();
                          });
                          textEditingController.clear();
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xfff5dd90),
                            hintText: 'search'),
                      ),
                    )
                  : SizedBox(),
              IconButton(
                  onPressed: () {
                    setState(() {
                      searchIt = false;
                      isSearching();
                    });
                  },
                  icon: Icon(CupertinoIcons.search))
            ],
          ),

          ///Body
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

search(val) async {
  List datas = await DbModel.db.getData();
  result = datas;
  return val == null
      ? datas
      : datas
          .retainWhere((element) => element.content.toString().contains(val));
  // return datas;
}

returnResult() {
  return result;
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
                maxLines: 15,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (textEditingController.text != '') {
              Note note = Note(
                content: textEditingController.text.trim(),
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
