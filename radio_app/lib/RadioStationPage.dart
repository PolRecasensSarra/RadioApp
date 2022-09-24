import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:radio_app/Station.dart';

class RadioStationPage extends StatefulWidget {
  final Station station;

  const RadioStationPage({
    super.key,
    required this.station,
  });

  @override
  State<RadioStationPage> createState() => _RadioStationPageState();
}

class _RadioStationPageState extends State<RadioStationPage> {
  AudioPlayer audioPlayer = new AudioPlayer();
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        stopAudio(widget.station.urlRadio);
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 53, 53, 53),
        appBar: AppBar(
          title: Text(
            widget.station.radioName,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Center(
            child: Column(
              children: [
                getRadioStationImage(
                  widget.station.urlImage,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Expanded(
                  flex: 20,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Card(
                      color: const Color.fromARGB(255, 75, 75, 75),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Country: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.station.radioCountry,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Radio Language: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.station.radioLanguage,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 20,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    onPressed: () {
                      getAudio(widget.station.urlRadio);
                    },
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Method that returns an image from a url or a default image if the url is empty.
  Widget getRadioStationImage(String url) {
    if (url.isNotEmpty) {
      return Image.network(
        widget.station.urlImage,
      );
    } else {
      return Image.asset("assets/default_image.png");
    }
  }

// Method that plays or stops a streaming url.
// @param url String url to the audio we want to play or pause.
  Future<void> getAudio(String url) async {
    if (isPlaying) {
      await audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
    } else {
      await audioPlayer.play(UrlSource(url));
      setState(() {
        isPlaying = true;
      });
    }
  }

// Method that stop audio being played.
  Future<void> stopAudio(String url) async {
    if (isPlaying) {
      await audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
    }
  }
}
