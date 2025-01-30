import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String? messageId;
  String? senderId;
  // String? receiverId;
  String? message;
  DateTime? timestamp;

  ChatMessage({
    this.messageId,
    this.senderId,
    // this.receiverId,
    this.message,
    this.timestamp,
  });

  ChatMessage.fromJson(Map<String, dynamic> json) {
    messageId = json['messageId'];
    senderId = json['senderId'];
    // // receiverId = json['receiverId'];
    message = json['message'];
    timestamp = (json['timestamp'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageId'] = this.messageId;
    data['senderId'] = this.senderId;
    // data['receiverId'] = this.receiverId;
    data['message'] = this.message;
    data['timestamp'] = Timestamp.fromDate(timestamp!);
    return data;
  }
}
