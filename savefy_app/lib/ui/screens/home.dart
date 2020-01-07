import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:savefy_app/generated/i18n.dart';
import 'package:savefy_app/models/state.dart';
import 'package:savefy_app/service/expense.dart';
import 'package:savefy_app/ui/screens/sign_in.dart';
import 'package:savefy_app/ui/widgets/drawer.dart';
import 'package:savefy_app/ui/widgets/loading.dart';
import 'package:savefy_app/util/state_widget.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  StateModel appState;
  bool _loadingVisible = false;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildScaffold() {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: AppDrawer(),
        appBar: new AppBar(
            title: new Text(S.of(context).home)
        ),
        body: LoadingScreen(
          child: _createMainView(),
          inAsyncCall: _loadingVisible,
        ),
        floatingActionButton: _createButton()
    );
  }

  Widget _createButton() {
    return FloatingActionButton(
      onPressed: () {
        _addExpenseDialog(context);
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.green,
    );
  }

  Widget _createMainView() {
    return Container(
      child: Text("Olá " + appState.user.firstName + " " + appState.user.lastName),
    );
  }

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null) {
      return SignInScreen();
    } else {
      if (appState.isLoading) {
        _loadingVisible = true;
      } else {
        _loadingVisible = false;
      }
      return _buildScaffold();
    }
  }

  _addExpenseDialog(BuildContext context) {
    return showDialog<String> (
        context: context,
        builder: (BuildContext context) {

          var controller = new MoneyMaskedTextController();

          return AlertDialog(
            title: Text(S.of(context).add_expense.toUpperCase()),
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                      autofocus: true,
                      controller: controller,
                      keyboardType: TextInputType.number,
                      onChanged: (value) { },
                    ))
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(S.of(context).cancel.toUpperCase()),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(S.of(context).save.toUpperCase(),
                    style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  _newExpense(context, double.parse(controller.text.replaceAll(".", "").replaceAll(",", ".")));
                },
              ),
            ],
          );
        }
    );
  }

  _newExpense(BuildContext context, double amount) {
    print("amount: " + amount.toString());
    Navigator.of(context).pop();

    Expenses.createTransaction(appState.user, "1", 1, amount);
  }

}
