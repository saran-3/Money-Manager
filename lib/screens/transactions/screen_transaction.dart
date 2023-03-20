import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';

import '../../db/transaction/transaction_db.dart';
import '../../models/transaction/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDb.instance.refreshUI();
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final _value = newList[index];
              return Slidable(
                key: Key(_value.id!),
                startActionPane:
                    ActionPane(motion: const ScrollMotion(), children: [
                  SlidableAction(
                    onPressed: (ctx) {
                      TransactionDB.instance.deleteTransaction(_value.id!);
                    },
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ]),
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        parseDate(_value.date),
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: _value.type == CategoryType.income
                          ? Colors.green
                          : Colors.red,
                      radius: 50,
                    ),
                    title: Text('Rs ${_value.amount}'),
                    subtitle:
                        // Text('${_value.category.name}\n${_value.category.type}'),
                        Text('${_value.category.name}'),
                        
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 1,
              );
            },
            itemCount: newList.length);
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splittedDate = _date.split(' ');
    // return '${_splittedDate.last} ' '${_splittedDate.length - 1} \n${_splittedDate.first}';
    return '${_splittedDate.last} \n${_splittedDate.first}';
    // return _date;
    // return '${date.day}\n${date.month}';
  }
}
