import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

final menuIndexProvider =
    NotifierProvider<MenuIndexNotifier, int>(MenuIndexNotifier.new);
