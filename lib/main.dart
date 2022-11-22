import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'ui/screens.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, ProbooksManager>(
          create: (ctx) => ProbooksManager(),
          update: (ctx, authManager, probooksManager) {
            // Khi authManager có báo hiệu thay đổi thì đọc lại authToken
            // cho productManager
            probooksManager!.authToken = authManager.authToken;
            return probooksManager;
          },
        ),
      ],
      child: Consumer<AuthManager>(builder: (context, authManager, child) {
        return MaterialApp(
          title: 'My Book',
          theme: ThemeData(
            primarySwatch: Colors.cyan,
          ),
          home: authManager.isAuth
              ? const ProbooksOverviewScreen()
              : FutureBuilder(
                  future: authManager.tryAutoLogin(),
                  builder: (ctx, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const SplashScreen()
                        : const AuthScreen();
                  },
                ),
          routes: {
            UseProbooksScreen.routeName: (ctx) => const UseProbooksScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == ProbookDetailScreen.routeName) {
              final probookId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (ctx) {
                  return ProbookDetailScreen(
                    probookId != null
                        ? ctx.read<ProbooksManager>().findById(probookId)
                        : null,
                  );
                },
              );
            }

            if (settings.name == EditProbookScreen.routeName) {
              final probookId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (ctx) {
                  return EditProbookScreen(
                    probookId != null
                        ? ctx.read<ProbooksManager>().findById(probookId)
                        : null,
                  );
                },
              );
            }
            return null;
          },
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
