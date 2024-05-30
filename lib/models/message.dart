class Message {
 late  String toId;
 late  String msgId;
 late  String msg;
 late  String read;
 late  String fromId;
 late  String sent;
 late  String type;

  Message({
    required this.toId,
    required this.msgId,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sent,
  });




  Message.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    msgId=json['msgId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    type = json['type'].toString();
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['msgId']=msgId;
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type;
    data['fromId'] = fromId;
    data['sent'] = sent;
    return data;
  }
}
