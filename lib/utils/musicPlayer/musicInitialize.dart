import 'dart:convert';
import 'dart:developer';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/hiveStorage.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/repository/repo.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/playerModel.dart';
import 'package:audio_session/audio_session.dart';

AudioPlayer? player;
ConcatenatingAudioSource? playlist;

class MusicInitialize {
  final PlayerModel? playerModel;

  MusicInitialize({this.playerModel});

  static int _nextMediaId = 0;

  bool newStreaming = false;
  int streamingId = -1;

  void _addPlaylist() {
    _nextMediaId = 0;
    playlist = ConcatenatingAudioSource(children: [
      for (var data in playerModel!.data!)
        AudioSource.uri(
          data.isFileLocal!
              ? Uri.file("${data.filepath}")
              : Uri.parse("${data.filepath}"),
          tag: MediaItem(
              id: '${_nextMediaId++}',
              artist: "${data.stageName}",
              // album: "${data.stageName}",
              title: "${data.title}",
              artUri: Uri.parse("${data.thumb}"),
              extras: {
                "isCoverLocal": data.isCoverLocal,
                "isFileLocal": data.isFileLocal,
                "contentId": data.id,
                "filepath": data.filepath,
                // "cover": data.cover,
                // "lyrics": data.lyrics,
                // "description": data.description,
                // "playerData": data,
              }),
        ),
    ]);
  }

  Future<void> init() async {
    _addPlaylist();
    player = AudioPlayer();

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    player!.playbackEventStream.listen((event) {
      if (event.processingState.name == ProcessingState.ready.name) {
        if (streamingId != event.currentIndex && !newStreaming) {
          newStreaming = true;
          streamingId = event.currentIndex!;
          _recordRecentPlay();
          _recordStream();
        }
      }
    }, onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await player!.setAudioSource(playlist!);
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }
  }

  Future<void> _recordRecentPlay() async {
    Map<dynamic, dynamic> meta = {
      "id": playerModel!.data![streamingId].id,
      "data": playerModel!.data![streamingId].toJson(),
    };
    String? encodedData = await getHive("recentPlaySingles");
    if (encodedData == null) {
      await saveHive(key: "recentPlaySingles", data: json.encode([meta]));
    } else {
      List<dynamic> decodedData = json.decode(encodedData);
      List<Map<dynamic, dynamic>> metaList =
          decodedData.cast<Map<dynamic, dynamic>>();

      for (int x = 0; x < metaList.length; ++x) {
        if (playerModel!.data![streamingId].id == metaList[x]["id"]) {
          metaList.removeAt(x);
        }
      }
      List<Map<dynamic, dynamic>> newMetaList = [meta] + metaList;
      await saveHive(key: "recentPlaySingles", data: json.encode(newMetaList));
      // log("encodedData $encodedData");
    }
    Repository repo = new Repository();
    repo.fetchRecentlyPlayedSingle();
  }

  void _recordStream() {
    newStreaming = false;
    httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: STREAMMUSIC_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "userid": userModel!.data!.user!.userid,
          "post_id": playerModel!.data![streamingId].id,
        },
      ),
      showToastMsg: false,
    ).then((value) {
      log("stream record: $value");
    });
  }

  void dispose() => player!.dispose();
}
