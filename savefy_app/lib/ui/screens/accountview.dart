import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
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
          child: Container (
            child: _buildForm(),
          ),
          inAsyncCall: _loadingVisible,
        ));
  }

  Widget _buildForm() {
    return ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {

          var controller = new MoneyMaskedTextController(precision: 2, initialValue: accounts[index].balance, leftSymbol: 'R\$ ');

          return Container(
              decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Theme.of(context).dividerColor))),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                leading: Container(
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(width: 1.0, color: Colors.black26))),
                    child: Icon(Icons.attach_money, color: Colors.black54),
                ),
                title: Text(
                  accounts[index].name,
                  style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
                ),
                subtitle: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(accounts[index].description, style: TextStyle(color: Colors.black54, height: 2.0)),
                      Text(S.of(context).amount + ": " + controller.text, style: TextStyle(color: Colors.blueGrey)),
                  ],
                  ),
                ),
              ),
          );
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
