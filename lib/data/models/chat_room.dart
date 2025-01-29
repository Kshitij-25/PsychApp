import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  String? chatRoomId;
  String? userId;
  String? psychologistId;
  String? lastMessage;
  DateTime? lastMessageTimestamp;
  String? userAvatar;
  String? userFullName;
  String? psychologistAvatar;
  String? psychologistFullName;

  ChatRoom(
      {this.chatRoomId,
      this.userId,
      this.psychologistId,
      this.lastMessage,
      this.lastMessageTimestamp,
      this.userAvatar,
      this.userFullName,
      this.psychologistAvatar,
      this.psychologistFullName});

  ChatRoom.fromJson(Map<String, dynamic> json) {
    chatRoomId = json['chatRoomId'];
    userId = json['userId'];
    psychologistId = json['psychologistId'];
    lastMessage = json['lastMessage'];
    // lastMessageTimestamp = json['lastMessageTimestamp'];
    lastMessageTimestamp = (json['lastMessageTimestamp'] as Timestamp).toDate();
    userAvatar = json['userAvatar'];
    userFullName = json['userFullName'];
    psychologistAvatar = json['psychologistAvatar'];
    psychologistFullName = json['psychologistFullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatRoomId'] = this.chatRoomId;
    data['userId'] = this.userId;
    data['psychologistId'] = this.psychologistId;
    data['lastMessage'] = this.lastMessage;
    // data['lastMessageTimestamp'] = this.lastMessageTimestamp;
    data['lastMessageTimestamp'] = this.lastMessageTimestamp != null ? Timestamp.fromDate(this.lastMessageTimestamp!) : null;
    data['userAvatar'] = this.userAvatar;
    data['userFullName'] = this.userFullName;
    data['psychologistAvatar'] = this.psychologistAvatar;
    data['psychologistFullName'] = this.psychologistFullName;
    return data;
  }
}
