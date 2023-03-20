import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/screens/add_transaction/screen_add_transaction.dart';
import 'package:money_manager/screens/category/category_add_popup.dart';
import 'package:money_manager/screens/home/widgets/bottom_navigation.dart';

import 'category/screen_category.dart';
import 'transactions/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = [const ScreenTransaction(), const ScreenCategory()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: const Text('MONEY MANAGER'),
        centerTitle: true,
        shadowColor: Colors.red,
      ),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            if (selectedIndexNotifier.value == 0) {
              print('Add Transaction');
              Navigator.of(context).pushNamed(ScreenaddTransaction.routeName);
            } else {
              print('Add Category');
              showCategoryAddPopup(context);
              // final _sample = CategoryModel(
              //     id: DateTime.now().millisecondsSinceEpoch.toString(),
              //     name: 'Travel',
              //     type: CategoryType.expense);
              // CategoryDb().insertCategory(_sample);
            }
          }),
    );
  }
}
