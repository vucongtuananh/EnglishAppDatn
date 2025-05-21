class Token {
  String? name;
  String? token;

  Token({this.name, this.token});

  Token.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['token'] = this.token;
    return data;
  }
}
