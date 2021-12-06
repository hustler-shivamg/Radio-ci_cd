// To parse this JSON data, do
//
//     final songModel = songModelFromJson(jsonString);

import 'dart:convert';

SongModel songModelFromJson(String str) => SongModel.fromJson(json.decode(str));

String songModelToJson(SongModel data) => json.encode(data.toJson());

class SongModel {
  SongModel({
    required this.idSong,
    this.idBroadcasted = -1,
    required this.idRadioStation,
    required this.songTitle,
    required this.songArtist,
    required this.songAlbum,
    required this.songGenre,
    required this.songImage,
    required this.songAudioUrl,
    required this.songYouTubeUrl,
    required this.songVideoUrl,
    required this.songDuration,
    required this.createdAt,
    required this.updatedAt,
    this.broadcast_datetime,
  });

  int idSong;
  int idBroadcasted;
  int idRadioStation;
  String songTitle;
  String songArtist;
  String songAlbum;
  String songGenre;
  String songImage;
  String songAudioUrl;
  String songYouTubeUrl;
  String songVideoUrl;
  String songDuration;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? broadcast_datetime;

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
        idSong: json["idSong"] == null ? -1 : json["idSong"],
        idBroadcasted:
            json["idBroadcasted"] == null ? -1 : json["idBroadcasted"],
        idRadioStation:
            json["idRadioStation"] == null ? -1 : json["idRadioStation"],
        songTitle: json["SongTitle"] == null ? "" : json["SongTitle"],
        songArtist: json["SongArtist"] == null ? "" : json["SongArtist"],
        songAlbum: json["SongAlbum"] == null ? "" : json["SongAlbum"],
        songGenre: json["SongGenre"] == null ? "" : json["SongGenre"],
        songImage: json["SongImage"] == null ? "" : json["SongImage"],
        songAudioUrl: json["SongAudioURL"] == null ? "" : json["SongAudioURL"],
        songYouTubeUrl:
            json["SongYouTubeURL"] == null ? "" : json["SongYouTubeURL"],
        songVideoUrl: json["SongVideoURL"] == null ? "" : json["SongVideoURL"],
        songDuration: json["SongDuration"] == null ? "" : json["SongDuration"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        broadcast_datetime: json["Broadcast_datetime"] == null
            ? null
            : DateTime.parse(json["Broadcast_datetime"]),
      );

  Map<String, dynamic> toJson() => {
        "idSong": idSong == null ? null : idSong,
        "idBroadcasted": idBroadcasted == null ? null : idBroadcasted,
        "idRadioStation": idRadioStation == null ? null : idRadioStation,
        "SongTitle": songTitle == null ? null : songTitle,
        "SongArtist": songArtist == null ? null : songArtist,
        "SongAlbum": songAlbum == null ? null : songAlbum,
        "SongGenre": songGenre == null ? null : songGenre,
        "SongImage": songImage == null ? null : songImage,
        "SongAudioURL": songAudioUrl == null ? null : songAudioUrl,
        "SongYouTubeURL": songYouTubeUrl == null ? null : songYouTubeUrl,
        "SongVideoURL": songVideoUrl == null ? null : songVideoUrl,
        "SongDuration": songDuration == null ? null : songDuration,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "Broadcast_datetime": broadcast_datetime == null
            ? null
            : broadcast_datetime!.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (other is! SongModel) {
      return false;
    }
    return idBroadcasted == other.idBroadcasted;
  }

  @override
  int get hashCode => idBroadcasted.hashCode;
}
