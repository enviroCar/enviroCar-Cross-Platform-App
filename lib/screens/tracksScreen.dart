import 'dart:convert';
import 'Package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../widgets/trackCard.dart';
import '../services/tracksServices.dart';
import '../providers/authProvider.dart';
import '../models/tracksList.dart';

class TracksScreen extends StatefulWidget {
  @override
  _TracksScreenState createState() => _TracksScreenState();
}

class _TracksScreenState extends State<TracksScreen> {
  @override
  Widget build(BuildContext context) {
    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return Container(
      child: StreamBuilder(
        stream: TracksServices().getTracks(authProvider: _authProvider),
        builder: (_, snapShot) {
          if (snapShot.hasData) {
            http.Response res = snapShot.data;
            TracksList tracks = TracksList.fromJson(jsonDecode(res.body));

            if (tracks.tracksList.isEmpty) {
              return Center(
                child: Text('No Tracks'),
              );
            }

            return ListView.builder(
              itemCount: tracks.tracksList.length,
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TrackCard(
                    track: tracks.tracksList[i],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
