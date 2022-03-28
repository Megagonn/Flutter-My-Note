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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          // bottomNavigationBar: ,
          floatingActionButton: FloatingActionButton(onPressed: (){}),
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
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = Note.fromMap(snapshot.data[index]);
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
                                        border: Border(left: BorderSide(color: data.category.toLowerCase()=="work" ? Colors.green: Colors.purpleAccent, width: 4,),),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
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
                            );
                          },
                        ),
                      ],
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

class Input extends StatefulWidget {
  const Input({Key? key}) : super(key: key);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
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
                    cat = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Category",
                ),
                // ignore: prefer_const_literals_to_create_immutables
                items: [
                  DropdownMenuItem(
                    child: Text("Work"),
                    value: 'work',
                  ),
                  DropdownMenuItem(child: Text('Others'), value: 'others'),
                ],
                isExpanded: true,
              ),
              TextField(
                controller: textEditingController,
                onEditingComplete: () async {
                  // cont = textEditingController.value;
                  if (textEditingController.text != '') {
                    Note note = Note(
                      content: textEditingController.text,
                      category: cat,
                      date: dateFormat.format(DateTime.now()),
                    );
                    await DbModel.db.addData(note);
                    setState(() {
                      textEditingController.clear();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => UI()));
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: "Category",
                ),
                maxLines: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
