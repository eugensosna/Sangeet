import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sangeet/src/controller/audio_controller.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  final AudioController _con = Get.put(AudioController());
  

  @override
  void initState() {
    super.initState();

    //Listen to audio duration
    _con.audioPlayer.onDurationChanged.listen((event) {
      if(mounted) {
        setState(() {
          _con.duration = event; 
        });
      }
    });

    //Listen to slider position changed
    _con.audioPlayer.onPositionChanged.listen((event) {
      if(mounted) {
        setState(() {
          _con.position = event;
        });
      }
    });

    //on song complete
    _con.audioPlayer.onPlayerComplete.listen((event) {
      _con.isShuffle
        ? _con.shuffledList()
        : _con.nextSong();
      if(mounted) setState(() { });
    });

  }

  // @override
  // void dispose() {
  //   _con.audioPlayer.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Now Playing',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: size.height * 0.05),
            albumArt(),
            SizedBox(height: size.height * 0.05),
            songTitle(),
            SizedBox(height: size.height * 0.015),
            slider(),
            SizedBox(height: size.height * 0.025),
            btnControls(),
          ],
        ),
      ),
    );
  }

  albumArt() {
    return QueryArtworkWidget(
      controller: _con.audioQuery,
      id: _con.nowPlaying.id,
      type: ArtworkType.AUDIO,
      keepOldArtwork: true,
      nullArtworkWidget: Image(
        image: const AssetImage('assets/images/appIcon.png'),
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width,
      ),
      artworkHeight: MediaQuery.of(context).size.height * 0.45,
      artworkWidth: MediaQuery.of(context).size.width,
      artworkQuality: FilterQuality.high,
    );
  }

  songTitle() {
    return Column(
      children: [
        SizedBox(
          height: 35.0,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Marquee(
            text: _con.nowPlaying.title,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 100.0,
            pauseAfterRound: const Duration(seconds: 1),
            startPadding: 10.0,
            accelerationDuration: const Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: const Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Get.isDarkMode ? Colors.white : Colors.black
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 18
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                ' ${_con.nowPlaying.artist}',
                overflow: TextOverflow.ellipsis
              ),
            ),
            const Icon(
              Icons.album,
              size: 18
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                ' ${_con.nowPlaying.album}',
                overflow: TextOverflow.ellipsis
              ),
            ),
          ],
        )
      ],
    );
  }

  slider() {
    return Column(
      children: [
        _con.duration.inSeconds < _con.position.inSeconds
          ? const SizedBox()
          : Slider(
            min: 0,
            max: _con.duration.inSeconds.toDouble(),
            value: _con.position.inSeconds.toDouble(),
            onChanged: (val) async {
              final position = Duration(seconds: val.toInt());
              await _con.audioPlayer.seek(position);
              await _con.resumeSong();
            }
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_con.formatTime(_con.position)),
            Text(_con.formatTime(_con.duration))
          ],
        )
      ],
    );
  }

  Widget btnControls() {
    return Obx(() => 
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          btnLoopsBg(
            _con.isRepeat
              ? Icons.repeat_one
              : Icons.repeat,
            () async {
              await _con.songLoop();
              setState(() { });
            }
          ),
          const SizedBox(width: 40.0),
          btnControlsBg(
            Icons.skip_previous,
            () => _con.prevSong()
          ),
          const SizedBox(width: 15.0),
          btnControlsPlayBg(
            _con.isPlaying.value ? Icons.pause : Icons.play_arrow,
            () => _con.isPlaying.value ? _con.pauseSong() : _con.playSong(),
          ),
          const SizedBox(width: 15.0),
          btnControlsBg(
            Icons.skip_next,
            () => _con.nextSong()
          ),
          const SizedBox(width: 40.0),
          btnShuffleBg(
            Icons.shuffle,
            () async {
              await _con.songShuffle();
              setState(() { });
            }
          ),
        ],
      )
    );
  }

  Widget btnControlsBg(icon, ontap) {
    return InkWell(
      onTap: ontap,
      child: Icon(
        icon,
        size: 40.0,
        color: Colors.white,
      ),
    );
  }

  Widget btnLoopsBg(icon, ontap) {
    return InkWell(
      onTap: ontap,
      child: Icon(
        icon,
        size: 30.0,
        color: Colors.white,
      ),
    );
  }

  Widget btnShuffleBg(icon, ontap) {
    return InkWell(
      onTap: ontap,
      child: Icon(
        icon,
        size: 30.0,
        color: _con.isShuffle
              ? Colors.red
              : Colors.white,
      ),
    );
  }
  
  Widget btnControlsPlayBg(icon, ontap) {
    return InkWell(
      onTap: ontap,
      child: CircleAvatar(
        radius: 30.0,
        child: Icon(
          icon,
          size: 40.0,
        ),
      ),
    );
  }

}