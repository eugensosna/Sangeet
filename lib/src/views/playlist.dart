import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sangeet/src/controller/audio_controller.dart';
import 'package:sangeet/src/widgets/add_rename_playlist.dart';
import 'package:sangeet/src/widgets/bottom_sheet.dart';
import 'package:sangeet/src/widgets/custom_dialog.dart';

class PlayList extends StatefulWidget {
  const PlayList({super.key});

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {

  final AudioController _con = Get.put(AudioController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() => 
          _con.playlist.isEmpty
            ? InkWell(
              onTap: () => addRenamePlaylist(context),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8, 
                width: MediaQuery.of(context).size.width, 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add,
                      size: 40.0,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Create A Playlist.',
                      style: TextStyle(
                        color: Colors.grey
                      ),
                    )
                  ] 
                )
              ),
            )
            : playList()
        ),
      )
    );
  }

  playList() {
    return ListView.separated(
      itemCount: _con.playlist.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          tileColor: Theme.of(context).scaffoldBackgroundColor,
          leading:  QueryArtworkWidget(
            controller: _con.audioQuery,
            id: _con.playlist[index].id,
            type: ArtworkType.PLAYLIST,
            nullArtworkWidget: const Image(
              image: AssetImage('assets/images/appIcon.png'),
              width: 40.0,
              height: 40.0,
            )
          ),
          title: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Text(
              _con.playlist[index].playlist,
              overflow: TextOverflow.ellipsis
            )
          ),
          subtitle: Row(
            children: [
              const Icon(
                Icons.album,
                size: 18
              ),
              Text(
                ' ${_con.playlist[index].numOfSongs} Songs',
                overflow: TextOverflow.ellipsis
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.more_vert
            ),
            onPressed: () => moreBottomSheet(index, _con.playlist[index]), 
          ),
          onTap: () {
            // _con.getFilteredSongs('artist' , null, _con.playlist[index].id, _con.playlist[index].artist);
            // setState(() { });
          },
        );
      }
    );
  }

  moreBottomSheet(index, item) {
    return bottomSheet(
      context, 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              Get.back();
              // addRenamePlaylist(context, item.id);              
            },
            child: SizedBox(
              width: double.infinity,
              child: Row(
                children: const [
                  Icon(
                    Icons.edit,
                    size: 30.0,
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    'Rename Playlist',
                    style: TextStyle(
                      fontSize: 16.0
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          InkWell(
            onTap: () {
              Get.back();
              customAlertDialog(
                'Yes',
                () => {}, //_con.removePlaylist(item.id),
                'Cancel',
                null,
                'You are about to remove a playlist. \n Are you sure?'
              );
            },
            child: SizedBox(
              width: double.infinity,
              child: Row(
                children: const [
                  Icon(
                    Icons.delete,
                    size: 30.0,
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    'Remove Playlist',
                    style: TextStyle(
                      fontSize: 16.0
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }

}