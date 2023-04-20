import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sangeet/src/controller/audio_controller.dart';
import 'package:sangeet/src/views/all_music.dart';
import 'package:sangeet/src/views/now_playing.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> with WidgetsBindingObserver{
  final AudioController _con = Get.put(AudioController());

  int _curIdx = 0;

  static final List<Widget> _pages = <Widget>[
    const NowPlaying(),
    const AllMusic(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _curIdx = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {     // pausing audio when app is minimized
      _con.pauseSong(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: _pages.elementAt(_curIdx),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _curIdx,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.queue_music,
              ),
              label: 'Now Playing'
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
              ),
              label: 'All Music'
            )
          ]
        ),
      ),
    );
  }
}