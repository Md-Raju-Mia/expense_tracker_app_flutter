import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../../../core/theme/expense_theme.dart';
import '../../../domain/entities/transaction_amount.dart';
import '../utils/normalize_amount_input.dart';
import 'expense_amount.dart';
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
  final void Function(String title, int amountMinor) onSubmit;

  @override
  State<ExpenseTransactionForm> createState() => _ExpenseTransactionFormState();
}

class _ExpenseTransactionFormState extends State<ExpenseTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  int _amount = 0;

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
                validator: (value) => value == null || value.trim().isEmpty
                    ? text.expenseTitleRequired
                    : null,
                onSaved: (value) => _title = value!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: text.expenseAmountCurrency(model.currencyCode),
                  prefixIcon: const Icon(Icons.payments_outlined),
                  helperText: text.expenseAmountHint,
                  helperMaxLines: 3,
                  errorMaxLines: 6,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  try {
                    TransactionAmount.parse(normalizeAmountInput(value ?? ''));
                    return null;
                  } on RangeError {
                    return text.expenseAmountTooLarge(
                      expenseAmount(
                        BigInt.from(TransactionAmount.maxMinorUnits),
                        model.currencyCode,
                        text.localeName,
                      ),
                    );
                  } on FormatException {
                    return text.expenseAmountInvalid;
                  }
                },
                onSaved: (value) => _amount = TransactionAmount.parse(
                  normalizeAmountInput(value!),
                ).minorUnits,
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
