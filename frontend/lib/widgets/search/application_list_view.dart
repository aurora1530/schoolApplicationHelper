import 'package:flutter/material.dart';
import 'package:school_application_helper/utils/datetime.dart';
import 'package:school_application_helper/widgets/search/application_info.dart';

class ApplicationListView extends StatelessWidget {
  const ApplicationListView({
    super.key,
    required List<ApplicationInfo> applications,
  }) : _applications = applications;

  final List<ApplicationInfo> _applications;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ListView.builder(
      itemCount: _applications.length,
      itemBuilder: (context, index) {
        final application = _applications[index];
        return Card(
          child: ListTile(
            title: Text(
              application.method,
              style: theme.textTheme.titleLarge,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  height: 10,
                ),
                Text(
                  '出願締め切り: ${formatDateTimeToLocale(application.deadline)}',
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  '必要書類: ${application.documents.join(', ')}',
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  '受験科目: ${application.subjects.join(', ')}',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
