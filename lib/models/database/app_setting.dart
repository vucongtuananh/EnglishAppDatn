class AppSetting {
  String? name;
  String? val;

  AppSetting({this.name, this.val});

  AppSetting.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    val = json['val'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['val'] = this.val;
    return data;
  }
}
