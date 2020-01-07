import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Account {

  String accountId;
  String name;
  String description;
  double balance;

  Account({
    this.accountId,
    this.name,
    this.description,
    this.balance
  });

  Account accountFromJson(String str) {
    final jsonData = json.decode(str);
    return Account.fromJson(jsonData);
  }

  String accountToJson(Account data) {
    final dyn = data.toJson();
    return json.encode(dyn);
  }

  factory Account.fromJson(Map<String, dynamic> json) => new Account(
    accountId: json["accountId"],
    name: json["name"],
    description: json["description"],
    balance: json["balance"]
  );

  factory Account.fromDocument(DocumentSnapshot doc) {
    return Account.fromJson(doc.data);
  }

  Map<String, dynamic> toJson() => {
    "accountId": accountId,
    "name": name,
    "description": description,
    "balance": balance,
  };

}