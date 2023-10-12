import 'package:flutter/material.dart';
import 'package:udemy_expense_app/models/transaction.dart';

import 'Transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function delFunc;

  TransactionList({
    super.key,
    required this.userTransactions,
    required this.delFunc,
  });

  @override
  Widget build(BuildContext context) {
    return userTransactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Text(
                  'There are no transactions yet!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.02,
                ),
                Container(
                    height: constraints.maxHeight * 0.7,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    )),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (context, index) {
              return TransactionItem(
                  userTransaction: userTransactions[index], delFunc: delFunc);
            },
            itemCount: userTransactions.length,
          );
  }
}
