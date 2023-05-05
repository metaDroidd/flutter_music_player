import '../models/song_model.dart';

class Playlist {
  final String title;
  final List<Song> songs;
  final String imageUrl;

  Playlist({
    required this.title,
    required this.songs,
    required this.imageUrl,
    }
  );

  static List<Playlist> playlists = [
    Playlist(
      title: 'Hip-Hop R&B Mix',
      songs: Song.songs,
      imageUrl: 'https://images.unsplash.com/photo-1543384966-a56a575695c9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1590&q=80',
    ),
    Playlist(
      title: 'Rock & Roll',
      songs: Song.songs,
      imageUrl: 'https://images.unsplash.com/photo-1523456752049-9ccb633594bf?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
    ),
    Playlist(
      title: 'Techno',
      songs: Song.songs,
      imageUrl: 'https://images.unsplash.com/photo-1578736641330-3155e606cd40?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
    ),
  ];
}