import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'shell/home_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = MyAppState(await openCollectionDb());
  await state.load();
  runApp(MyApp(state: state));
}

class MyApp extends StatelessWidget {
  /// Null = state baru tanpa database (dipakai di widget test).
  final MyAppState? state;

  const MyApp({super.key, this.state});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => state ?? MyAppState(),
      child: MaterialApp(
        title: 'Sinelog',
        theme: ThemeData.dark(useMaterial3: true),
        home: const MyHomePage(),
      ),
    );
  }
}
