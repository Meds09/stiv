


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/diagnostic/data/problem_repository_impl.dart';
import 'package:stiv/features/diagnostic/models/problem.dart';
import 'package:stiv/features/diagnostic/models/problem_repository.dart';

final problemRepositoryProvider = Provider<ProblemRepository>((ref) {
  return ProblemRepositotyImp();
});


final problemsProvider = FutureProvider<List<Problem>>((ref) async {
  final repo = ref.read(problemRepositoryProvider);
  return repo.getProblems();
});


final problemByIdProvider = FutureProvider.family<Problem, int>((ref, int problemId) async {
  final repo = ref.read(problemRepositoryProvider);
  return repo.getProblemById(problemId);
});

final problemsByCategoryProvider =
    FutureProvider.family<List<Problem>, int>((ref, categoryId) async {
  final repo = ref.watch(problemRepositoryProvider);
  return repo.getProblemsByCategory(categoryId);
});