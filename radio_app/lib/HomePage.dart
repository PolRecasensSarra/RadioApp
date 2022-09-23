// ignore: file_names
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  // Method that gets all the radios by country given the necessary parameters.
  Future<List<Station>> searchRadioStations() async {
    final List<Station> stationList =
        await stationService.getRadioStationsByCountry("ES", 0, 10);
    return Future.value(stationList);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 53, 53, 53),
        appBar: AppBar(
          title: const Text(
            "Radio Stations List",
          ),
          backgroundColor: Color.fromARGB(255, 37, 37, 37),
          actions: const [
            Icon(
              Icons.music_note,
            ),
          ],
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 26.0),
          child: Center(
            child: Column(
              children: [
                const Text(
                  "Available Radio Stations",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Create a future builder in order to show all the radio stations.
                FutureBuilder(
                  future: searchRadioStations(),
                  builder: (context, AsyncSnapshot<List<Station>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Color.fromARGB(255, 75, 75, 75),
                            child: ListTile(
                              leading: getRadioImage(snapshot.data![index]),
                              title: Text(
                                snapshot.data![index].radioName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        snapshot.data!.isEmpty) {
                      return const Text(
                        "You have no radio stations",
                        style: TextStyle(color: Colors.tealAccent),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method that given a radio station, returns the radio image.
  getRadioImage(Station station) {
    return Container(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(station.urlImage),
      ),
    );
  }
}
