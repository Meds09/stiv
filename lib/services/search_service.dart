import '../models/failure_case.dart';


class SearchService {
List<FailureCase> rank(List<FailureCase> all, String q) {
final query = q.trim().toLowerCase();
if (query.isEmpty) return all;
int score(FailureCase c) {
int s = 0;
if (c.titulo.toLowerCase().contains(query)) s += 3;
if (c.etiquetas.join(' ').toLowerCase().contains(query)) s += 2;
if ((c.descripcion ?? '').toLowerCase().contains(query)) s += 1;
return s;
}
final list = all.map((c) => MapEntry(c, score(c)))
.where((e) => e.value > 0)
.toList()
..sort((a, b) => b.value.compareTo(a.value));
return list.map((e) => e.key).toList();
}
}