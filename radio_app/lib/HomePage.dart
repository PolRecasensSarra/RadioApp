import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:radio_app/Station.dart';
import 'package:radio_app/StationService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Instance of the station service class.
  final StationService stationService = StationService(Dio());

  Future<void> searchRadioStations() async {
    final List<Station> stationList =
        await stationService.getRadioStationsByCountry("ES", 0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          title: const Text(
            "Radio Stations List",
          ),
          backgroundColor: Colors.grey[850],
          actions: const [
            Icon(
              Icons.music_note,
            ),
          ],
          elevation: 0.0,
        ),
        body: Center(
          child: ElevatedButton(
            child: const Text("Search radio stations"),
            onPressed: () async {
              searchRadioStations();
            },
          ),
        ),
      ),
    );
  }
}
