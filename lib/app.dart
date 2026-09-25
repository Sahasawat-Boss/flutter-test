import 'package:flutter/material.dart';

import 'screens/main_shell.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

class FlutterLearnApp extends StatelessWidget {
  const FlutterLearnApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: ListenableBuilder(
        listenable: state,
        builder: (context, _) => MaterialApp(
          title: 'Flutter Learn',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.themeMode,
          home: const MainShell(),
        ),
      ),
    );
  }
}
