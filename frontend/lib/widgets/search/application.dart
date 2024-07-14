import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_application_helper/utils/fetch_applications.dart';
import 'package:school_application_helper/widgets/search/application_info.dart';
import 'package:school_application_helper/widgets/search/application_list_view.dart';
import 'package:school_application_helper/widgets/search/highschool_info.dart';

class Application extends StatefulWidget {
  final HighSchoolInfo school;

  Application({Key? key, required this.school}) : super(key: key);

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  List<ApplicationInfo> _applications = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final applications = await fetchApplications(widget.school.id);
      setState(() {
        _applications = applications;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: const Text('出願方法'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.school.name,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        widget.school.prefecture,
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
              _isLoading
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                  : _hasError
                      ? const Expanded(
                          child: Center(child: Text('出願方法の読み込みに失敗しました。')))
                      : _applications.isEmpty
                          ? const Expanded(
                              child: Center(child: Text('出願方法情報がありません。')))
                          : Expanded(
                              child: ApplicationListView(
                                  applications: _applications),
                            ),
            ],
          ),
        ),
      ),
    );
  }
}
