import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fleet_wise_user_app/core/state/action_state.dart';
import 'package:fleet_wise_user_app/domain/entities/category_exception.dart';
import 'package:fleet_wise_user_app/domain/entities/transaction_category.dart';

import 'support/memory_categories.dart';

void main() {
  test(
    'filters, save, archive and restore reload persisted category state',
    () async {
      final repository = MemoryCategories();
      final model = categoriesModel(repository);
      addTearDown(model.dispose);
      await model.load();
      expect(model.visibleCategories.single.name, 'Food');
      model.filter(isIncome: true);
      model.startNew();
      expect(model.income, isTrue);
      model.changeName('Salary');
      expect((await model.save()).status, ActionStatus.succeeded);
      final saved = model.visibleCategories.last;
      await model.setArchived(saved, true);
      expect(model.visibleCategories, hasLength(1));
      model.filter(archived: true);
      expect(model.visibleCategories.single.id, saved.id);
      await model.setArchived(model.visibleCategories.single, false);
      expect(model.visibleCategories, isEmpty);
      model.filter(archived: false);
      expect(model.visibleCategories, hasLength(2));
    },
  );

  test(
    'unchanged Bengali default label preserves stored translation identity',
    () async {
      final repository = MemoryCategories();
      final model = categoriesModel(repository);
      addTearDown(model.dispose);
      await model.load();
      model.startEdit(model.visibleCategories.single, displayName: 'খাবার');
      model.selectColor(CategoryColor.teal);
      model.selectIncome(true);
      expect(model.income, isFalse);
      await model.save();
      expect(repository.lastDraft!.name, 'Food');
      expect(
        repository.rows
            .firstWhere((row) => row.id == 'default-food')
            .builtInKey,
        'food',
      );
      model.startEdit(model.visibleCategories.single, displayName: 'খাবার');
      model.changeName('Meals');
      await model.save();
      expect(repository.lastDraft!.name, 'Meals');
    },
  );

  test(
    'save failure retains draft and explicit retry saves once successfully',
    () async {
      final repository = MemoryCategories()
        ..writeError = const CategoryException(CategoryProblem.duplicateName);
      final model = categoriesModel(repository);
      addTearDown(model.dispose);
      await model.load();
      model.startNew();
      model.changeName('Rent');
      expect((await model.save()).status, ActionStatus.failed);
      expect(model.editing, isTrue);
      expect(model.name, 'Rent');
      expect(model.state.failedTask, 'Save category');
      repository.writeError = null;
      expect((await model.save()).status, ActionStatus.succeeded);
      expect(model.editing, isFalse);
      expect(repository.rows.where((row) => row.name == 'Rent'), hasLength(1));
    },
  );

  test(
    'busy/disposed editor guards duplicate work and accepted save completes',
    () async {
      final repository = MemoryCategories()..pendingSave = Completer<void>();
      final model = categoriesModel(repository);
      await model.load();
      model.startNew();
      model.changeName('Rent');
      var notifications = 0;
      model.addListener(() => notifications++);
      final pending = model.save();
      model.changeName('Wrong');
      model.cancelEdit();
      await expectLater(model.save(), throwsStateError);
      expect(model.name, 'Rent');
      model.dispose();
      final before = notifications;
      repository.pendingSave!.complete();
      expect((await pending).status, ActionStatus.succeeded);
      expect(notifications, before);
      expect(repository.writes, 1);
    },
  );

  test(
    'failed reload after successful write does not replay the write',
    () async {
      final repository = MemoryCategories();
      final model = categoriesModel(repository);
      addTearDown(model.dispose);
      await model.load();
      model.startNew();
      model.changeName('Rent');
      repository.readError = StateError('storage');
      expect((await model.save()).status, ActionStatus.succeeded);
      expect(model.editing, isFalse);
      expect(model.contentState.hasError, isTrue);
      repository.readError = null;
      await model.load();
      expect(repository.writes, 1);
      expect(model.visibleCategories, hasLength(2));
    },
  );
}
