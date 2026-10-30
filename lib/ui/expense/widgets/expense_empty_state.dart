import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';

class ExpenseEmptyState extends StatelessWidget {
  const ExpenseEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.expenseNoTransactions,
            style: TextStyle(color: Colors.grey[600], fontSize: 18),
          ),
        ],
      ),
    );
  }
}
