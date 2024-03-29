class Material {
  String? id;
  String? classHours;
  String? classUrl;
  String? classModuleId;
  String? createdDate;
  String? updatedDate;

  Material(
      {this.id,
      this.classHours,
      this.classUrl,
      this.classModuleId,
      this.createdDate,
      this.updatedDate});

  Material.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classHours = json['classHours'];
    classUrl = json['classUrl'];
    classModuleId = json['classModuleId'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['classHours'] = this.classHours;
    data['classUrl'] = this.classUrl;
    data['classModuleId'] = this.classModuleId;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}
