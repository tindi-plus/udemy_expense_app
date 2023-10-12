import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';


class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.userTransaction,
    required this.delFunc,
  }) : super(key: key);

  final Transaction userTransaction;
  final Function delFunc;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 4,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: FittedBox(
                child: Text('\$${userTransaction.amount}')),
          ),
        ),
        title: Text(
          userTransaction.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
            DateFormat.yMMMd().format(userTransaction.date)),
        trailing: MediaQuery.of(context).size.width > 450
            ? TextButton.icon(
                onPressed: (() =>
                    delFunc(userTransaction.id)),
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all(Colors.red),
                ))
            : IconButton(
                onPressed: (() =>
                    delFunc(userTransaction.id)),
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
              ),
      ),
    );
  }
}
