class APIModel {
  int statuscode = 0;
  int type = 0; //to manage multiple calls

  bool response = false; //success or failure
  String msg = ''; //failure msg
  var data; //response data
  APIModel();

  APIModel.fromJSON(Map<String, dynamic> jsonMap) {
    statuscode = jsonMap['statuscode'] ?? 0;
    response = jsonMap['response'] ?? false;
    type = jsonMap['type'] ?? 0;

    msg = jsonMap['msg'] ?? '';
    data = jsonMap['data'] ?? null;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["statuscode"] = statuscode;
    map["response"] = response;
    map["type"] = type;

    map["msg"] = msg;
    map["data"] = data;

    return map;
  }
}
