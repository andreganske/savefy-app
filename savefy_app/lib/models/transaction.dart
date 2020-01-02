import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Transaction {

  String transactionId = Uuid().v1().toString();
  Timestamp dateTime = Timestamp.now();
  String accountId;
  String fromUserId;
  double amount;

  Transaction({
    this.transactionId,
    this.dateTime,
    this.accountId,
    this.fromUserId,
    this.amount
  });

  Transaction transactionFromJson(String str) {
    final jsonData = json.decode(str);
    return Transaction.fromJson(jsonData);
  }

  String transactionToJson(Transaction data) {
    final dyn = data.toJson();
    return json.encode(dyn);
  }

  factory Transaction.fromJson(Map<String, dynamic> json) => new Transaction(
      transactionId: json["transactionId"],
      dateTime: json["dateTime"],
      accountId: json["accountId"],
      fromUserId: json["fromUserId"],
      amount: json["amount"]
  );

  factory Transaction.fromDocument(DocumentSnapshot doc) {
    return Transaction.fromJson(doc.data);
  }

  Map<String, dynamic> toJson() => {
    "transactionId": transactionId,
    "dateTime": dateTime,
    "accountId": accountId,
    "fromUserId": fromUserId,
    "amount": amount
  };

}