// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_print, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'deposit.dart';
import 'homapage.dart';
import 'transfer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Withdraw Screen',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: WithdrawScreen(),
    );
  }
}

class WithdrawScreen extends StatelessWidget {
  TextEditingController accountController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  QuerySnapshot<Map<String, dynamic>>? accounts;
  double balance = 0;

  Future getUserAccount() async {
    accounts = await firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('accounts')
        .get();
  }

  Future setBalance() async {
    await getUserAccount();
    balance = 0.0;
    final hasDocument =
        accounts!.docs.any((doc) => doc.id == accountController.text.trim());

    if (!hasDocument) {
      Fluttertoast.showToast(msg: "Account does'nt exist!");
      return;
    }

    for (int i = 0; i < accounts!.docs.length; i++) {
      if (accountController.text.trim() == accounts!.docs[i].id) {
        balance = accounts!.docs[i]['balance'];
        break;
      }
    }
    if (double.parse(amountController.text.trim()) > balance) {
      Fluttertoast.showToast(msg: "You don't have enough balance!");
      return;
    }
    balance -= double.parse(amountController.text.trim());
    await firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('accounts')
        .doc(accountController.text.trim())
        .update({'balance': balance});
    Fluttertoast.showToast(msg: "Balance Withdrawal!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Withdrawal'),
      backgroundColor: Color(0xFF1C1B1F),
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A1A), Color(0xFF333333)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              16.0, kToolbarHeight - 20.0, 16.0, 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.0),
              buildAccountTextField(),
              SizedBox(height: 10.0),
              buildAmountTextField(),
              SizedBox(height: 50.0),
              buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAccountTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 50.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Account',
              style: TextStyle(
                color: Color(0xff817c7c),
                fontSize: 15,
              ),
            ),
          ),
        ),
        Container(
          width: 350.0,
          height: 40,
          child: TextField(
            controller: accountController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xff272626),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAmountTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 50.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Amount',
              style: TextStyle(
                color: Color(0xff817c7c),
                fontSize: 15,
              ),
            ),
          ),
        ),
        Container(
          width: 350.0,
          height: 40,
          child: TextField(
            controller: amountController,
            style: TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xff272626),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildConfirmButton() {
    return Center(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          gradient: LinearGradient(
            colors: [
              Color(0xffac70ac),
              Color(0xffed7ebd),
              Color(0xfffab0bf),
              Color(0xffffb1c0),
            ],
            stops: [0.45, 0.65, 0.93, 0.96],
            begin: Alignment(-3.0, -4.0),
            end: Alignment(1.1, 1.1),
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            setBalance();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) => Colors.transparent,
            ),
            elevation: MaterialStateProperty.resolveWith<double>(
              (states) => 0,
            ),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
              (states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.transparent;
                }
                return Colors.transparent;
              },
            ),
          ),
          child: Container(
            height: 52,
            child: Center(
              child: Text(
                "Confirm",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.5,
                  color: Color(0xff292727),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.compare_arrows),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
      ],
      selectedItemColor: Colors.pinkAccent,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.black,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DepositScreen()),
            );
            break;
          case 1:
            // Navigate to AccountPage
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BankHomePage()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WithdrawScreen()),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransferScreen()),
            );
            break;
        }
      },
    );
  }
}
