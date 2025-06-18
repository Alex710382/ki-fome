// lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ki_fome/models/recipe.dart';
import 'package:ki_fome/providers/recipe_provider.dart';
import 'package:ki_fome/widgets/recipe_card.dart'; // Reutilizaremos o RecipeCard

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Receitas Favoritas'),
        centerTitle: true,
      ),
      body: Consumer<RecipeProvider>(
        // Escuta as mudanças no RecipeProvider
        builder: (context, recipeProvider, child) {
          // Filtra as receitas para mostrar apenas as favoritas
          final List<Recipe> favoriteRecipes =
              recipeProvider.recipes
                  .where((recipe) => recipe.isFavorite)
                  .toList();

          if (recipeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (favoriteRecipes.isEmpty) {
            // Mensagem quando não há favoritos
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Você ainda não favoritou nenhuma receita.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Comece explorando e marcando suas preferidas!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            // Exibe a lista de receitas favoritas
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: RecipeCard(
                    recipe: recipe,
                    onTap: () {
                      // Navega para a tela de detalhes da receita favorita
                      Navigator.pushNamed(
                        context,
                        '/recipe_detail',
                        arguments: recipe,
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
