import 'package:flutter/material.dart';
import 'package:sangeet/src/views/album_list.dart';
import 'package:sangeet/src/views/all_music.dart';
import 'package:sangeet/src/views/artist_list.dart';

class MusicListTab extends StatefulWidget {
  const MusicListTab({super.key});

  @override
  State<MusicListTab> createState() => _MusicListTabState();
}

class _MusicListTabState extends State<MusicListTab>  with SingleTickerProviderStateMixin{

  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() { 
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          tabBarHeader(),
          Expanded(
            child: tabBarView(),
          )
        ],
      )
    );
  }

  tabBarHeader() {
    return TabBar(
      controller: _tabController,
      padding: const EdgeInsets.only(left: 16.0),
      isScrollable: true,
      labelColor: Colors.white,
      // labelStyle: notoSans(greyShade3, 17.0, 0.0),
      unselectedLabelColor: Colors.grey,
      // unselectedLabelStyle: notoSans(grey, 17.0, 0.0),
      indicatorColor: Theme.of(context).primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 2.2,
      tabs: const [
        Tab(
          text: "All Songs",
          height: 40,
        ),
        Tab(
          text: "Albums",
          height: 40,
        ),
        Tab(
          text: "Artists",
          height: 40,
        ),
        Tab(
          text: "PlayList",
          height: 40,
        ),
      ],
    );
  }

  tabBarView() {
    return TabBarView(
      controller: _tabController,
      children: const [
        AllMusic(),
        AlbumList(),
        ArtistList(),
        SizedBox(
          height: 500.0,
          child: Center(child: Text('Playlist is under construction. \n Thanks for your patience'))
        ),
      ],
    );
  }


}