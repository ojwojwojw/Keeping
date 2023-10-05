
class Ddd {
  int? id;
  String? name;
  int? money;
  int? balance;
  String? createdDate;

  Ddd({this.id, this.name, this.money, this.balance, this.createdDate});

  Ddd.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["money"] is int) {
      money = json["money"];
    }
    if(json["balance"] is int) {
      balance = json["balance"];
    }
    if(json["createdDate"] is String) {
      createdDate = json["createdDate"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["money"] = money;
    _data["balance"] = balance;
    _data["createdDate"] = createdDate;
    return _data;
  }
}