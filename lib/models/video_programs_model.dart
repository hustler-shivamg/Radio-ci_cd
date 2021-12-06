// To parse this JSON data, do
//
//     final videoProgramModel = videoProgramModelFromJson(jsonString);

import 'dart:convert';

VideoProgramModel videoProgramModelFromJson(String str) => VideoProgramModel.fromJson(json.decode(str));

String videoProgramModelToJson(VideoProgramModel data) => json.encode(data.toJson());

class VideoProgramModel {
  VideoProgramModel({
    required this.idProgrammPlayList,
    required this.idPrograms,
    required this.youTubeUrl,
    required this.videoUrl,
    required this.videoThumbnail,
    required this.videoTitle,
    required this.videoText,
    required this.active,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.programs,
  });

  int idProgrammPlayList;
  int idPrograms;
  String youTubeUrl;
  String videoUrl;
  String videoThumbnail;
  String videoTitle;
  String videoText;
  int active;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  Programs? programs;

  factory VideoProgramModel.fromJson(Map<String, dynamic> json) => VideoProgramModel(
    idProgrammPlayList: json["idProgrammPlayList"] == null ? null : json["idProgrammPlayList"],
    idPrograms: json["idPrograms"] == null ? null : json["idPrograms"],
    youTubeUrl: json["YouTubeURL"] == null ? "" : json["YouTubeURL"],
    videoUrl: json["VideoURL"] == null ? "" : json["VideoURL"],
    videoThumbnail: json["VideoThumbnail"] == null ? null : json["VideoThumbnail"],
    videoTitle: json["VideoTitle"] == null ? null : json["VideoTitle"],
    videoText: json["VideoText"] == null ? null : json["VideoText"],
    active: json["Active"] == null ? null : json["Active"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    programs: json["programs"] == null ? null : Programs.fromJson(json["programs"]),
  );

  Map<String, dynamic> toJson() => {
    "idProgrammPlayList": idProgrammPlayList == null ? null : idProgrammPlayList,
    "idPrograms": idPrograms == null ? null : idPrograms,
    "YouTubeURL": youTubeUrl == null ? null : youTubeUrl,
    "VideoURL": videoUrl,
    "VideoThumbnail": videoThumbnail == null ? null : videoThumbnail,
    "VideoTitle": videoTitle == null ? null : videoTitle,
    "VideoText": videoText == null ? null : videoText,
    "Active": active == null ? null : active,
    "deleted_at": deletedAt,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "programs": programs == null ? null : programs!.toJson(),
  };
}

class Programs {
  Programs({
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

  factory Programs.fromJson(Map<String, dynamic> json) => Programs(
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
