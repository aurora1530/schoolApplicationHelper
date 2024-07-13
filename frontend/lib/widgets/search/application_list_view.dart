import 'package:flutter/material.dart';
import 'package:school_application_helper/widgets/search/application_info.dart';

class ApplicationListView extends StatelessWidget {
  const ApplicationListView({
    super.key,
    required List<ApplicationInfo> applications,
  }) : _applications = applications;

  final List<ApplicationInfo> _applications;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                Text('Documents: ${application.documents.join(', ')}'),
                Text('Subjects: ${application.subjects.join(', ')}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
