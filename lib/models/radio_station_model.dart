/// idRadioStation : 1
/// RadioStationName : "Radio Jan Usa"
/// RadioStationLogo : "https://demoproject.club/radio-app/public/storage/images/RadioStationLogo/img_1636613570.png"
/// RadioStationSlogan : "radio jan"
/// RadioStationAddress : "671 W Broadway, Glendale, CA 91204"
/// RadioStationContacts : null
/// RadioStationEmail : null
/// RadioStationcol : null
/// deleted_at : null
/// created_at : "2021-11-09T03:01:43.000000Z"
/// updated_at : "2021-11-11T06:52:50.000000Z"
/// streams : {"idRadioStation_Settings":1,"idRadioStation":1,"RadioStation_AudioURL":"https://streamingv2.shoutcast.com/radio-jan","RadioStation_CountryList":"226,225","RadioStation_VideoURL":"https://www.youtube.com/watch?v=vSXrIOkRPbc","Active":1,"deleted_at":null,"created_at":null,"updated_at":null,"country_list":[[{"id":226,"iso":"US","name":"UNITED STATES","nicename":"United States","iso3":"USA","numcode":"840","phonecode":"1","created_at":null,"updated_at":null}],[{"id":225,"iso":"GB","name":"UNITED KINGDOM","nicename":"United Kingdom","iso3":"GBR","numcode":"826","phonecode":"44","created_at":null,"updated_at":null}]]}

class RadioStationModel {
  RadioStationModel({
      this.idRadioStation, 
      this.radioStationName, 
      this.radioStationLogo, 
      this.radioStationSlogan, 
      this.radioStationAddress, 
      this.radioStationContacts, 
      this.radioStationEmail, 
      this.radioStationcol, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt, 
      this.streams,});

  RadioStationModel.fromJson(dynamic json) {
    idRadioStation = json['idRadioStation'];
    radioStationName = json['RadioStationName'];
    radioStationLogo = json['RadioStationLogo'];
    radioStationSlogan = json['RadioStationSlogan'];
    radioStationAddress = json['RadioStationAddress'];
    radioStationContacts = json['RadioStationContacts'];
    radioStationEmail = json['RadioStationEmail'];
    radioStationcol = json['RadioStationcol'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    streams = json['streams'] != null ? Streams.fromJson(json['streams']) : null;
  }
  int? idRadioStation;
  String? radioStationName;
  String? radioStationLogo;
  String? radioStationSlogan;
  String? radioStationAddress;
  dynamic radioStationContacts;
  dynamic radioStationEmail;
  dynamic radioStationcol;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  Streams? streams;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idRadioStation'] = idRadioStation;
    map['RadioStationName'] = radioStationName;
    map['RadioStationLogo'] = radioStationLogo;
    map['RadioStationSlogan'] = radioStationSlogan;
    map['RadioStationAddress'] = radioStationAddress;
    map['RadioStationContacts'] = radioStationContacts;
    map['RadioStationEmail'] = radioStationEmail;
    map['RadioStationcol'] = radioStationcol;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (streams != null) {
      map['streams'] = streams?.toJson();
    }
    return map;
  }

}

/// idRadioStation_Settings : 1
/// idRadioStation : 1
/// RadioStation_AudioURL : "https://streamingv2.shoutcast.com/radio-jan"
/// RadioStation_CountryList : "226,225"
/// RadioStation_VideoURL : "https://www.youtube.com/watch?v=vSXrIOkRPbc"
/// Active : 1
/// deleted_at : null
/// created_at : null
/// updated_at : null
/// country_list : [[{"id":226,"iso":"US","name":"UNITED STATES","nicename":"United States","iso3":"USA","numcode":"840","phonecode":"1","created_at":null,"updated_at":null}],[{"id":225,"iso":"GB","name":"UNITED KINGDOM","nicename":"United Kingdom","iso3":"GBR","numcode":"826","phonecode":"44","created_at":null,"updated_at":null}]]

class Streams {
  Streams({
      this.idRadioStationSettings, 
      this.idRadioStation, 
      this.radioStationAudioURL, 
      this.radioStationCountryList, 
      this.radioStationVideoURL, 
      this.active, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt, 
      this.countryList,});

  Streams.fromJson(dynamic json) {
    idRadioStationSettings = json['idRadioStation_Settings'];
    idRadioStation = json['idRadioStation'];
    radioStationAudioURL = json['RadioStation_AudioURL'];
    radioStationCountryList = json['RadioStation_CountryList'];
    radioStationVideoURL = json['RadioStation_VideoURL'];
    active = json['Active'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['country_list'] != null) {
      countryList = [];
      json['country_list'].forEach((v) {
        countryList?.add(Country_list.fromJson(v));
      });
    }
  }
  int? idRadioStationSettings;
  int? idRadioStation;
  String? radioStationAudioURL;
  String? radioStationCountryList;
  String? radioStationVideoURL;
  int? active;
  dynamic deletedAt;
  dynamic createdAt;
  dynamic updatedAt;
  List<Country_list>? countryList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idRadioStation_Settings'] = idRadioStationSettings;
    map['idRadioStation'] = idRadioStation;
    map['RadioStation_AudioURL'] = radioStationAudioURL;
    map['RadioStation_CountryList'] = radioStationCountryList;
    map['RadioStation_VideoURL'] = radioStationVideoURL;
    map['Active'] = active;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (countryList != null) {
      map['country_list'] = countryList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 226
/// iso : "US"
/// name : "UNITED STATES"
/// nicename : "United States"
/// iso3 : "USA"
/// numcode : "840"
/// phonecode : "1"
/// created_at : null
/// updated_at : null

class Country_list {
  Country_list({
      this.id, 
      this.iso, 
      this.name, 
      this.nicename, 
      this.iso3, 
      this.numcode, 
      this.phonecode, 
      this.createdAt, 
      this.updatedAt,});

  Country_list.fromJson(dynamic json) {
    id = json['id'];
    iso = json['iso'];
    name = json['name'];
    nicename = json['nicename'];
    iso3 = json['iso3'];
    numcode = json['numcode'];
    phonecode = json['phonecode'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? iso;
  String? name;
  String? nicename;
  String? iso3;
  String? numcode;
  String? phonecode;
  dynamic createdAt;
  dynamic updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['iso'] = iso;
    map['name'] = name;
    map['nicename'] = nicename;
    map['iso3'] = iso3;
    map['numcode'] = numcode;
    map['phonecode'] = phonecode;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}