import 'package:flutter/material.dart';
import 'package:school_application_helper/widgets/search/application.dart';
import 'package:school_application_helper/widgets/search/highschool_info.dart';

class HighSchoolsListView extends StatelessWidget {
  const HighSchoolsListView({
    super.key,
    required List<HighSchoolInfo> schools,
  }) : _schools = schools;

  final List<HighSchoolInfo> _schools;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
    );
  }
}
