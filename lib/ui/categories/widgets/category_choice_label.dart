import 'package:flutter/material.dart';

// Material chips use one line by default. Category names need to wrap.
class CategoryChoiceLabel extends StatelessWidget {
  const CategoryChoiceLabel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: Theme.of(context).textTheme.labelLarge!
        .copyWith(color: Theme.of(context).colorScheme.onSurface),
    softWrap: true,
    child: Text(label),
  );
}
