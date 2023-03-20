import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

import '../../db/transaction/transaction_db.dart';

class ScreenaddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenaddTransaction({super.key});

  @override
  State<ScreenaddTransaction> createState() => _ScreenaddTransactionState();
}

class _ScreenaddTransactionState extends State<ScreenaddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  CategoryModel? _selectedCategorymodel;

  String? _categoryID;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategorytype = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //purpose
              TextFormField(
                controller: _purposeTextEditingController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: 'Purpose'),
              ),

              //amount
              TextFormField(
                controller: _amountTextEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Amount'),
              ),

              //calendar
              TextButton.icon(
                  onPressed: () async {
                    final _selectedDateTemp = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 30),
                        ),
                        lastDate: DateTime.now());
                    if (_selectedDateTemp == null) {
                      return;
                    } else {
                      print(_selectedDateTemp.toString());
                      setState(() {
                        _selectedDate = _selectedDateTemp;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_selectedDate == null
                      ? 'Select Date'
                      : _selectedDate.toString())),
              Row(
                children: [
                  Radio(
                      value: CategoryType.income,
                      groupValue: _selectedCategorytype,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategorytype = CategoryType.income;
                        });
                      }),
                  const Text('Income'),
                  Radio(
                      value: CategoryType.expense,
                      groupValue: _selectedCategorytype,
                      onChanged: (newValue) {
                       setState(() {
                          _selectedCategorytype = CategoryType.expense;
                       });
                      }),
                  const Text('Expense'),
                ],
              ),
               

              //Category type
              DropdownButton(
                 onChanged: (selectedValue) {
                    print(selectedValue);
                    setState(() {
                      _categoryID = selectedValue.toString();
                    });
                  },
                  hint: const Text('Select Category'),
                  value: _categoryID,
                  items:   (_selectedCategorytype == CategoryType.income
                    ? CategoryDb().incomeCategoryListListener
                     : CategoryDb().expenseCategoryListListener)
                     .value
                     .map((e){
                    return DropdownMenuItem(
                      child: Text(e.name),
                      value: e.id,
                      onTap: (() {
                        _selectedCategorymodel = e;
                      }),
                    );
                  }).toList(),
                 ),

              //submit
              ElevatedButton(
                onPressed: () {
                  addTransaction();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    // if(CategoryID == null){
    //   return;
    // }
    if (_selectedCategorymodel == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }

    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }

    final _model = TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategorytype!,
      category: _selectedCategorymodel!,
    );

    await TransactionDB.instance.addTransaction(_model);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }
}
