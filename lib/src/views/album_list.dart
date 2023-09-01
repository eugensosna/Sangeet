import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sangeet/src/controller/audio_controller.dart';

class AlbumList extends StatefulWidget {
  const AlbumList({super.key});

  @override
  State<AlbumList> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {

  final AudioController _con = Get.put(AudioController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() => 
          _con.albumList.isEmpty
            ? const Center(child: Text('Songs not imported'))
            : albumsList()
        ),
      )
    );
  }

  albumsList() {
    return ListView.separated(
      itemCount: _con.albumList.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          tileColor: Theme.of(context).scaffoldBackgroundColor,
          leading:  QueryArtworkWidget(
            controller: _con.audioQuery,
            id: _con.albumList[index].id,
            type: ArtworkType.ALBUM,
            nullArtworkWidget: const Image(
              image: AssetImage('assets/images/appIcon.png'),
              width: 40.0,
              height: 40.0,
            )
          ),
          title: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Text(
              _con.albumList[index].album,
              overflow: TextOverflow.ellipsis
            )
          ),
          subtitle: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 18
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Text(
                        ' ${_con.albumList[index].artist}',
                        overflow: TextOverflow.ellipsis
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.album,
                    size: 18
                  ),
                  Text(
                    ' ${_con.albumList[index].numOfSongs}',
                    overflow: TextOverflow.ellipsis
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            _con.getFilteredSongs('album' , _con.albumList[index].id, _con.albumList[index].artistId, _con.albumList[index].album);
            setState(() { });
          },
        );
      }
    );
  }

}