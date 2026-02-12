import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/guides/data/repositories/guide_repository_impl.dart';
import 'package:stiv/features/guides/domain/models/guides.dart';

// Firestore Instance Provider (reuse from devices if needed)
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Repository Provider
final guideRepositoryProvider = Provider<GuideRepositoryImpl>((ref) {
  return GuideRepositoryImpl(ref.watch(firestoreProvider));
});

// State Provider for search query
final guideSearchQueryProvider = StateProvider<String>((ref) => '');

// Stream of all active guides
final guidesStreamProvider = StreamProvider<List<Guide>>((ref) {
  final repo = ref.watch(guideRepositoryProvider);
  return repo.getActiveGuidesStream();
});

// Filtered guides based on search query
final filteredGuidesProvider = Provider<AsyncValue<List<Guide>>>((ref) {
  final query = ref.watch(guideSearchQueryProvider).toLowerCase();
  final guidesAsync = ref.watch(guidesStreamProvider);

  return guidesAsync.when(
    data: (guides) {
      if (query.isEmpty) return AsyncData(guides);
      final filtered = guides.where((guide) {
        return guide.title.toLowerCase().contains(query) ||
               guide.subtitle.toLowerCase().contains(query) ||
               guide.category.toLowerCase().contains(query);
      }).toList();
      return AsyncData(filtered);
    },
    loading: () => const AsyncLoading(),
    error: (e, st) => AsyncError(e, st),
  );
});

// Stream of guides by category
final guidesByCategoryStreamProvider = StreamProvider.family<List<Guide>, String>((ref, category) {
  final repo = ref.watch(guideRepositoryProvider);
  return repo.getGuidesByCategory(category);
});
