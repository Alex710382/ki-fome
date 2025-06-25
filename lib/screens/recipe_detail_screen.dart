// lib/screens/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:ki_fome/models/recipe.dart';
import 'package:provider/provider.dart';
import 'package:ki_fome/providers/recipe_provider.dart';
import 'package:ki_fome/screens/add_recipe_screen.dart'; // Importe a tela de adicionar receita
import 'dart:io'; // Adicione esta linha

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe; // A receita que será exibida nesta tela

  const RecipeDetailScreen({super.key, required this.recipe});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirmar Exclusão'),
            content: const Text('Tem certeza que deseja excluir esta receita?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Provider.of<RecipeProvider>(
                    context,
                    listen: false,
                  ).deleteRecipe(recipe.id);
                  Navigator.of(ctx).pop(); // Fecha o AlertDialog
                  Navigator.of(
                    context,
                  ).pop(); // Volta para a tela anterior (HomeScreen)
                },
              ),
            ],
          ),
    );
  }

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
              // Botão de Editar
              IconButton(
                icon: const Icon(Icons.edit), // Ícone de lápis para editar
                onPressed: () {
                  // Navega para a tela AddRecipeScreen, passando a receita para edição
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => AddRecipeScreen(
                            recipeToEdit: recipe, // Passa a receita existente
                          ),
                    ),
                  );
                },
              ),
              // Botão de Favoritar
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
                  ).toggleFavorite(recipe);
                },
              ),
              // Botão de Deletar
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagem da Receita
                if (recipe.imageUrl.startsWith('assets/'))
                  Image.asset(
                    recipe.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                else if (recipe.imageUrl.isNotEmpty)
                  Image.file(
                    File(recipe.imageUrl), // Carregar do caminho do arquivo
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  )
                else
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 16.0),
                // Tempo de Preparo
                Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.grey),
                    const SizedBox(width: 8.0),
                    Text(
                      'Tempo de Preparo: ${recipe.prepTimeMinutes} minutos',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

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
