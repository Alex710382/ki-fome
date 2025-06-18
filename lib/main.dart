// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Importe hive_flutter
import 'package:path_provider/path_provider.dart'; // Importe path_provider

import 'package:ki_fome/screens/home_screen.dart';
import 'package:ki_fome/screens/recipe_detail_screen.dart';
import 'package:ki_fome/screens/favorites_screen.dart';
import 'package:ki_fome/screens/add_recipe_screen.dart'; // <-- Importe a nova tela
import 'package:ki_fome/models/recipe.dart';
import 'package:ki_fome/providers/recipe_provider.dart';

Future<void> main() async {
  // Main deve ser async
  WidgetsFlutterBinding.ensureInitialized(); // Garante que o Flutter está inicializado

  // Inicializa o Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(RecipeAdapter()); // Registra o adaptador gerado

  await Hive.openBox<Recipe>(
    'recipes',
  ); // Abre a caixa (equivalente a uma tabela) de receitas

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecipeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ki Fome',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white, // Cor do texto e ícones na AppBar
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/recipe_detail':
              (context) => RecipeDetailScreen(
                recipe: ModalRoute.of(context)!.settings.arguments as Recipe,
              ),
          '/favorites': (context) => const FavoritesScreen(),
          '/add_recipe': (context) => const AddRecipeScreen(), // <-- Nova rota
        },
      ),
    );
  }
}
