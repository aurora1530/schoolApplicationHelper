import 'package:flutter/material.dart';
import 'package:school_application_helper/widgets/search/application.dart';
import 'package:school_application_helper/widgets/search/highschool_info.dart';

class HighSchoolListView extends StatefulWidget {
  const HighSchoolListView({
    super.key,
    required this.schools,
    required this.selectedSchools,
    required this.onSelectionChanged,
  });

  final List<HighSchoolInfo> schools;
  final List<HighSchoolInfo> selectedSchools;
  final ValueChanged<List<HighSchoolInfo>> onSelectionChanged;

  @override
  _HighSchoolListViewState createState() => _HighSchoolListViewState();
}

class _HighSchoolListViewState extends State<HighSchoolListView> {
  void _toggleSelection(HighSchoolInfo school) {
    setState(() {
      if (widget.selectedSchools.any((s) => s.id == school.id)) {
        widget.selectedSchools.removeWhere((s) => s.id == school.id);
      } else {
        widget.selectedSchools.add(school);
      }
      widget.onSelectionChanged(widget.selectedSchools);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.schools.length,
      itemBuilder: (context, index) {
        bool isSelected =
            widget.selectedSchools.any((s) => s.id == widget.schools[index].id);
        return Card(
          color:
              isSelected ? Theme.of(context).colorScheme.inversePrimary : null,
          child: ListTile(
            title: Text(widget.schools[index].name),
            subtitle: Text(widget.schools[index].prefecture),
            onTap: () {
              _toggleSelection(widget.schools[index]);
            },
            leading: isSelected
                ? const Icon(Icons.check)
                : const Icon(Icons.check_box_outline_blank),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Application(school: widget.schools[index]),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
