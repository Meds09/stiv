import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/auth/providers/auth_provider.dart';
import 'package:stiv/features/guides/data/repositories/guide_repository_impl.dart';
import 'package:stiv/features/guides/domain/models/guides.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

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

// Selected Category Provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Stream of all active guides (re-creates listener when auth state changes)
final guidesStreamProvider = StreamProvider<List<Guide>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  
  final repo = ref.watch(guideRepositoryProvider);
  return repo.getActiveGuidesStream();
});

// Filtered guides based on search query and category
final filteredGuidesProvider = Provider<AsyncValue<List<Guide>>>((ref) {
  final query = ref.watch(guideSearchQueryProvider).toLowerCase();
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final guidesAsync = ref.watch(guidesStreamProvider);

  return guidesAsync.when(
    data: (guides) {
      var filtered = guides;

      // Filter by Category
      if (selectedCategory != null) {
        filtered = filtered.where((guide) => guide.category == selectedCategory).toList();
      }

      // Filter by Search Query
      if (query.isNotEmpty) {
        filtered = filtered.where((guide) {
          return guide.title.toLowerCase().contains(query) ||
                 guide.subtitle.toLowerCase().contains(query) ||
                 guide.category.toLowerCase().contains(query);
        }).toList();
      }
      
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

// Image Preloader Provider
final guidesImagePreloaderProvider = Provider<void>((ref) {
  final guidesAsync = ref.watch(guidesStreamProvider);
  
  guidesAsync.whenData((guides) {
    for (final guide in guides) {
      if (guide.imageUrl.isNotEmpty) {
        // Pre-cache image
        // We utilize CachedNetworkImageProvider to start the download and cache process
        // This doesn't need context if we just want to warm up the cache
        try {
           final imageProvider = CachedNetworkImageProvider(guide.imageUrl);
           // Resolve the image to trigger loading
           imageProvider.resolve(ImageConfiguration.empty);
        } catch (e) {
          // Ignore errors during preloading
        }
      }
    }
  });
});
