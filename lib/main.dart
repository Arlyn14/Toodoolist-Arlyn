//? CodeWithFlexz on Instagram

//* AmirBayat0 on Github
//! Programming with Flexz on Youtube

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

///
import '../data/hive_data_store.dart';
import '../models/task.dart';
import '../view/home/home_view.dart';
import '../view/auth/login_view.dart';
import '../providers/theme_provider.dart';
import '../data/hive_data_store.dart' show FirestoreDataStore;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('=== STARTING APP INITIALIZATION ===');

  /// Initial Hive DB
  print('Initializing Hive...');
  await Hive.initFlutter();
  print('Hive initialized successfully');

  /// Initialize Firebase
  print('Initializing Firebase...');
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
    print('Firebase Auth instance: ${FirebaseAuth.instance}');
  } catch (e, stackTrace) {
    print('Error initializing Firebase:');
    print('Error: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }

  /// Register Hive Adapter
  print('Registering Hive adapters...');
  Hive.registerAdapter<Task>(TaskAdapter());
  print('Hive adapters registered successfully');

  /// Open boxes
  print('Opening Hive boxes...');
  await Hive.openBox<Task>("tasksBox");
  await Hive.openBox("themeBox");
  print('Hive boxes opened successfully');

  /// Delete data from previous day
  print('Cleaning up old tasks...');
  var taskBox = Hive.box<Task>("tasksBox");
  // ignore: avoid_function_literals_in_foreach_calls
  taskBox.values.forEach((task) {
    if (task.createdAtTime.day != DateTime.now().day) {
      task.delete();
    } else {}
  });
  print('Old tasks cleaned up');

  print('=== APP INITIALIZATION COMPLETE ===');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: BaseWidget(child: const MyApp()),
    ),
  );
}

class BaseWidget extends InheritedWidget {
  BaseWidget({super.key, required this.child}) : super(child: child);
  final FirestoreDataStore dataStore = FirestoreDataStore();
  @override
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError('Could not find ancestor widget of type BaseWidget');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Hive Todo App',
          theme: themeProvider.theme,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData) {
                return const HomeView();
              }

              return const LoginView();
            },
          ),
        );
      },
    );
  }
}
