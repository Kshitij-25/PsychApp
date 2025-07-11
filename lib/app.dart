import 'package:flutter/material.dart';

import 'shared/routers/app_router.dart';
import 'shared/theme/theme.dart';
import 'shared/theme/util.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Manrope", "Lora");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      // theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      debugShowCheckedModeBanner: false,
      themeMode: brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark,
      // themeMode: ThemeMode.light,
      darkTheme: theme.dark(),
      theme: theme.light(),
      routerConfig: AppRouter.router,
    );
  }
}
