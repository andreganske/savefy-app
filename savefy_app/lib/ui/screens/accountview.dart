import 'package:flutter/material.dart';
import 'package:savefy_app/generated/i18n.dart';
import 'package:savefy_app/models/account.dart';
import 'package:savefy_app/models/state.dart';
import 'package:savefy_app/ui/screens/sign_in.dart';
import 'package:savefy_app/ui/widgets/drawer.dart';
import 'package:savefy_app/ui/widgets/loading.dart';
import 'package:savefy_app/util/state_widget.dart';

class AccountView extends StatefulWidget {
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  StateModel appState;
  bool _loadingVisible = false;

  List<Account> accounts;

  @override
  void initState() {
    super.initState();

  }

  Widget _buildScaffold() {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: AppDrawer(),
        appBar: new AppBar(
            title: new Text(S.of(context).account)
        ),
        body: LoadingScreen(
          child: _buildForm(),
          inAsyncCall: _loadingVisible,
        ));
  }

  Widget _buildForm() {
    return ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {

          return Card( //                           <-- Card widget
            child: ExpansionTile(
              leading: Icon(Icons.attach_money),
              title: Text(accounts[index].name),
              subtitle: Text(accounts[index].description),
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("seu saldo é de: " + accounts[index].balance.toString()))
                ]),
            );
          /*return ListTile(
            title: Text(accounts[index].name),
            subtitle: Text(accounts[index].description),
          );*/
    });
  }

  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null)) {
      return SignInScreen();
    } else {
      if (appState.isLoading) {
        _loadingVisible = true;
      } else {
        _loadingVisible = false;
      }

      accounts = getFakeAccounts();

      return _buildScaffold();
    }
  }

  List<Account> getFakeAccounts() {
    List<Account> accounts = new List();
    int count = 0;
    Account account;

    while (count < 5) {
      account = new Account(accountId: count.toString(), name: "Account "+ count.toString(), description: "savings" , balance: count*34/3);
      accounts.add(account);
      count++;
    }

    return accounts;




  }

}
