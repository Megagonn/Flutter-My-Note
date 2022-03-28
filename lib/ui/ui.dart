// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:notepad2/model/notemodel.dart';
import '../database/dbmodel.dart';
import 'package:intl/intl.dart';

class UI extends StatefulWidget {
  const UI({Key? key}) : super(key: key);

  @override
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  Key key = Key("ade");
  var dateFormat = DateFormat();
  var allData;
  datas() async {
    var datas = await DbModel.db.getData();
    allData = datas;
    return datas;
  }

  // String editText = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // textEditingController.text = editText;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          // bottomNavigationBar: ,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/inp');
            },
            child: Icon(Icons.add),
          ),
          appBar: AppBar(
            title: const Text("Note Pad"),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder(
              future: datas(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data != null) {
                  return AnimationLimiter(
                    // ignore: sized_box_for_whitespace
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        height: MediaQuery.of(context).size.height - 150,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = Note.fromMap(snapshot.data[index]);
                            // editText = data.content;
                            // setState(() {});
                            // var formattedDate =
                            // dateFormat.format(DateTime.now());
                            // var date = formattedDate.toString();
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                duration: Duration(seconds: 1),
                                curve: Curves.bounceInOut,
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  duration: Duration(seconds: 1),
                                  curve: Curves.bounceInOut,
                                  child: SwipeActionCell(
                                    key: ValueKey(allData[index]),
                                    trailingActions: [
                                      SwipeAction(
                                          nestedAction: SwipeNestedAction(
                                            ///customize your nested action content

                                            content: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.red,
                                              ),
                                              width: 130,
                                              height: 60,
                                              child: OverflowBox(
                                                maxWidth: double.infinity,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  // ignore: prefer_const_literals_to_create_immutables
                                                  children: [
                                                    const Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    ),
                                                    const Text('Del',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          ///you should set the default  bg color to transparent
                                          color: Colors.transparent,

                                          ///set content instead of title of icon
                                          content: _getIconButton(
                                              Colors.red, Icons.delete),
                                          onTap: (handler) async {
                                            allData.removeAt(index);
                                            setState(() {});
                                          }),
                                      SwipeAction(
                                          content: _getIconButton(Colors.grey,
                                              Icons.vertical_align_top),
                                          color: Colors.transparent,
                                          onTap: (handler) {}),
                                    ],
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: data.category
                                                        .toLowerCase() ==
                                                    "work"
                                                ? Colors.greenAccent
                                                : data.category.toLowerCase() ==
                                                        "school"
                                                    ? Colors.blueAccent
                                                    : data.category
                                                                .toLowerCase() ==
                                                            "uncategorised"
                                                        ? Colors.redAccent
                                                        : data.category
                                                                    .toLowerCase() ==
                                                                "coding"
                                                            ? Colors.tealAccent
                                                            : Colors
                                                                .purpleAccent,
                                            width: 4,
                                          ),
                                        ),
                                        // borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          // List searchData =
                                          //     await DbModel.db.getData();

                                          // var index = data.id;
                                          TextEditingController
                                              textEditingController =
                                              TextEditingController();
                                          // print(textEditingController.text);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return SafeArea(
                                                  child: Scaffold(
                                                    floatingActionButton:
                                                        FloatingActionButton(
                                                      onPressed: () async {
                                                        
                                                        if (textEditingController
                                                                .text !=
                                                            '') {
                                                        DbModel.db.updateDb(
                                                            Note(
                                                                content:
                                                                    textEditingController
                                                                        .text,
                                                                category: data
                                                                    .category,
                                                                date: dateFormat
                                                                    .format(DateTime
                                                                        .now())),
                                                            data.id!);
                                                          
                                                            setState(() {
                                                              textEditingController
                                                                  .clear();
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              UI()));
                                                            });
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons.send_outlined,
                                                      ),
                                                    ),
                                                    appBar: AppBar(),
                                                    body: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height,
                                                      child: Column(
                                                        children: [
                                                          TextField(
                                                            maxLines: null,
                                                            controller:
                                                                textEditingController,
                                                            decoration:
                                                                InputDecoration(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                          setState(() {
                                            // editText = data.content;
                                            textEditingController.text =
                                                data.content;
                                          });
                                        },
                                        child: ListTile(
                                          title: Text(data.content),
                                          subtitle: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(data.category),
                                              Text(data.date),
                                            ],
                                          ),
                                          style: ListTileStyle.drawer,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LinearProgressIndicator());
                } else {
                  return const Center(child: Text("No note"));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _getIconButton(color, icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),

        ///set you real bg color in your content
        color: color,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
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
