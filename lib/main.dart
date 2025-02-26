import 'package:easymotion_app/data/providers/api.provider.dart';
import 'package:easymotion_app/ui/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(QueryClientProvider(
      queryClient: QueryClient(),
      child: Provider(create: (_) => ApiProvider(), child: const MyApp())));
}

final GoRouter _router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      return HomeScreen(/*coursesApi: coursesApi*/);
    },
  )
]);

//final CoursesApi coursesApi = CoursesApi(ApiClient(basePath: 'https://api.easymotion.it'));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
