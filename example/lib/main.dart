// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suprsend_flutter_sdk/suprsend.dart';
import 'package:app_links/app_links.dart';

/// This sample app shows an app with two screens.
///
/// The first route '/' is mapped to [HomeScreen], and the second route
/// '/details' is mapped to [DetailsScreen].
///
/// The buttons use context.go() to navigate to each destination. On mobile
/// devices, each destination is deep-linkable and on the web, can be navigated
/// to using the address bar.
void main() => runApp(const MyApp());

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details',
          builder: (BuildContext context, GoRouterState state) {
            return const DetailsScreen();
          },
        ),
      ],
    ),
  ],
  initialLocation: '/',
);

/// Initialize app link handling
Future<void> _initAppLinks() async {
  final appLinks = AppLinks();
  print("executing app links");
  // Handle initial link (when app is opened via deeplink)
  try {
    final initialLink = await appLinks.getInitialAppLink();
    print("initialLink: $initialLink");
    if (initialLink != null) {
      _handleAppLink(initialLink);
    }
  } catch (e) {
    print("error: $e");
    debugPrint('Error getting initial link: $e');
  }

  // Listen for subsequent links (when app is already running)
  appLinks.uriLinkStream.listen((Uri uri) {
    print("uri: $uri");
    _handleAppLink(uri);
  }, onError: (err) {
    debugPrint('App link error: $err');
  });
}

/// Handle app link and navigate accordingly
void _handleAppLink(Uri uri) {
  debugPrint('Received deeplink: $uri');
  debugPrint('Scheme: ${uri.scheme}, Host: ${uri.host}, Path: ${uri.path}');

  // Check if this is a suprsend deeplink
  final isSuprsendLink =
      (uri.scheme == 'com.suprsend' && uri.host == 'details') ||
          (uri.scheme == 'https' &&
              uri.host == 'web-inbox-assets.suprsend.com' &&
              uri.path == '/details');

  if (!isSuprsendLink) {
    debugPrint('Not a suprsend deeplink, ignoring');
    return;
  }

  // Use SchedulerBinding to ensure navigation happens after the frame is built
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Future.delayed(const Duration(milliseconds: 100), () {
      _router.go('/details');
      debugPrint('Navigated to /details');
    });
  });
}

/// The main app.
class MyApp extends StatefulWidget {
  /// Constructs a [MyApp]
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize app links when the app starts
    _initAppLinks();
    print("app links initialized");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}

/// The home screen
class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/details'),
              child: const Text('Go to the Details screen'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                suprsend.identify("katta.sivaram@suprsend.com");
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                suprsend.reset();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

/// The details screen
class DetailsScreen extends StatelessWidget {
  /// Constructs a [DetailsScreen]
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/'),
          child: const Text('Go back to the Home screen'),
        ),
      ),
    );
  }
}
