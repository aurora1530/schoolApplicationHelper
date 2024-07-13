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
  int _currentPage = 1;
  int _pageCount = 0;
  int _schoolCount = 0;
  List<HighSchoolInfo> _schools = [];
  final TextEditingController _searchController = TextEditingController();

  Future<void> _fetchSchools(String query, int page) async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:3000/search/highSchools?q=$query&page=$page'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> schoolListJson = json.decode(response.body);
      final List<dynamic> schools = schoolListJson['schools'];
      setState(() {
        _schoolCount = schoolListJson['count'];
        _pageCount = schoolListJson['pageCount'];
        _currentPage = page;
        _schools = schools
            .map((schoolJson) => HighSchoolInfo.fromJson(schoolJson))
            .toList();
      });
    } else {
      throw Exception('Failed to load schools');
    }
  }

  void _resetSearch() {
    _searchController.clear();
    setState(() {
      _schools = [];
      _currentPage = 1;
      _pageCount = 0;
      _schoolCount = 0;
    });
  }

  void _handleSearch(String query, int page) {
    if (query.isEmpty) {
      _resetSearch();
    } else {
      _fetchSchools(query, page);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
                    onSubmitted: (query) {
                      _handleSearch(query, 1);
                    },
                    decoration: const InputDecoration(
                        hintText: '高校名を入力',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0)),
                  )),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _handleSearch(_searchController.text, 1);
                    },
                  ),
                ],
              ),
            ),
          ),
          _schoolCount > 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('$_schoolCount件の高校が見つかりました'),
                )
              : const Text('高校が見つかりませんでした。検索条件を変更してください。'),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _pageCount == 0
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 50,
                        ),
                        onPressed: _currentPage > 1
                            ? () {
                                _fetchSchools(
                                    _searchController.text, _currentPage - 1);
                              }
                            : null,
                      ),
                      Text('$_currentPage / $_pageCount',
                          style: theme.textTheme.titleLarge),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          size: 50,
                        ),
                        onPressed: _currentPage < _pageCount
                            ? () {
                                _fetchSchools(
                                    _searchController.text, _currentPage + 1);
                              }
                            : null,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
