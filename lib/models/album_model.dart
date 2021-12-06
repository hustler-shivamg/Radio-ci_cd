// To parse this JSON data, do
//
//     final albumModel = albumModelFromJson(jsonString);

import 'dart:convert';

AlbumModel albumModelFromJson(String str) => AlbumModel.fromJson(json.decode(str));

String albumModelToJson(AlbumModel data) => json.encode(data.toJson());

class AlbumModel {
  AlbumModel({
    required this.idPrograms,
    required this.idRadioStation,
    required this.programTitle,
    required this.programImage,
    required this.youTubePlayListUrl,
    required this.active,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int idPrograms;
  int idRadioStation;
  String programTitle;
  String programImage;
  String youTubePlayListUrl;
  int active;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory AlbumModel.fromJson(Map<String, dynamic> json) => AlbumModel(
    idPrograms: json["idPrograms"] == null ? null : json["idPrograms"],
    idRadioStation: json["idRadioStation"] == null ? null : json["idRadioStation"],
    programTitle: json["ProgramTitle"] == null ? null : json["ProgramTitle"],
    programImage: json["ProgramImage"] == null ? null : json["ProgramImage"],
    youTubePlayListUrl: json["YouTubePlayListURL"] == null ? null : json["YouTubePlayListURL"],
    active: json["Active"] == null ? null : json["Active"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "idPrograms": idPrograms == null ? null : idPrograms,
    "idRadioStation": idRadioStation == null ? null : idRadioStation,
    "ProgramTitle": programTitle == null ? null : programTitle,
    "ProgramImage": programImage == null ? null : programImage,
    "YouTubePlayListURL": youTubePlayListUrl == null ? null : youTubePlayListUrl,
    "Active": active == null ? null : active,
    "deleted_at": deletedAt,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}
