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
import '../provider/provider.dart';
import 'package:provider/provider.dart';

class UI extends StatefulWidget {
  const UI({Key? key}) : super(key: key);

  @override
  _UIState createState() => _UIState();
}

///Search enabler
// bool isSearching() {
//   return !searchIt;
// }

///search result
List result = [];
bool isSearching = false;
TextEditingController textEditingController = TextEditingController();

class Prov extends ChangeNotifier {
  String? get getData => textEditingController.text;
  changeData() {
    print(getData);
    notifyListeners();
  }
}

class _UIState extends State<UI> {
  Key key = Key("ade");

  var items = <BottomNavItem>[
    BottomNavItem(title: 'Home', widget: Icon(Icons.home_outlined)),
    BottomNavItem(title: 'Add note', widget: Icon(Icons.add)),
    BottomNavItem(title: 'Category', widget: Icon(Icons.category_outlined)),
  ];

  var cIndex;

  // search(val) async {
  //   List datas = await DbModel.db.getData();
  //   var prov = context.select((Prov myProv) => myProv);
  //   var kist = datas.where((element) => element['content'].contains(val));
  //   setState(() {
  //     result.addAll(kist);
  //   });
  //   prov.changeData(result);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cIndex = 0;
    // var prov = context.select((Prov myprov) => myprov);
    // prov.getData;
    // Prov().
    // searchIt = true;
    // textEditingController.text = editText;
  }

  PageController pageController = PageController();
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    // var prov = context.select((Prov myprov) => myprov);
    // prov.getData;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        ///Bottom NavBar
        bottomNavigationBar: BottomAnimation(
          barHeight: 60,
          selectedIndex: cIndex,
          items: items,
          backgroundColor: Theme.of(context).backgroundColor,
          onItemSelect: (value) {
            setState(() {
              cIndex = value;
              pager(value);
            });
          },
          itemHoverColor: Theme.of(context).primaryColorLight,
          itemHoverColorOpacity: .2,
          activeIconColor: Colors.black,
          deActiveIconColor: Color.fromARGB(255, 0, 0, 0),
          barRadius: 30,
          textStyle: TextStyle(
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          itemHoverWidth: 135,
          itemHoverBorderRadius: 30,
        ),

        ///AppBar
        appBar: AppBar(
          title: const Text("Note Pad"),
          backgroundColor: Theme.of(context).backgroundColor,

          ///actions
          actions: [
            isSearching
                ? SizedBox(
                    height: 30,
                    width: 140,
                    child: TextField(
                      controller: textEditingController,
                      onChanged: (value) {
                        setState(() {
                          Prov().changeData();
                        });
                      },
                      decoration: InputDecoration(
                          filled: true,
                          // fillColor: Color(0xfff5dd90),
                          hintText: 'Search'),
                    ),
                  )
                : SizedBox.shrink(),
            IconButton(
                onPressed: () {
                  setState(() {
                    cIndex = 0;
                    currentIndex = 0;
                    isSearching = !isSearching;
                    textEditingController.clear();
                  });
                },
                icon: Icon(isSearching ? Icons.close : CupertinoIcons.search))
          ],
        ),

        ///Body
        body: SafeArea(
          child: PageView(
            controller: pageController,
            physics: const ScrollPhysics(),
            onPageChanged: (val) {
              setState(() {
                currentIndex = val;
                pageController.jumpToPage(val);
              });
            },
            children:const [Home(), MyInput(), Category()],
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

// returnResult() {
//   // print('this is result $result');
//   return result;
// }

class MyInput extends StatefulWidget {
  const MyInput({Key? key}) : super(key: key);

  @override
  _MyInputState createState() => _MyInputState();
}

class _MyInputState extends State<MyInput> {
  var cat;
  var cont;
  var addNote;
  TextEditingController textEditingController = TextEditingController();
  var dateFormat = DateFormat();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          // padding: EdgeInsets.all(20),
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
                  border: InputBorder.none,
                  icon: Icon(Icons.category, color: const Color(0xffea8c55)),
                  hintText: "Select category",
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
                // isExpanded: true,
              ),
              TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: "Add note...",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(5 )
                ),
                maxLines: null,
                minLines: 8,
                
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (textEditingController.text.trim() != '') {
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

class Search extends StatefulWidget {
  const Search({Key? key, required this.list}) : super(key: key);
  final dynamic list;
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  data() async {
    var datase = await DbModel.db.getData();
    allData = datase;
    return datase;
  }

  @override
  Widget build(BuildContext context) {
    // var listen = context.watch<Prov>().result ?? '';
    // print(listen.getData);
    // listen.changeData(result);
    // var kist = datas.where((element) => element['content'].contains(val));
    // var word = textEditingController.text;
    // List list = word.isEmpty
    //     ? widget.list
    //     : widget.list.where((element) => element['content'].contains(word));
    // print([list, word]);
    // return list.isNotEmpty
    //     ? Container(
    //         height: MediaQuery.of(context).size.height - 150,
    //         child: ListView.builder(
    //           shrinkWrap: true,
    //           itemCount: list.length,
    //           itemBuilder: (BuildContext context, int index) {
    //             var data = Note.fromMap(list[index]);
    //             return Container(
    //               decoration: BoxDecoration(
    //                 border: Border(
    //                   left: BorderSide(
    //                     color: data.category.toLowerCase() == "work"
    //                         ? Colors.greenAccent
    //                         : data.category.toLowerCase() == "school"
    //                             ? Colors.blueAccent
    //                             : data.category.toLowerCase() == "uncategorised"
    //                                 ? Colors.redAccent
    //                                 : data.category.toLowerCase() == "coding"
    //                                     ? Colors.tealAccent
    //                                     : Colors.purpleAccent,
    //                     width: 4,
    //                   ),
    //                 ),
    //                 // borderRadius: BorderRadius.circular(10),
    //               ),
    //               child: ListTile(
    //                 onTap: (() {
    //                   setState(() {
    //                     // editData = data.content.toString();
    //                     // print(data.id);
    //                     editData = {
    //                       'content': data.content,
    //                       'category': data.category,
    //                       'id': data.id,
    //                       'date': data.date,
    //                     };
    //                   });
    //                   Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) {
    //                         // editData = data.content;
    //                         return Edit();
    //                       },
    //                     ),
    //                   );
    //                 }),
    //                 title: Text(data.content),
    //                 subtitle: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(data.category),
    //                     Text(data.date),
    //                   ],
    //                 ),
    //                 style: ListTileStyle.drawer,
    //               ),
    //             );
    //           },
    //         ),
    //       )
    //     : const Center(
    //         child: Text('No match'),
    //       );
    // return Center(
    //   child: Text('data'),
    // );

    return FutureBuilder(
        future: data(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
            // return SizedBox.shrink();
          } else {
            List data = snapshot.data;
            var word = context.watch<Prov>().getData!.toLowerCase();
            print(word);
            var list = word.isEmpty
                ? snapshot.data
                : data
                    .where((element) =>
                        element['content'].toString().contains(word))
                    .toList();
            // print(list);
            return Container(
              height: MediaQuery.of(context).size.height - 150,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  var data = Note.fromMap(list[index]);
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: data.category.toLowerCase() == "work"
                              ? Colors.greenAccent
                              : data.category.toLowerCase() == "school"
                                  ? Colors.blueAccent
                                  : data.category.toLowerCase() ==
                                          "uncategorised"
                                      ? Colors.redAccent
                                      : data.category.toLowerCase() == "coding"
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data.category),
                          Text(data.date),
                        ],
                      ),
                      style: ListTileStyle.drawer,
                    ),
                  );
                },
              ),
            );
          }
        });
  }
}
