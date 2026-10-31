import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/l10n.dart';

class ExpenseDatePicker extends StatelessWidget {
  const ExpenseDatePicker({
    super.key,
    required this.selectedDate,
    required this.onSelected,
  });
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (date != null) onSelected(date);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                DateFormat(
                  'EEEE, MMM dd, yyyy',
                  context.l10n.localeName,
                ).format(selectedDate),
              ),
            ),
            const Icon(Icons.calendar_month, color: Colors.teal),
          ],
        ),
      ),
    );
  }
}
