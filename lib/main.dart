import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notepad2/ui/ui.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:provider/provider.dart';
import '../provider/provider.dart';

void main() {
  try {
    if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      databaseFactory = databaseFactoryFfi;
    }
    // try {
    //   databaseFactory = databaseFactory;
    // } on Exception catch (e) {
    //   // TODO
    // }
  } on Exception catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(
        create: (context) => Prov(),
        // child: const MyApp(),
      ),],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // var prov = context.select((Prov myprov) => myprov);
    // prov.getData;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xffea8c55),
        primaryColorLight: const Color(0xfff5dd90),
      ),
      home: const UI(),
      routes: {
        "/inp": (context) {
          return const MyInput();
        }
      },

      // UI(),
    );
  }
}
