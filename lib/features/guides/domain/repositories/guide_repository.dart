import '../models/guides.dart';

abstract class GuideRepository {
  Stream<List<Guide>> getGuides();
}
