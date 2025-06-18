// lib/screens/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:ki_fome/models/recipe.dart';
import 'package:provider/provider.dart'; // Importe o provider
import 'package:ki_fome/providers/recipe_provider.dart'; // Importe seu provider

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe; // A receita que será exibida nesta tela

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Usamos o Selector para otimizar: só reconstrói se a propriedade isFavorite mudar
    return Selector<RecipeProvider, bool>(
      selector:
          (context, provider) =>
              provider.recipes.firstWhere((r) => r.id == recipe.id).isFavorite,
      builder: (context, isFavorite, child) {
        // Agora 'isFavorite' reflete o estado atual da receita no provider

        return Scaffold(
          appBar: AppBar(
            title: Text(recipe.name),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  // Acessa o provider e chama o método toggleFavorite
                  Provider.of<RecipeProvider>(
                    context,
                    listen: false,
                  ).toggleFavorite(recipe.id);
                  // Opcional: mostrar um feedback visual (ex: SnackBar)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? 'Receita removida dos favoritos!'
                            : 'Receita adicionada aos favoritos!',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagem da Receita
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    // Image.asset para imagens locais
                    recipe.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          size: 80,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16.0),

                // Nome da Receita
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 8.0),

                // Tempo de Preparo
                Row(
                  children: [
                    const Icon(Icons.timer, size: 20.0, color: Colors.grey),
                    const SizedBox(width: 8.0),
                    Text(
                      'Tempo de preparo: ${recipe.prepTimeMinutes} minutos',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32.0),

                // Seção de Ingredientes
                const Text(
                  'Ingredientes:',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      recipe.ingredients
                          .map(
                            (ingredient) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Text(
                                '• $ingredient',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ),
                          )
                          .toList(),
                ),
                const Divider(height: 32.0),

                // Seção de Modo de Preparo
                const Text(
                  'Modo de Preparo:',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      recipe.instructions.asMap().entries.map((entry) {
                        int index = entry.key;
                        String instruction = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '${index + 1}. $instruction',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
