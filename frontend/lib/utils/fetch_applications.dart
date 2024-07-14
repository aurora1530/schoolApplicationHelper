import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_application_helper/widgets/search/application_info.dart';

Future<List<ApplicationInfo>> fetchApplications(int schoolID) async {
  try {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:3000/search/highSchools/$schoolID'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> applicationJson = json.decode(response.body);
      final List<dynamic> applicationListJson = applicationJson['applications'];
      final applications = applicationListJson
          .map((applicationJson) => ApplicationInfo.fromJson(applicationJson))
          .toList();
      return applications;
    } else {
      throw Exception('Failed to load applications');
    }
  } catch (e) {
    throw Exception('Failed to load applications: $e');
  }
}
