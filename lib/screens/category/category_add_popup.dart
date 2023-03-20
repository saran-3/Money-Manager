import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';

import '../../models/category/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  final _nameEditingController = TextEditingController();

  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(title: const Text('Add Category'), children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                controller: _nameEditingController,
                decoration: const InputDecoration(
                  hintText: 'Category Name',
                  border: OutlineInputBorder(),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const RadioButton(title: 'Income', type: CategoryType.income),
                const RadioButton(title: 'Expense', type: CategoryType.expense)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                final _name = _nameEditingController.text;
                if (_name.isEmpty) {
                  return;
                }
                final _type = selectedCategoryNotifier.value;
                final _category = CategoryModel(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    name: _name,
                    type: _type);

                CategoryDb().insertCategory(_category);
                Navigator.of(ctx).pop();
              },
              child: const Text('Add'),
            ),
          )
        ]);
      });
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton({
    Key? key,
    required this.type,
    required this.title,
  }) : super(key: key);

  //

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategoryNotifier,
            builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
              return Radio<CategoryType>(
                  value: type,
                  groupValue: newCategory,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    selectedCategoryNotifier.value = value;
                    selectedCategoryNotifier.notifyListeners();
                  });
            }),
        Text(title),
      ],
    );
  }
}
