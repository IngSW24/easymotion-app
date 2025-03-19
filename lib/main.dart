import 'package:easymotion_app/data/providers/api.provider.dart';
import 'package:easymotion_app/ui/components/main_scaffold.dart';
import 'package:easymotion_app/ui/pages/course_details_page.dart';
import 'package:easymotion_app/ui/pages/explore_page.dart';
import 'package:easymotion_app/ui/pages/home_page.dart';
import 'package:easymotion_app/ui/pages/stats_page.dart';
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
  StatefulShellRoute.indexedStack(
      builder: (BuildContext ctx, GoRouterState state,
          StatefulNavigationShell navigationShell) {
        return BottomNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/explore',
            builder: (BuildContext context, GoRouterState state) {
              return ExploreScreen();
            },
          )
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/',
              builder: (BuildContext context, GoRouterState state) {
                return HomeScreen();
              },
              routes: [
                GoRoute(
                  path: 'details',
                  builder: (BuildContext context, GoRouterState state) {
                    return CourseDetailsScreen();
                  },
                )
              ])
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/stats',
            builder: (BuildContext context, GoRouterState state) {
              return StatsScreen();
            },
          )
        ])
      ])
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple)),
    );
  }
}
