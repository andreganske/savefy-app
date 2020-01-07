import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savefy_app/models/transaction_banking.dart';
import 'package:savefy_app/models/user.dart';

class Expenses {

  static Firestore _firestore = Firestore.instance;

  static void createTransaction(User user, String accountId, int type, double amount) async {
    TransactionBanking transaction = new TransactionBanking.create(userId: user.userId, accountId: accountId, type: type, amount: amount);
    _firestore.document("transaction/${transaction.transactionId}").setData(transaction.toJson());
  }

}