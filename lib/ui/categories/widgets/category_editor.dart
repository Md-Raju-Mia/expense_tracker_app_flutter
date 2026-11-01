import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../domain/entities/category_draft.dart';
import '../../../domain/entities/transaction_category.dart';
import '../../../l10n/l10n.dart';
import '../view_models/categories_view_model.dart';
import 'category_style.dart';
import 'category_choice_label.dart';

class CategoryEditor extends StatefulWidget {
  const CategoryEditor({super.key, required this.model});
  final CategoriesViewModel model;
  @override
  State<CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<CategoryEditor> {
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final text = context.l10n;
    final theme = Theme.of(context);
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.isExisting ? text.categoriesEdit : text.categoriesAdd,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            key: const ValueKey('category-name'),
            initialValue: model.name,
            decoration: InputDecoration(labelText: text.categoriesName),
            style: theme.textTheme.bodyLarge,
            textCapitalization: TextCapitalization.sentences,
            maxLength: CategoryDraft.maxNameLength,
            onChanged: model.changeName,
            validator: (value) {
              final name = (value ?? '').trim();
              if (name.isEmpty ||
                  name.characters.length > CategoryDraft.maxNameLength) {
                return text.categoriesNameInvalid;
              }
              String normalize(String label) =>
                  label.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
              for (final category
                  in model.contentState.data ?? <TransactionCategory>[]) {
                if (category.id != model.editingId &&
                    !category.isArchived &&
                    category.isIncome == model.income &&
                    normalize(category.label(context)) == normalize(name)) {
                  return text.categoriesDuplicate;
                }
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(text.categoriesType, style: theme.textTheme.titleMedium),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              ChoiceChip(
                label: Text(text.expenseTypeExpense),
                selected: !model.income,
                onSelected: model.isExisting
                    ? null
                    : (_) => model.selectIncome(false),
              ),
              ChoiceChip(
                label: Text(text.expenseIncome),
                selected: model.income,
                onSelected: model.isExisting
                    ? null
                    : (_) => model.selectIncome(true),
              ),
            ],
          ),
          if (model.isExisting)
            Text(text.categoriesTypeFixed, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Icon(
                model.icon.materialIcon,
                color: model.color.foreground(context),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(text.categoriesIcon, style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: CategoryIcon.values
                .map(
                  (icon) => ChoiceChip(
                    key: ValueKey('category-icon-${icon.name}'),
                    avatar: Icon(icon.materialIcon, size: 20),
                    label: CategoryChoiceLabel(
                      text.categoriesIconName(icon.name),
                    ),
                    selected: model.icon == icon,
                    onSelected: (_) => model.selectIcon(icon),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(text.categoriesColor, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: CategoryColor.values
                .map(
                  (color) => ChoiceChip(
                    key: ValueKey('category-color-${color.name}'),
                    avatar: Icon(
                      Icons.circle,
                      size: 20,
                      color: color.foreground(context),
                    ),
                    label: CategoryChoiceLabel(
                      text.categoriesColorName(color.name),
                    ),
                    selected: model.color == color,
                    onSelected: (_) => model.selectColor(color),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              key: const ValueKey('category-save'),
              icon: const Icon(Icons.check),
              label: Text(text.categoriesSave),
              onPressed: model.canInteract
                  ? () {
                      if (!model.canInteract) return;
                      if (_form.currentState!.validate()) model.save();
                    }
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: model.canInteract ? model.cancelEdit : null,
              child: Text(text.expenseCancel),
            ),
          ),
        ],
      ),
    );
  }
}
