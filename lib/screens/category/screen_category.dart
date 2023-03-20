import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/screens/category/expense_category_list.dart';
import 'package:money_manager/screens/category/income_category_list.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    CategoryDb().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            controller: _tabController,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.green,
            tabs: [
              const Tab(
                text: 'INCOME',
              ),
              const Tab(
                text: 'EXPENSE',
              )
            ]),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: [const IncomeCategoryList(), const ExpenseCategoryList()],
        ))
      ],
    );
  }
}
