import 'package:flutter/material.dart';

class PreferenceChoiceField<T> extends StatelessWidget {
  const PreferenceChoiceField({
    super.key,
    required this.label,
    required this.value,
    required this.values,
    required this.labelFor,
    required this.onChanged,
    this.helper,
  });

  final String label;
  final T value;
  final List<T> values;
  final String Function(T value) labelFor;
  final ValueChanged<T> onChanged;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          // Recreate the field when a country selection suggests a new value.
          key: ValueKey(value),
          initialValue: value,
          isExpanded: true,
          isDense: false,
          itemHeight: null,
          selectedItemBuilder: (context) =>
              values.map((item) => Text(labelFor(item))).toList(),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerLow,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: values
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(labelFor(item)),
                  ),
                ),
              )
              .toList(),
          onChanged: (selected) {
            if (selected != null) onChanged(selected);
          },
        ),
        if (helper != null) ...[
          const SizedBox(height: 8),
          Text(
            helper!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
