import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:xylophone_app/data/model/song_model.dart';
import 'package:xylophone_app/domain/entities/song.dart';

class MediaProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Song> _playlist = SongModel.getSampleSongs();

  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final List<StreamSubscription> _subs = [];

  List<Song> get playlist => _playlist;
  Song? get currentSong =>
      _playlist.isNotEmpty ? _playlist[_currentIndex] : null;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;
  int get currentIndex => _currentIndex;

  MediaProvider() {
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    // real duration paoa gele
    _subs.add(_audioPlayer.onDurationChanged.listen((newDuration) {
      _duration = newDuration;
      notifyListeners();
    }));

    // position update
    _subs.add(_audioPlayer.onPositionChanged.listen((newPosition) {
      _position = newPosition;
      notifyListeners();
    }));

    // play / pause / stop / complete
    _subs.add(_audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    }));

    // gaan shesh hole automatic next
    _subs.add(_audioPlayer.onPlayerComplete.listen((_) {
      playNext();
    }));
  }

  Future<void> _playCurrentSong() async {
    final song = currentSong;
    if (song == null) return;

    try {
      _position = Duration.zero;
      _duration = Duration(seconds: song.durationSeconds);
      notifyListeners();

      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(song.url));
    } catch (e) {
      debugPrint('Play error: $e');
    }
  }

  Future<void> playPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else if (_audioPlayer.state == PlayerState.paused) {
        await _audioPlayer.resume();
      } else {
        await _playCurrentSong();
      }
    } catch (e) {
      debugPrint('playPause error: $e');
    }
  }

  Future<void> playSongAtIndex(int index) async {
    if (index >= 0 && index < _playlist.length) {
      _currentIndex = index;
      await _playCurrentSong();
    }
  }

  Future<void> playNext() async {
    if (_playlist.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _playlist.length;
    await _playCurrentSong();
  }

  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    await _playCurrentSong();
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      debugPrint('seek error: $e');
    }
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _audioPlayer.dispose();
    super.dispose();
  }
}