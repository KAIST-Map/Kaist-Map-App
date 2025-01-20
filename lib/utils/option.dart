// Define the Option type
abstract class Option<T> {
  const Option();

  bool get isDefined;
  bool get isEmpty;
  T get value;

  Option<U> map<U>(U Function(T) f);
  Option<U> flatMap<U>(Option<U> Function(T) f);
  T getOrElse(T defaultValue);

  factory Option.some(T value) = Some<T>;
  factory Option.none() = None<T>;

  factory Option.fromNullable(T? value) {
    return value == null ? None<T>() : Some(value);
  }
}

class Some<T> extends Option<T> {
  final T _value;

  const Some(this._value);

  @override
  bool get isDefined => true;

  @override
  bool get isEmpty => false;

  @override
  T get value => _value;

  @override
  Option<U> map<U>(U Function(T) f) {
    return Some(f(_value));
  }

  @override
  Option<U> flatMap<U>(Option<U> Function(T) f) {
    return f(_value);
  }

  @override
  T getOrElse(T defaultValue) => _value;

  @override
  String toString() => 'Some($_value)';

  @override
  bool operator ==(Object other) {
    return other is Some<T> && other._value == _value;
  }

  @override
  int get hashCode => _value.hashCode;
}

class None<T> extends Option<T> {
  const None();

  @override
  bool get isDefined => false;

  @override
  bool get isEmpty => true;

  @override
  T get value => throw StateError('Cannot get value of None');

  @override
  Option<U> map<U>(U Function(T) f) {
    return None<U>();
  }

  @override
  Option<U> flatMap<U>(Option<U> Function(T) f) {
    return None<U>();
  }

  @override
  T getOrElse(T defaultValue) => defaultValue;

  @override
  String toString() => 'None';

  @override
  bool operator ==(Object other) => other is None<T>;

  @override
  int get hashCode => 0;
}
