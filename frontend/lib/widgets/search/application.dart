import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_application_helper/widgets/search/application_info.dart';
import 'package:school_application_helper/widgets/search/high_school_info.dart';

class Application extends StatefulWidget {
  final HighSchoolInfo school;

  Application({Key? key, required this.school}) : super(key: key);

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  List<ApplicationInfo> _applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:3000/search/highSchools/${widget.school.id}'));
    if (response.statusCode == 200) {
      final List<dynamic> applicationListJson = json.decode(response.body);
      setState(() {
        _applications = applicationListJson
            .map((applicationJson) => ApplicationInfo.fromJson(applicationJson))
            .toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load applications');
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('出願方法'),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  widget.school.name,
                  style: theme.textTheme.titleLarge,
                ),
                Text(
                  widget.school.prefecture,
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _applications.length,
                      itemBuilder: (context, index) {
                        final application = _applications[index];
                        return Card(
                          child: ListTile(
                            title: Text(application.method),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Deadline: ${application.deadline}'),
                                Text(
                                    'Documents: ${application.documents.join(', ')}'),
                                Text(
                                    'Subjects: ${application.subjects.join(', ')}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}