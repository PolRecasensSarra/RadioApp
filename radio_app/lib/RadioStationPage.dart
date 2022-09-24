import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:radio_app/Station.dart';

class RadioStationPage extends StatefulWidget {
  final Station station;

  RadioStationPage({
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      appBar: AppBar(
        title: Text(
          widget.station.radioName,
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
                child: Card(
                  color: Color.fromARGB(255, 75, 75, 75),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
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
              const Expanded(
                flex: 20,
                child: SizedBox(),
              ),
              ElevatedButton(
                onPressed: () {
                  getAudio(widget.station.urlRadio);
                },
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getRadioStationImage(String url) {
    if (url.isNotEmpty) {
      return Image.network(
        widget.station.urlImage,
      );
    } else {
      return Image.asset("assets/default_image.png");
    }
  }

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
}
