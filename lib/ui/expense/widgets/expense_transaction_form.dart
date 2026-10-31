import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../../../core/theme/expense_theme.dart';
import '../view_models/add_expense_view_model.dart';
import 'expense_category_picker.dart';
import 'expense_date_picker.dart';
import 'expense_type_chip.dart';

class ExpenseTransactionForm extends StatefulWidget {
  const ExpenseTransactionForm({
    super.key,
    required this.viewModel,
    required this.onSubmit,
  });
  final AddExpenseViewModel viewModel;
  final void Function(String title, double amount) onSubmit;

  @override
  State<ExpenseTransactionForm> createState() => _ExpenseTransactionFormState();
}

class _ExpenseTransactionFormState extends State<ExpenseTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    widget.onSubmit(_title, _amount);
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.viewModel;
    final text = context.l10n;
    const heading = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text.expenseTransactionType, style: heading),
              const SizedBox(height: 12),
              Row(
                children: [
                  ExpenseTypeChip(
                    label: text.expenseTypeExpense,
                    isSelected: !model.isIncome,
                    color: ExpenseTheme.expenseColor,
                    onTap: () => model.selectIncome(false),
                  ),
                  const SizedBox(width: 12),
                  ExpenseTypeChip(
                    label: text.expenseIncome,
                    isSelected: model.isIncome,
                    color: ExpenseTheme.incomeColor,
                    onTap: () => model.selectIncome(true),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(
                  labelText: text.expenseTitle,
                  prefixIcon: const Icon(Icons.title),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    value!.isEmpty ? text.expenseTitleRequired : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: text.expenseAmountCurrency(model.currencyCode),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) => double.tryParse(value!) == null
                    ? text.expenseAmountInvalid
                    : null,
                onSaved: (value) => _amount = double.parse(value!),
              ),
              const SizedBox(height: 24),
              if (!model.isIncome) ...[
                Text(text.expenseCategory, style: heading),
                const SizedBox(height: 12),
                ExpenseCategoryPicker(
                  selectedCategory: model.selectedCategory,
                  onSelected: model.selectCategory,
                ),
                const SizedBox(height: 24),
              ],
              Text(text.expenseDate, style: heading),
              const SizedBox(height: 12),
              ExpenseDatePicker(
                selectedDate: model.selectedDate,
                onSelected: model.selectDate,
              ),
              const SizedBox(height: 40),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: double.infinity,
                  minHeight: 56,
                ),
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    text.expenseSaveTransaction,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
