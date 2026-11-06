import 'package:xylophone_app/domain/entities/song.dart';

class SongModel extends Song{
 const SongModel({
    required super.title,
    required super.artist,
    required super.url,
    required super.durationSeconds
 });

 static List<Song> getSampleSongs() {
   return const [
     SongModel(
       title: 'Hariye Jai',
       artist: 'Souls',
       url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
       durationSeconds: 372,
     ),
     SongModel(
       title: 'Fera',
       artist: 'Miles',
       url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
       durationSeconds: 372,
     ),
     SongModel(
       title: 'Osomapto',
       artist: 'Warfaze',
       url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
       durationSeconds: 372,
     ),
   ];
 }
}