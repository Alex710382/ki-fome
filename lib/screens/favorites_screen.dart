// lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ki_fome/providers/recipe_provider.dart';
import 'package:ki_fome/widgets/recipe_card.dart';
import 'package:ki_fome/screens/recipe_detail_screen.dart'; // Certifique-se de importar se RecipeDetailScreen for usada aqui

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final favoriteRecipes =
        recipeProvider.recipes.where((recipe) => recipe.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Receitas Favoritas')),
      body:
          favoriteRecipes.isEmpty
              ? const Center(
                child: Text(
                  'Você ainda não favoritou nenhuma receita.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.57,
                ),
                itemCount: favoriteRecipes.length,
                itemBuilder: (context, index) {
                  return RecipeCard(
                    recipe: favoriteRecipes[index],
                    onTap: () {
                      // Navega para a tela de detalhes da receita
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => RecipeDetailScreen(
                                recipe: favoriteRecipes[index],
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
