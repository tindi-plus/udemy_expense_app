import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:udemy_expense_app/widgets/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function newTx;

  NewTransaction(this.newTx, {super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? chosenDate;

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).viewInsets.bottom);
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            top: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) => submitData(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        chosenDate == null
                            ? 'No Date Chosen!'
                            : 'Date Picked: ${DateFormat.yMd().format(chosenDate as DateTime)}',
                      ),
                    ),
                    AdaptiveFlatButton('Choose Date', presentDatePicker)
                  ],
                ),
              ),
              TextButton(
                onPressed: submitData,
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(Colors.purple)),
                child: const Text('Add Transaction'),
              )
            ],
          ),
        ),
      ),
    );
  }

  submitData() {
    if (titleController.text.isEmpty ||
        double.parse(amountController.text) < 0 ||
        chosenDate == null) {
      return;
    }
    widget.newTx(
      titleController.text,
      double.parse(amountController.text),
      chosenDate,
    );
    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((selectedDate) {
      if (selectedDate == null) {
        return;
      }

      setState(() {
        chosenDate = selectedDate;
      });
    });
  }
}
