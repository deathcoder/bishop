part of 'serialisation.dart';

abstract class BishopTypeAdapter<T> {
  String get id;
  Map<String, dynamic>? export(T e);
  T build(Map<String, dynamic>? params);
  Type get type => T;
  const BishopTypeAdapter();
}

class BasicAdapter<T> implements BishopTypeAdapter<T> {
  @override
  final String id;
  final T Function() builder;
  const BasicAdapter(this.id, this.builder);

  @override
  T build(Map<String, dynamic>? params) => builder();

  @override
  Map<String, dynamic>? export(T e) => null;

  @override
  Type get type => T;
}
