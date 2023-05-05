// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_const_literals_to_create_immutables, unused_element, non_constant_identifier_names, empty_statements, dead_code

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import '../models/song_model.dart';
import '../widgets/player_buttons.dart';
import '../widgets/seekbar.dart';


class SongScreen extends StatefulWidget {
const SongScreen({ Key? key }) : super(key: key);

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {

  AudioPlayer audioPlayer = AudioPlayer();

  Song song = Get.arguments ?? Song.songs[0];


  @override  
    void initState() {
      super.initState();

      audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: [
           AudioSource.uri(
          Uri.parse('asset:///${song.url}'),
            ),
          ],
        ),
      );
    }

    @override
    void dispose() {
      audioPlayer.dispose();
      super.dispose();
    }

    Stream<SeekBarData> get _SeekBarDataStream =>
    rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
      audioPlayer.positionStream,
      audioPlayer.durationStream,
      (Duration position, Duration? duration,){
        return SeekBarData(position, duration ?? Duration.zero);
      }
    );


  @override
  Widget build(BuildContext context){
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            song.coverUrl,
            fit: BoxFit.cover,
          ),
          _BackgroundFilter(),
          _MusicPlayer(
            song: song,
            SeekBarDataStream: _SeekBarDataStream,
            audioPlayer: audioPlayer,
          ),
        ],
      ),
    );
  }
}

class _MusicPlayer extends StatelessWidget {
  const _MusicPlayer({
    Key? key,
    required Stream<SeekBarData> SeekBarDataStream,
    required this.audioPlayer,
    required this.song,
  }) : _SeekBarDataStream = SeekBarDataStream, super(key: key);

  final Stream<SeekBarData> _SeekBarDataStream;
  final AudioPlayer audioPlayer;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            song.title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )
          ),
          SizedBox(height: 10),
          Text(
            song.description,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.white,
            )
          ),
          SizedBox(height: 30),
          StreamBuilder<SeekBarData>(
            stream: _SeekBarDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                position: positionData?.position ?? Duration.zero,
                duration: positionData?.duration ?? Duration.zero,
                onChangedEnd: audioPlayer.seek,
              );
            }
          ),
          PlayerButtons(audioPlayer: audioPlayer),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 35,
                onPressed: (){},
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
              IconButton(
                iconSize: 35,
                onPressed: (){},
                icon: Icon(
                  Icons.cloud_download,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}



class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback:(rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.0),
            ],
            stops: [
              0.0,
              0.4,
              0.6,
            ]
          ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade800,
            ]
          ),
        ),
      ),
    );
  }
}