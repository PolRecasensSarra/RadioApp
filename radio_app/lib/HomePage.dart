import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:radio_app/RadioStationPage.dart';
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
  final ScrollController _controller = ScrollController();

  // Method that gets all the radios by country given the necessary parameters.
  Future<List<Station>> searchRadioStations() async {
    final List<Station> stationList =
        await stationService.getRadioStationsByCountry("ES", 0, 30);
    return Future.value(stationList);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 53, 53, 53),
        appBar: AppBar(
          title: const Text(
            "Radio Stations List",
          ),
          backgroundColor: const Color.fromARGB(255, 37, 37, 37),
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
                const Expanded(
                  flex: 10,
                  child: Text(
                    "Available Radio Stations",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Create a future builder in order to show all the radio stations.
                Expanded(
                  flex: 90,
                  child: FutureBuilder(
                    future: searchRadioStations(),
                    builder: (context, AsyncSnapshot<List<Station>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data!.isNotEmpty) {
                        return Scrollbar(
                          thumbVisibility: true,
                          controller: _controller,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 26),
                            controller: _controller,
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: const Color.fromARGB(255, 75, 75, 75),
                                child: ListTile(
                                  leading: getRadioImage(snapshot.data![index]),
                                  title: Text(
                                    snapshot.data![index].radioName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  subtitle: Text(
                                    snapshot.data![index].radioCountry,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.open_in_new_outlined,
                                    color: Colors.white,
                                  ),
                                  hoverColor:
                                      const Color.fromARGB(255, 100, 100, 100),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (contextCallback) =>
                                            RadioStationPage(
                                                station: snapshot.data![index]),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      } else if (snapshot.connectionState ==
                              ConnectionState.done &&
                          snapshot.data!.isEmpty) {
                        return const Text(
                          "You have no radio stations",
                          style: TextStyle(color: Colors.tealAccent),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
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
