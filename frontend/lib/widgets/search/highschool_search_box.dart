import 'package:flutter/material.dart';

class HighSchoolSearchBox extends StatelessWidget {
  const HighSchoolSearchBox({
    super.key,
    required TextEditingController searchController,
    required this.showPrefectureDialog,
    required this.fetchSchools,
  }) : _searchController = searchController;

  final TextEditingController _searchController;
  final VoidCallback showPrefectureDialog;
  final Future<void> Function(String query, int page) fetchSchools;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(
              onPressed: showPrefectureDialog, icon: const Icon(Icons.menu)),
          Expanded(
              child: TextField(
            controller: _searchController,
            onSubmitted: (query) {
              fetchSchools(query, 1);
            },
            decoration: const InputDecoration(
                hintText: '高校名を入力',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15.0)),
          )),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              fetchSchools(_searchController.text, 1);
            },
          ),
        ],
      ),
    );
  }
}
