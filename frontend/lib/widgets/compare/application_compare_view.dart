import 'package:flutter/material.dart';
import 'package:school_application_helper/utils/datetime.dart';
import 'package:school_application_helper/utils/fetch_applications.dart';
import 'package:school_application_helper/widgets/search/application_info.dart';
import 'package:school_application_helper/widgets/search/highschool_info.dart';

class ApplicationCompere extends StatefulWidget {
  const ApplicationCompere({super.key, required this.selectedSchools});
  final List<HighSchoolInfo> selectedSchools;

  @override
  State<ApplicationCompere> createState() => _ApplicationCompereState();
}

class _ApplicationCompereState extends State<ApplicationCompere> {
  final Map<HighSchoolInfo, List<ApplicationInfo>> _schoolToApplications = {};
  List<String> _methods = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Future.forEach(
            widget.selectedSchools, (school) => _fetchApplications(school))
        .then((_) {
      setState(() {
        _isLoading = false;
        _methods = _schoolToApplications.values
            .expand((e) => e)
            .map((e) => e.method)
            .toSet()
            .toList();
      });
    });
  }

  Future<void> _fetchApplications(HighSchoolInfo school) async {
    try {
      final applications = await fetchApplications(school.id);
      setState(() {
        _schoolToApplications[school] = applications;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  Widget _buildDataTableEachMethod(String method, ThemeData theme) {
    List<DataColumn> columns = [
      DataColumn(
          label: Text(
        '項目',
        style: theme.textTheme.titleMedium,
      )),
      ...widget.selectedSchools.map((school) {
        return DataColumn(
          label: Text(school.name, style: theme.textTheme.titleMedium),
        );
      }),
    ];

    const List<String> items = ['出願締め切り', '受験科目', '必要書類'];

    List<DataRow> rows = items.map((item) {
      return DataRow(
        cells: [
          DataCell(Text(item)),
          ...widget.selectedSchools.map((school) {
            // 対象のメソッドに対応する出願情報を取得
            ApplicationInfo? appInfo = _schoolToApplications[school]!
                .cast<ApplicationInfo?>()
                .firstWhere(
                  (app) => app?.method == method,
                  orElse: () => null,
                );

            if (appInfo == null) {
              return const DataCell(Text('無し'));
            } else {
              String value = '';
              switch (item) {
                case '出願締め切り':
                  value = formatDateTimeToLocale(appInfo.deadline);
                  break;
                case '受験科目':
                  value = appInfo.subjects.join(', ');
                  break;
                case '必要書類':
                  value = appInfo.documents.join(', ');
                  break;
              }
              return DataCell(Text(value));
            }
          })
        ],
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            method,
            style: theme.textTheme.headlineMedium,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(columns: columns, rows: rows),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: const Text('出願方法比較'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(child: Text('エラーが発生しました'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: _methods
                          .map((method) =>
                              _buildDataTableEachMethod(method, theme))
                          .toList(),
                    ),
                  ),
                ),
    );
  }
}
