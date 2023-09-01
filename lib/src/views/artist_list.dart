import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sangeet/src/controller/audio_controller.dart';

class ArtistList extends StatefulWidget {
  const ArtistList({super.key});

  @override
  State<ArtistList> createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {

  final AudioController _con = Get.put(AudioController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() => 
          _con.artistSongs.isEmpty
            ? const Center(child: Text('Songs not imported'))
            : albumsList()
        ),
      )
    );
  }

  albumsList() {
    return ListView.separated(
      itemCount: _con.artistSongs.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          tileColor: Theme.of(context).scaffoldBackgroundColor,
          leading:  QueryArtworkWidget(
            controller: _con.audioQuery,
            id: _con.artistSongs[index].id,
            type: ArtworkType.ARTIST,
            nullArtworkWidget: const Image(
              image: AssetImage('assets/images/appIcon.png'),
              width: 40.0,
              height: 40.0,
            )
          ),
          title: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Text(
              _con.artistSongs[index].artist,
              overflow: TextOverflow.ellipsis
            )
          ),
          subtitle: Row(
            children: [
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.5,
              //   child: Row(
              //     children: [
              //       const Icon(
              //         Icons.person,
              //         size: 18
              //       ),
              //       SizedBox(
              //         width: MediaQuery.of(context).size.width * 0.35,
              //         child: Text(
              //           ' ${_con.artistSongs[index].artist}',
              //           overflow: TextOverflow.ellipsis
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Row(
                children: [
                  const Icon(
                    Icons.album,
                    size: 18
                  ),
                  Text(
                    ' ${_con.artistSongs[index].numberOfTracks}',
                    overflow: TextOverflow.ellipsis
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            _con.getFilteredSongs('artist' , null, _con.artistSongs[index].id, _con.artistSongs[index].artist);
            setState(() { });
          },
        );
      }
    );
  }

}