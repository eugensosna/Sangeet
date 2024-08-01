import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sangeet/src/controller/audio_controller.dart';
import 'package:sangeet/src/widgets/custom_textfield.dart';

class AllMusic extends StatefulWidget {
  const AllMusic({super.key});

  @override
  State<AllMusic> createState() => _AllMusicState();
}

class _AllMusicState extends State<AllMusic> {

  final AudioController _con = Get.put(AudioController());
  final TextEditingController textFldCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Obx(() => 
          SingleChildScrollView(
            child: Column(
              children: [
                searchBox(),
                _con.allSongs.isEmpty
                  ? const Center(child: Text('Songs not found'))
                  : allsongsList()  
              ],
            ),
          )
        )
      ),
    );
  }

  searchBox() {
    return SizedBox(
      height: 70.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 12.0, 8.0),
        child: CustomTextField(
          controller: textFldCon,
          hintText: 'Search a song',
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          suffixIcon: textFldCon.text == "" 
            ? null
            : IconButton(
              onPressed: () {
                setState(() => textFldCon.clear());
                _con.searchSong('');
                FocusScope.of(context).unfocus();
              }, 
              icon: const Icon(
                Icons.close,
                color: Colors.grey,
              )
            ),
          onChanged: (val) {
            _con.searchSong(val);
          },
        ),
      ),
    );
  }

  allsongsList() {
    return ListView.separated(
      itemCount: _con.allSongs.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return Obx(() =>
          ListTile(
            tileColor: _con.isPlayingId.value == _con.allSongs[index].id ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
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
                const Icon(
                  Icons.person,
                  size: 18
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Text(
                    ' ${_con.allSongs[index].artist}',
                    overflow: TextOverflow.ellipsis
                  ),
                ),
              ],
            ),
            onTap: () {
              _con.currentPlayingList(_con.allSongs);
              _con.addToNowPlaying(index);
              setState(() { });
            },
          )
        );
      }
    );
  }

}