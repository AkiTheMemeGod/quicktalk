import 'dart:convert';
import 'package:http/http.dart' as http;

class GitHubService {
  final String repoUrl;

  GitHubService(this.repoUrl);

  Future<List<Map<String, dynamic>>> fetchLatestReleases() async {
    final response = await http.get(Uri.parse('$repoUrl/releases'));

    if (response.statusCode == 200) {
      List<dynamic> releases = json.decode(response.body);
      return releases
          .map((release) => release as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to load releases');
    }
  }
}
