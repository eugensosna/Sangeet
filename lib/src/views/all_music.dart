import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sangeet/src/controller/audio_controller.dart';

class AllMusic extends StatefulWidget {
  const AllMusic({super.key});

  @override
  State<AllMusic> createState() => _AllMusicState();
}

class _AllMusicState extends State<AllMusic> {

  final AudioController _con = Get.put(AudioController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All SONGS'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Obx(() => 
          _con.allSongs.isEmpty
            ? const Center(child: Text('Songs not imported'))
            : allsongsList()
        ),
      )
    );
  }

  allsongsList() {
    return ListView.separated(
      itemCount: _con.allSongs.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          tileColor: _con.isPlayingIdx == index ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
          leading:  QueryArtworkWidget(
            controller: _con.audioQuery,
            id: _con.allSongs[index].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: const Image(
              image: AssetImage('assets/images/appIcon.png'),
              width: 40.0,
              height: 40.0,
            )
          ),
          title: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Text(
              _con.allSongs[index].title,
              overflow: TextOverflow.ellipsis
            )
          ),
          subtitle: Row(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 18
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      ' ${_con.allSongs[index].artist}',
                      overflow: TextOverflow.ellipsis
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.album,
                    size: 18
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      ' ${_con.allSongs[index].album}',
                      overflow: TextOverflow.ellipsis
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            _con.addToNowPlaying(index);
            setState(() { });
          },
        );
      }
    );
  }

}