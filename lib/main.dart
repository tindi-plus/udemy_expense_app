import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:udemy_expense_app/widgets/chart.dart';
import 'package:udemy_expense_app/widgets/new_transaction.dart';
import 'package:udemy_expense_app/widgets/transaction_list.dart';

import 'models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'OpenSans',
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.purple,
        ),
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 25,
          fontWeight: FontWeight.bold,
        )),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    //  Transaction(
    //    amount: 24.9,
    //    date: DateTime.now(),
    //    id: 'we234',
    //    title: 'New Shoes',
    //  ),
    //  Transaction(
    //    amount: 67.4,
    //    date: DateTime.now(),
    //    id: 'hds673',
    //    title: 'We Aliens: John Coady',
    //  ),
  ];
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((element) {
      return element.date.isAfter(DateTime.now().subtract(const Duration(
        days: 7,
      )));
    }).toList();
  }

  // print('${_recentTransactions.length}');

  void newTx(
    String title,
    double amount,
    DateTime chosenDate,
  ) {
    final txn = Transaction(
        amount: amount,
        date: chosenDate,
        id: DateTime.now().toString(),
        title: title);

    setState(() {
      _userTransactions.add(txn);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(newTx),
          );
        });
  }

  void deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(double availableDeviceHeight) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).backgroundColor,
              value: _showChart,
              onChanged: ((value) {
                setState(() {
                  _showChart = value;
                });
              })),
        ],
      ),
      _showChart
          ? Container(
              height: availableDeviceHeight * 0.8,
              child: Chart(_recentTransactions))
          : Container(
              height: availableDeviceHeight * 0.7,
              child: TransactionList(
                userTransactions: _userTransactions,
                delFunc: deleteTransaction,
              ),
            ),
    ];
  }

  List<Widget> _buildPortraitContent(double availableDeviceHeight) {
    return [
      Container(
          height: availableDeviceHeight * 0.3,
          child: Chart(_recentTransactions)),
      Container(
        height: availableDeviceHeight * 0.7,
        child: TransactionList(
          userTransactions: _userTransactions,
          delFunc: deleteTransaction,
        ),
      )
    ];
  }

  PreferredSizeWidget _buildCupertinoNavigationBar() {
    return CupertinoNavigationBar(
      middle: const Text('Personal Expenses'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              _startAddNewTransaction(context);
            },
            child: const Icon(CupertinoIcons.add),
          )
        ],
      ),
    ) as PreferredSizeWidget;
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Personal Expenses'),
      actions: [
        IconButton(
          onPressed: () {
            _startAddNewTransaction(context);
          },
          icon: const Icon(Icons.add),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandScapeMode =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar =
        Platform.isIOS ? _buildCupertinoNavigationBar() : _buildAppBar();

    var availableDeviceHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            if (isLandScapeMode)
              ..._buildLandscapeContent(availableDeviceHeight),
            if (!isLandScapeMode)
              ..._buildPortraitContent(availableDeviceHeight),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      _startAddNewTransaction(context);
                    },
                    child: const Icon(Icons.add),
                  ),
            body: pageBody,
          );
  }
}
