import 'package:go_router/go_router.dart';
import 'package:stiv/pages/login_page.dart';
// import 'features/dashboard/dashboard_page.dart';
// import 'features/search/search_page.dart';
// import 'features/kb_detail/kb_detail_page.dart';
// import 'features/diagnosis/diagnosis_page.dart';
// import 'features/incidents/incidents_page.dart';
// import 'features/incidents/incident_form_page.dart';


final router = GoRouter(routes: [
  GoRoute(path: '/', builder: (_, _) =>  LoginPage()),
// GoRoute(path: '/search', builder: (_, __) => const SearchPage()),
// GoRoute(path: '/kb/:id', builder: (_, st) => KbDetailPage(id: st.pathParameters['id']!)),
// GoRoute(path: '/diagnosis/:treeId', builder: (_, st) => DiagnosisPage(treeId: st.pathParameters['treeId']!)),
// GoRoute(path: '/incidents', builder: (_, __) => const IncidentsPage()),
// GoRoute(path: '/incidents/new', builder: (_, __) => const IncidentFormPage()),
]);