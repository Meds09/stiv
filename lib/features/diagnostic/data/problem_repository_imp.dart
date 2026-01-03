import 'package:stiv/features/diagnostic/data/mock_problem.dart';
import 'package:stiv/features/diagnostic/models/problem.dart';
import 'package:stiv/features/diagnostic/models/problem_repository.dart';

class ProblemRepositotyImp implements ProblemRepository {
  @override
  Future<Problem> getProblemById(int problemId) async {
    for (final problem in mockProblems) {
      if (problem.id == problemId) {
        return Future.value(problem);
      }
    }
    throw Exception('Problem not found');
  }

  @override
  Future<List<Problem>> getProblems() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return mockProblems;
  }

  @override
  Future<List<Problem>> getProblemsByAppliedDeviceId(Set<int> appliedDeviceId)async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockProblems
    .where((problem) => problem.appliedCategoryIds.any((id) => appliedDeviceId.contains(id)))
    .toList();

  }
}
