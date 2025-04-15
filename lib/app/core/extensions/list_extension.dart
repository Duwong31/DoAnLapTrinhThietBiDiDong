part of '../styles/style.dart';

extension ListExt<T> on List<T> {
  bool get isExistAndNotEmpty => isNotEmpty;

  List<T> addBetweenEvery(T value) {
    final List<T> r = <T>[];
    asMap().forEach(
        (int i, T e) => i < length - 1 ? r.addAll(<T>[e, value]) : r.add(e));
    return r;
  }

  T? getAt(int index) {
    if (length - 1 < index) {
      return null;
    }
    return elementAt(index);
  }

  List<List<T>> getRowList({int maxRow = 3}) {
    final List<List<T>> items = <List<T>>[];
    final int groupNum = (length / maxRow).ceil();
    for (int i = 0; i < groupNum; i++) {
      items.add(sublist(
          i * maxRow, ((i + 1) * maxRow) < length ? (i + 1) * maxRow : length));
    }
    return items;
  }
}
