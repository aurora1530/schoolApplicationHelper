import 'package:flutter/material.dart';

class SearchResult extends StatefulWidget {
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  String _searchText = '';
  final List<String> _schools = ['a', 'ab', 'b', 'bc', 'c', 'cd'];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> _filteredSchools =
        _schools.where((school) => school.startsWith(_searchText)).toList();

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
                        _searchText = _searchController.text;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredSchools.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_filteredSchools[index]),
                    subtitle: Text('都道府県名'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
