// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:quicktalk/services/auth/github_services.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatesPage extends StatefulWidget {
  @override
  _UpdatesPageState createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage> {
  final GitHubService _gitHubService = GitHubService(
      'https://api.github.com/repos/AkiTheMemeGod/quicktalk'); // Replace with your repo
  late Future<List<Map<String, dynamic>>> _releases;

  @override
  void initState() {
    super.initState();
    _releases = _gitHubService.fetchLatestReleases();
  }

  Future<void> _refreshpage() async {
    setState(() {});
    return await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Updates"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _releases,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final releases = snapshot.data!;

          if (releases.isEmpty) {
            return Center(child: Text("No releases found"));
          }

          return LiquidPullToRefresh(
            onRefresh: _refreshpage,
            height: 300,
            animSpeedFactor: 2,
            showChildOpacityTransition: true,
            child: ListView.builder(
              itemCount: releases.length,
              itemBuilder: (context, index) {
                final release = releases[index];
                return ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(release['name'] ?? 'No title')),
                  ),

                  //subtitle: Text(release['body'] ?? 'No description'),
                  trailing: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        // Open the download link
                        final downloadUrl =
                            release['assets'][0]['browser_download_url'];
                        if (downloadUrl != null) {
                          launch(downloadUrl);
                          print(downloadUrl);
                        }
                      },
                      child: Text("Download"),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
