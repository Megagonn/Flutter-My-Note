import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:intl/intl.dart';

import '../database/dbmodel.dart';
import '../model/notemodel.dart';
import 'ui.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

// var data;
var dateFormat = DateFormat();
var editData;

var allData;

class _HomeState extends State<Home> {
  TextEditingController textEditingController = TextEditingController();
  data() async {
    var datase = await DbModel.db.getData();
    allData = datase;
    return datase;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: data(),
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
                          // editText = data.content;
                          var data = Note.fromMap(snapshot.data[index]);

                          // print(editData);
                          // setState(() {

                          // });
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
                                curve: Curves.bounceIn,
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
                                          await handler(true);
                                          DbModel.db.delData(data.id!);
                                          setState(() {});
                                        }),
                                    // SwipeAction(
                                    //     content: _getIconButton(Colors.grey,
                                    //         Icons.vertical_align_top),
                                    //     color: Colors.transparent,
                                    //     onTap: (handler) {}),
                                  ],
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: data.category.toLowerCase() ==
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
                                                          : Colors.purpleAccent,
                                          width: 4,
                                        ),
                                      ),
                                      // borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      onTap: (() {
                                        setState(() {
                                          // editData = data.content.toString();
                                          // print(data.id);
                                          editData = {
                                            'content': data.content,
                                            'category': data.category,
                                            'id': data.id,
                                            'date': data.date,
                                          };
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              // editData = data.content;
                                              return Edit();
                                            },
                                          ),
                                        );
                                      }),
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

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    // print(editData);
    // print(editData[0].content);
    // print(editData[1]);
    // print(allData);
    textEditingController.text = editData['content'];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (textEditingController.text != '') {
              DbModel.db.updateDb(
                  Note(
                      content: textEditingController.text,
                      category: editData['category'],
                      date: dateFormat.format(DateTime.now())),
                  editData['id']);

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
        appBar: AppBar(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              TextField(
                maxLines: null,
                controller: textEditingController,
                // decoration: InputDecoration(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Category extends StatelessWidget {
  const Category({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Category')
        // ),
        body: Container(
          child: Text('Categories...'),
        ),
      ),
    );
  }
}
