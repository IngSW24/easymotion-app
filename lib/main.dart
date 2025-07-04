import 'package:easymotion_app/data/providers/api.provider.dart';
import 'package:easymotion_app/ui/components/nav_bar/bottom_nav_bar.dart';
import 'package:easymotion_app/ui/pages/course_details_page.dart';
import 'package:easymotion_app/ui/pages/login_page.dart';
import 'package:easymotion_app/ui/pages/my_courses_page.dart';
import 'package:easymotion_app/ui/pages/explore_page.dart';
import 'package:easymotion_app/ui/pages/otp_login_page.dart';
import 'package:easymotion_app/ui/pages/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fquery/fquery.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final queryClient = QueryClient();

Future<void> main() async {
  await dotenv.load();
  runApp(QueryClientProvider(
      queryClient: queryClient,
      child: ChangeNotifierProvider(
          create: (BuildContext ctx) => ApiProvider(ctx),
          child: const MyApp())));
}

final GoRouter _router = GoRouter(initialLocation: '/explore', routes: [
  GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return LoginPage();
      },
      routes: [
        GoRoute(
          path: 'otp/:email',
          builder: (BuildContext context, GoRouterState state) {
            final email = state.pathParameters['email'];
            return OTPLoginPage(email: email!);
          },
        ),
      ]),
  GoRoute(
    path: '/details/:id',
    builder: (BuildContext context, GoRouterState state) {
      final id = state.pathParameters['id'];
      return CourseDetailsPage(
        id: id!,
      );
    },
  ),
  GoRoute(
    path: '/profile',
    builder: (BuildContext context, GoRouterState state) {
      return ProfilePage();
    },
  ),
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
              return ExplorePage();
            },
          )
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/my_courses',
            builder: (BuildContext context, GoRouterState state) {
              return MyCoursesPage();
            },
          )
        ]),
        /*StatefulShellBranch(routes: [
          GoRoute(
            path: '/stats',
            builder: (BuildContext context, GoRouterState state) {
              return StatsPage();
            },
          )
        ])*/
      ])
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        Locale('en'),
        Locale('it'),
      ],
      theme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
    );
  }
}
