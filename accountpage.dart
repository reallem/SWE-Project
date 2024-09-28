// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'balance_service.dart';
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
      theme: ThemeData.dark(),
      home: AccountPage(),
    );
  }
}

class AccountPage extends StatefulWidget {
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final BalanceService _balanceService = BalanceService();
  QuerySnapshot<Map>? accounts;
  bool loading = false;

  List<List<Color>> colors = const [
    [
      Color(0x7067E8FF),
      Color(0xFF7C85C3),
      Color(0xFF7067E8),
      Color(0x7aca4dff)
    ],
    [
      Color(0xffac70ac),
      Color(0xffed7ebd),
      Color(0xfffab0bf),
      Color(0xffffb1c0),
    ]
  ];

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    loading = true;
    try {
      accounts = await _balanceService.getUserAccount();
    } catch (e) {
      // Handle errors
    }
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('My Cards'),
        backgroundColor: Colors.black,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: accounts!.docs.length,
                      itemBuilder: (context, index) {
                        return AccountCard(
                            accountType:
                                '${accounts!.docs[index]['type']} Account',
                            balance:
                                accounts!.docs[index]['balance'].toString(),
                            gradientColors: colors[index % 2]);
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  AddAccountButton(),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class AccountCard extends StatelessWidget {
  final String accountType;
  final String balance;
  final List<Color> gradientColors;

  const AccountCard({
    required this.accountType,
    required this.balance,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              accountType,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Balance',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$balance SAR',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add),
      label: const Text('Add New Account'),
      style: ElevatedButton.styleFrom(
          //iconColor: Colors.grey,

          ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      child: BottomAppBar(
        color: Colors.grey[800],
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_circle_outline), // Deposit icon
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DepositScreen()),
                );
              },
              color: Colors.white, // Same color as home icon
            ),
            IconButton(
              icon: const Icon(Icons.account_balance_wallet), // Wallet icon
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountPage()),
                );
                // Handle wallet action here
              },
              color: Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                MaterialPageRoute(builder: (context) => BankHomePage());
              },
              color: Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline), // Withdrawal icon
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DepositScreen()), //this is supposed 2 b withdraw
                );
              },
              color: Colors.white, // Same color as home icon
            ),
            IconButton(
              icon: const Icon(Icons.compare_arrows), // Transfer icon
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TransferScreen()),
                );
              },
              color: Colors.white, // Same color as home icon
            ),
          ],
        ),
      ),
    );
  }
}
