import 'package:flutter/material.dart';
import 'package:school_application_helper/utils/dialog.dart';

class HighSchoolSearchBox extends StatelessWidget {
  const HighSchoolSearchBox({
    super.key,
    required TextEditingController searchController,
    required this.showPrefectureDialog,
    required this.fetchSchools,
    required this.refreshSearch,
  }) : _searchController = searchController;

  final TextEditingController _searchController;
  final VoidCallback showPrefectureDialog;
  final Future<void> Function(String query, int page) fetchSchools;
  final VoidCallback refreshSearch;

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
          IconButton(
              onPressed: () {
                showWarnDialog(
                  context: context,
                  title: '検索条件をリセットしますか？',
                  content: '検索条件が全てリセットされますが、よろしいですか？',
                  confirmText: 'リセット',
                  cancelText: 'キャンセル',
                  onConfirm: () {
                    refreshSearch();
                  },
                );
              },
              icon: const Icon(Icons.cancel_outlined))
        ],
      ),
    );
  }
}
