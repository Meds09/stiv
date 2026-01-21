import 'package:flutter_riverpod/flutter_riverpod.dart';

final isExpandedCategoryIdProviderFromDevicesPage = StateProvider<Set<int>>((ref) => <int>{});