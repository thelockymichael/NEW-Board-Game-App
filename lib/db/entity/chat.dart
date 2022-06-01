import 'package:cloud_firestore/cloud_firestore.dart';
import 'message.dart';

class Chat {
  late String id;
  late String firstUserId;
  late String secondUserId;
  late Message? lastMessage;

  Chat(this.id, this.firstUserId, this.secondUserId, this.lastMessage);

  Chat.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot['id'];
    firstUserId = snapshot['firstUserId'];
    secondUserId = snapshot['secondUserId'];
    lastMessage = snapshot['last_message'] == null
        ? null
        : Message.fromMap(snapshot['last_message']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstUserId': firstUserId,
      'secondUserId': secondUserId,
      'last_message': lastMessage != null ? lastMessage!.toMap() : null,
    };
  }
}
