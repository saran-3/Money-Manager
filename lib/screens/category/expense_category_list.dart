import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manager/db/category/category_db.dart';

import '../../models/category/category_model.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDb().expenseCategoryListListener,
        builder: (BuildContext ctx, List<CategoryModel> newlist, Widget? _) {
          return ListView.separated(
            itemBuilder: (ctx, index) {
              final Category = newlist[index];
              return Card(
                child: ListTile(
                  title: Text(Category.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: (() {
                      CategoryDb.instance.deleteCategory(Category.id);
                    }),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: newlist.length,
          );
        });
  }
}
