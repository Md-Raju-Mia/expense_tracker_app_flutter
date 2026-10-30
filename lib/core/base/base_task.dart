/// One operation. Concrete tasks own their work and receive only input data.
abstract class BaseTask<T> {
  const BaseTask();

  String get name;
  Future<T> run();
}
