/// educations : [{"id":1,"name":"Միջին"},{"id":2,"name":"Բարձր"},{"id":3,"name":"Բակալավր"},{"id":4,"name":"Մագիստրոսներ"}]
/// languages : [{"id":1,"name":"Անգլերեն"},{"id":2,"name":"Ֆրանսերեն"}]
/// occupations : [{"id":1,"name":"աշխատանք"},{"id":2,"name":"Բիզնես"}]
/// workExperiences : [{"id":1,"name":"Նորածիններ"},{"id":2,"name":"մանկահասակ երեխաներ"},{"id":3,"name":"դպրոցական տարիքը"},{"id":4,"name":"16+ տարի"}]
/// categories : [{"id":1,"category_name":"Խնամողներ","category_image":"http://3.228.39.224/hippo/public/storage/images/category/img_1621579217.png","type":"service_provider","sub_categories_count":1},{"id":2,"category_name":"Մանկապարտեզներ","category_image":"http://3.228.39.224/hippo/public/storage/images/category/img_1621579535.png","type":"business","sub_categories_count":1},{"id":3,"category_name":"Վարորդներ","category_image":"http://3.228.39.224/hippo/public/storage/images/category/img_1621579484.png","type":"service_provider","sub_categories_count":1},{"id":4,"category_name":"մանկաբույժներ","category_image":"http://3.228.39.224/hippo/public/storage/images/category/img_1621579555.png","type":"service_provider","sub_categories_count":2},{"id":5,"category_name":"Ժամանց","category_image":"http://3.228.39.224/hippo/public/storage/images/category/img_1621579511.png","type":"business","sub_categories_count":3},{"id":6,"category_name":"Այլ ծառայություններ","category_image":"http://3.228.39.224/hippo/public/storage/images/category/img_1621579391.png","type":"business","sub_categories_count":5}]
/// state : [[{"id":1,"name":"Yerevan"},{"id":2,"name":"Shirak"},{"id":3,"name":"Armavir"},{"id":4,"name":"Lori"},{"id":5,"name":"Ararat"},{"id":6,"name":"Kotayk"},{"id":7,"name":"Gegharkunik"},{"id":8,"name":"Syunik"},{"id":9,"name":"Aragatsotn"},{"id":10,"name":"Tavush"},{"id":11,"name":"Vayots Dzor"}]]
import 'package:get/get.dart';

class DropDownResult {
  List<DropdownValues>? educations;
  List<DropdownValues>? languages;
  List<DropdownValues>? occupations;
  List<DropdownValues>? workExperiences;
  List<DropdownValues>? categories;
  List<DropdownValues>? state;

  DropDownResult(
      {this.educations,
      this.languages,
      this.occupations,
      this.workExperiences,
      this.categories,
      this.state});

  DropDownResult.fromJson(dynamic json) {
    if (json["educations"] != null) {
      educations = [];
      json["educations"].forEach((v) {
        educations?.add(DropdownValues.fromJson(v));
      });
    }
    if (json["languages"] != null) {
      languages = [];
      json["languages"].forEach((v) {
        languages?.add(DropdownValues.fromJson(v));
      });
    }
    if (json["occupations"] != null) {
      occupations = [];
      json["occupations"].forEach((v) {
        occupations?.add(DropdownValues.fromJson(v));
      });
    }
    if (json["workExperiences"] != null) {
      workExperiences = [];
      json["workExperiences"].forEach((v) {
        workExperiences?.add(DropdownValues.fromJson(v));
      });
    }
    if (json["categories"] != null) {
      categories = [];
      json["categories"].forEach((v) {
        categories?.add(DropdownValues.fromJson(v));
      });
    }
    if (json["state"] != null) {
      state = [];
      json["state"].forEach((v) {
        state?.add(DropdownValues.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (educations != null) {
      map["educations"] = educations?.map((v) => v.toJson()).toList();
    }
    if (languages != null) {
      map["languages"] = languages?.map((v) => v.toJson()).toList();
    }
    if (occupations != null) {
      map["occupations"] = occupations?.map((v) => v.toJson()).toList();
    }
    if (workExperiences != null) {
      map["workExperiences"] = workExperiences?.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      map["categories"] = categories?.map((v) => v.toJson()).toList();
    }
    if (state != null) {
      map["state"] = state?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class DropdownValues {
  int? id;
  String? name;

  DropdownValues({this.id, this.name});

  DropdownValues.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"] ?? json["category_name"] ?? "";
  }

  DropdownValues.all() {
    id = -1;
    name = "All".tr;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    return map;
  }

  @override
  bool operator ==(Object other) {
    if (!(other is DropdownValues)) {
      return false;
    }
    return this.id == other.id;
  }
}
