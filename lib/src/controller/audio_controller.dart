import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sangeet/src/views/filtered_songs.dart';
import 'package:sangeet/src/widgets/cache_storage.dart';
import 'package:sangeet/src/widgets/show_message.dart';

class AudioController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer(); 

  // ignore: prefer_typing_uninitialized_variables
  var nowPlaying;
  bool _hasPermission = false;
  RxList allSongs = [].obs;
  RxList albumList = [].obs;
  RxList artistSongs = [].obs;
  RxList playlist = [].obs;
  RxList filteredSongs = [].obs;
  RxList currentPlayingList = [].obs;
  RxInt isPlayingIdx = 0.obs;
  RxInt isPlayingId = 0.obs;
  bool isRepeat = false; 
  bool isShuffle = false; 
  RxBool isPlaying = false.obs;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  getAllFiles() {
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = true}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    if(_hasPermission) {
      await getAllSongs();
      await getAlbumList();
      await getArtistList();
      await getPlayList();
      convertSecondsToDuration(nowPlaying.duration);
      // duration = formatTime(time);
    }
  }

  getAllSongs() async {
    var data = await audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true
    );
    allSongs(data);
    currentPlayingList(allSongs);
    nowPlaying = currentPlayingList[0];
    // if it is playing beforehand
    nowPlaying = read('nowPlaying') == '' ? allSongs[0] : SongModel(read('nowPlaying')) ;
    if(read('currentPlayingList') != ''){
      // currentPlayingList = read('currentPlayingList') == '' ? allSongs : read('currentPlayingList');
      List songs = read('currentPlayingList')
                            .map((songsData) =>
                              SongModel(songsData)
                            ).toList();
      currentPlayingList = RxList<dynamic>(songs);
    } else {
      currentPlayingList = allSongs;
    }
    isPlayingIdx(read('isPlayingIdx') == '' ? 0 : read('isPlayingIdx'));
  }

  getAlbumList() async {
    var data = await audioQuery.queryAlbums(
        sortType: AlbumSortType.ALBUM,
        orderType: OrderType.ASC_OR_SMALLER,
        // uriType: UriType.EXTERNAL,
        ignoreCase: true
      );
    albumList(data);
  }

  getArtistList() async {
    var data = await audioQuery.queryArtists(
        sortType: ArtistSortType.ARTIST,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true
      );
    artistSongs(data);
  }

  getPlayList() async {
    var data = await audioQuery.queryPlaylists(
      sortType: PlaylistSortType.PLAYLIST,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true
    );
    playlist(data);
  }

  getFilteredSongs(type, albumId, artistId, name) {
    var songs = [];
    for(var item in allSongs) {
      if(type == 'album') {                   // for albums
        if(item.albumId == albumId && item.artistId == artistId && item.isMusic) {
          songs.add(item);
        }
      } else if(type == 'artist') {
        if(item.artistId == artistId && item.isMusic) {
          songs.add(item);
        }
      }
    }
    filteredSongs(songs);
    Get.to(() => const FilteredSongs(), arguments: name);
  }

  playSong() {
    try {
      convertSecondsToDuration(nowPlaying.duration);
      audioPlayer.play(DeviceFileSource(nowPlaying.data));
      isPlayingId(nowPlaying.id);
      isPlaying(true);
      write('nowPlaying', nowPlaying.getMap);
      write('isPlayingIdx', isPlayingIdx.value);
    } catch(e) {
      isPlaying(false);
    }
  }

  pauseSong() {
    try {
      audioPlayer.pause();
      isPlaying(false);
    } catch(e) {
      isPlaying(false);
    }
  }

  resumeSong() {
    duration = convertSecondsToDuration(nowPlaying.duration);
    audioPlayer.resume();
    isPlaying(true);
  }

  addToNowPlaying(idx) {
    nowPlaying = currentPlayingList[idx];
    final songsData = currentPlayingList.map((song) {
      return song.getMap;
    }).toList();
    write('currentPlayingList', songsData);
    write('isPlayingIdx', idx);
    isPlayingIdx(idx);
    playSong();
  }

  prevSong() {
    if(isPlayingIdx.value > 0) {
      isPlayingIdx(isPlayingIdx.value - 1);
      nowPlaying = currentPlayingList[isPlayingIdx.value];
      playSong();
    } else {
      showMessage('This is the first song.');
      isPlaying(false);
    }
  }

  nextSong() {
    if(isShuffle) {
      shuffledList();
    } else {
      if(isPlayingIdx.value < currentPlayingList.length) {
        isPlayingIdx(isPlayingIdx.value + 1);
        nowPlaying = currentPlayingList[isPlayingIdx.value];
        playSong();
      } else {
        showMessage('This is the last song.');
        isPlaying(false);
      }
    }
  }

  songLoop() async {
    if(isRepeat == false) {
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      isRepeat = true;
      showMessage('Repeat this song');
    } else {
      await audioPlayer.setReleaseMode(ReleaseMode.release);
      isRepeat = false;
      showMessage('Repeat turned off');
    }
  }

  songShuffle() {
    if(isShuffle == false) {
      isShuffle = true;
      showMessage('Shuffle is on');
    } else {
      isShuffle = false;
      showMessage('Shuffle off');
    }
  }


  shuffledList() {
    var randomSongIdx = Random().nextInt(currentPlayingList.length + 1);
    isPlayingIdx(randomSongIdx);
    nowPlaying = currentPlayingList[randomSongIdx];
    playSong();
  }

  formatTime(value) {
    if(value is int) {
      convertSecondsToDuration(value);
    } else {
      if(value.inSeconds == 0) {
        return '00:00';
      } else {
        final hh = (value.inHours).toString().padLeft(2, '0');
        final mm = (value.inMinutes % 60).toString().padLeft(2, '0');
        final ss = (value.inSeconds % 60).toString().padLeft(2, '0');
        return hh != '00' ? '$hh:$mm:$ss' : '$mm:$ss';
      }
    }
  }

  convertSecondsToDuration(value) {
    duration  = Duration(milliseconds: value);
    return duration;
  }

  searchSong(name) async {
    var results = await audioQuery.queryWithFilters(
      name, 
      WithFiltersType.AUDIOS
    );
    allSongs(results.toSongModel());
  }

  // for playlist

  // addPlaylist(name) async {
    // bool success = await audioQuery.createPlaylist(name);
    // if(success) {
    //   getPlayList();
    // } else {
    //   showMessage('Failed to create PlayList');
    // }
  // }

  // removePlaylist(id) async {
  //   bool success = await audioQuery.removePlaylist(id);
  //   if(success) {
  //     getPlayList();
  //   } else {
  //     showMessage('Failed to create PlayList');
  //   }
  // }

  // renamePlaylist(id, name) async {
  //   try {
  //     var success = await audioQuery.renamePlaylist(id, name);
  //     if(success) {
  //       Get.back();
  //       Get.back();
  //       getPlayList();
  //       return true;
  //     } else {
  //       showMessage('Failed to create PlayList');
  //       return false;
  //     }
  //   } catch (e) {
  //     showMessage('Rename failed!!! \n Please try again later');
  //     return false;
  //   }
  // }

  // addToPlaylist(playlistId, audioId) async {
  //   try {
  //     var success = await audioQuery.addToPlaylist(playlistId, audioId);
  //     if(success) {
  //       getPlayList();
  //       return true;
  //     } else {
  //       showMessage('Failed to add to PlayList');
  //       return false;
  //     }
  //   } catch (e) {
  //     showMessage(e.toString());
  //   }
  // }

}