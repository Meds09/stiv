import 'package:stiv/features/diagnostic/models/problem.dart';

abstract class ProblemRepository {
Future <List<Problem>> getProblems();
Future <Problem> getProblemById(int problemId);
Future <List<Problem>> getProblemsByAppliedDeviceId(Set<int> appliedDeviceId);


}