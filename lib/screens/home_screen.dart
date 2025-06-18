// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ki_fome/models/recipe.dart';
import 'package:ki_fome/providers/recipe_provider.dart';
import 'package:ki_fome/widgets/recipe_card.dart';
import 'package:ki_fome/screens/add_recipe_screen.dart'; // Importe a nova tela

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ki Fome'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
        ],
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Buscar Receitas',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    Provider.of<RecipeProvider>(
                      context,
                      listen: false,
                    ).setSearchTerm(value);
                  },
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<RecipeProvider>(
                            context,
                            listen: false,
                          ).setSelectedCategory('Todas');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              recipeProvider.selectedCategory == 'Todas'
                                  ? Colors.orange
                                  : Colors.grey,
                        ),
                        child: const Text('Todas'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<RecipeProvider>(
                            context,
                            listen: false,
                          ).setSelectedCategory('Salgadas');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              recipeProvider.selectedCategory == 'Salgadas'
                                  ? Colors.orange
                                  : Colors.grey,
                        ),
                        child: const Text('Salgadas'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<RecipeProvider>(
                            context,
                            listen: false,
                          ).setSelectedCategory('Doces');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              recipeProvider.selectedCategory == 'Doces'
                                  ? Colors.orange
                                  : Colors.grey,
                        ),
                        child: const Text('Doces'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<RecipeProvider>(
                            context,
                            listen: false,
                          ).setSelectedCategory('Bebidas');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              recipeProvider.selectedCategory == 'Bebidas'
                                  ? Colors.orange
                                  : Colors.grey,
                        ),
                        child: const Text('Bebidas'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<RecipeProvider>(
                            context,
                            listen: false,
                          ).setSelectedCategory('Fitness');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              recipeProvider.selectedCategory == 'Fitness'
                                  ? Colors.orange
                                  : Colors.grey,
                        ),
                        child: const Text('Fitness'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<RecipeProvider>(
                            context,
                            listen: false,
                          ).setSelectedCategory('Bolos');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              recipeProvider.selectedCategory == 'Bolos'
                                  ? Colors.orange
                                  : Colors.grey,
                        ),
                        child: const Text('Bolos'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child:
                    recipeProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : recipeProvider.filteredRecipes.isEmpty
                        ? const Center(
                          child: Text('Nenhuma receita encontrada.'),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: recipeProvider.filteredRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe =
                                recipeProvider.filteredRecipes[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: RecipeCard(
                                recipe: recipe,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/recipe_detail',
                                    arguments: recipe,
                                  );
                                },
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // <-- Adicionei o FloatingActionButton
        onPressed: () {
          Navigator.pushNamed(context, '/add_recipe');
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
