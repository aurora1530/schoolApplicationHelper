import 'package:flutter/material.dart';
import 'package:school_application_helper/widgets/main_header.dart';
import 'package:school_application_helper/widgets/search/search_result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Application Helper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const SchoolApplicationHelper(title: '高校出願情報検索'),
    );
  }
}

class SchoolApplicationHelper extends StatefulWidget {
  const SchoolApplicationHelper({super.key, required this.title});

  final String title;

  @override
  State<SchoolApplicationHelper> createState() =>
      _SchoolApplicationHelperState();
}

class _SchoolApplicationHelperState extends State<SchoolApplicationHelper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainHeader(title: widget.title),
      body: SearchResult(),
    );
  }
}
