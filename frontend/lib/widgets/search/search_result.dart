import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_application_helper/widgets/search/application.dart';
import 'package:school_application_helper/widgets/search/high_school_info.dart';

class SearchResult extends StatefulWidget {
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  List<HighSchoolInfo> _schools = [];
  final TextEditingController _searchController = TextEditingController();

  Future<void> _searchSchools(String query) async {
    print('query: $query');
    // localhost => 10.0.2.2
    // cf. https://araramistudio.jimdo.com/2018/01/11/android%E3%81%AE%E3%82%A8%E3%83%9F%E3%83%A5%E3%83%AC%E3%83%BC%E3%82%BF%E3%83%BC%E3%81%8B%E3%82%89%E8%87%AA%E8%BA%AB%E3%81%AEpc-localhost-%E3%81%B8%E6%8E%A5%E7%B6%9A/
    final response = await http
        .get(Uri.parse('http://10.0.2.2:3000/search/highSchools?q=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> schoolListJson = json.decode(response.body);
      setState(() {
        _schools = schoolListJson
            .map((schoolJson) => HighSchoolInfo.fromJson(schoolJson))
            .toList();
      });
    } else {
      throw Exception('Failed to load schools');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(onPressed: () => {}, icon: const Icon(Icons.menu)),
                  Expanded(
                      child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                        hintText: '高校名を入力',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0)),
                  )),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _searchSchools(_searchController.text);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _schools.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                      title: Text(_schools[index].name),
                      subtitle: Text(_schools[index].prefecture),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Application(school: _schools[index])));
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
