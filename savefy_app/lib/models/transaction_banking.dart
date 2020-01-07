import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savefy_app/util/state_user.dart';
import 'package:uuid/uuid.dart';

class TransactionBanking {

  String transactionId = Uuid().v1().toString();
  Timestamp dateTime = Timestamp.now();
  String userId;
  String accountId;
  int type;
  double amount;

  TransactionBanking({
    this.transactionId,
    this.dateTime,
    this.userId,
    this.accountId,
    this.type,
    this.amount
  });

  TransactionBanking.create({
    this.userId,
    this.accountId,
    this.type,
    this.amount
  });

  TransactionBanking transactionFromJson(String str) {
    final jsonData = json.decode(str);
    return TransactionBanking.fromJson(jsonData);
  }

  String transactionToJson(TransactionBanking data) {
    final dyn = data.toJson();
    return json.encode(dyn);
  }

  factory TransactionBanking.fromJson(Map<String, dynamic> json) => new TransactionBanking(
      transactionId: json["transactionId"],
      dateTime: json["dateTime"],
      userId: json["userId"],
      accountId: json["accountId"],
      type: json["type"],
      amount: json["amount"]
  );

  factory TransactionBanking.fromDocument(DocumentSnapshot doc) {
    return TransactionBanking.fromJson(doc.data);
  }

  Map<String, dynamic> toJson() => {
    "transactionId": transactionId,
    "dateTime": dateTime,
    "userId": userId,
    "accountId": accountId,
    "type": type,
    "amount": amount
  };

}