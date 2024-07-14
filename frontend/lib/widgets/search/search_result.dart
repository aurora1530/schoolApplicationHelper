import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_application_helper/widgets/search/application.dart';
import 'package:school_application_helper/widgets/search/highschool_info.dart';
import 'package:school_application_helper/widgets/search/highschool_search_box.dart';
import 'package:school_application_helper/widgets/search/highschool_list_view.dart';
import 'package:school_application_helper/widgets/search/pagination_arrows.dart';

class SearchResult extends StatefulWidget {
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  int _currentPage = 1;
  int _pageCount = 0;
  int _schoolCount = 0;
  bool _isLoading = false;
  bool _hasError = false;
  List<HighSchoolInfo> _schools = [];
  final TextEditingController _searchController = TextEditingController();
  List<String> _selectedPrefectures = [];
  final List<String> _allPrefectures = [
    '北海道',
    '青森県',
    '岩手県',
    '宮城県',
    '秋田県',
    '山形県',
    '福島県',
    '茨城県',
    '栃木県',
    '群馬県',
    '埼玉県',
    '千葉県',
    '東京都',
    '神奈川県',
    '新潟県',
    '富山県',
    '石川県',
    '福井県',
    '山梨県',
    '長野県',
    '岐阜県',
    '静岡県',
    '愛知県',
    '三重県',
    '滋賀県',
    '京都府',
    '大阪府',
    '兵庫県',
    '奈良県',
    '和歌山県',
    '鳥取県',
    '島根県',
    '岡山県',
    '広島県',
    '山口県',
    '徳島県',
    '香川県',
    '愛媛県',
    '高知県',
    '福岡県',
    '佐賀県',
    '長崎県',
    '熊本県',
    '大分県',
    '宮崎県',
    '鹿児島県',
    '沖縄県',
  ];

  Future<void> _fetchSchools(String query, int page) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    final String prefecturesParam = _selectedPrefectures.isNotEmpty
        ? '&prefectures=${_selectedPrefectures.join(',')}'
        : '';
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:3000/search/highSchools?q=$query&page=$page$prefecturesParam'));

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
        _isLoading = false;
      });
    } else {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      return;
    }
  }

  void _showPrefectureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('都道府県を選択'),
              content: SingleChildScrollView(
                child: Column(
                  children: _allPrefectures.map((prefecture) {
                    return CheckboxListTile(
                      title: Text(prefecture),
                      value: _selectedPrefectures.contains(prefecture),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedPrefectures.add(prefecture);
                          } else {
                            _selectedPrefectures.remove(prefecture);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedPrefectures.clear();
                    });
                  },
                  child: const Text('全て解除'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedPrefectures = List.from(_allPrefectures);
                    });
                  },
                  child: const Text('すべて選択'),
                ),
                TextButton(
                  onPressed: () {
                    _fetchSchools(_searchController.text, 1);
                    Navigator.of(context).pop();
                  },
                  child: const Text('閉じる'),
                ),
              ],
            );
          },
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: HighSchoolSearchBox(
                searchController: _searchController,
                showPrefectureDialog: _showPrefectureDialog,
                fetchSchools: _fetchSchools,
              ),
            ),
            _schoolCount > 0
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$_schoolCount件の高校が見つかりました'),
                  )
                : const Text('高校が見つかりませんでした。検索条件を変更してください。'),
            _isLoading
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()))
                : _hasError
                    ? const Expanded(
                        child: Center(child: Text('高校の読み込みに失敗しました。')))
                    : Expanded(
                        child: HighSchoolListView(schools: _schools),
                      ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _pageCount == 0
                  ? const SizedBox.shrink()
                  : PaginationArrows(
                      currentPage: _currentPage,
                      pageCount: _pageCount,
                      toPreviousPage: () {
                        _fetchSchools(_searchController.text, _currentPage - 1);
                      },
                      toNextPage: () {
                        _fetchSchools(_searchController.text, _currentPage + 1);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
