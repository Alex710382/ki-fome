// lib/widgets/recipe_card.dart
import 'package:flutter/material.dart';
import 'package:ki_fome/models/recipe.dart';
import 'dart:io'; // Importar para File

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Determine se a imagem é um asset (caminho começa com 'assets/') ou um arquivo local
    Widget imageWidget;
    if (recipe.imageUrl.startsWith('assets/')) {
      imageWidget = Image.asset(
        recipe.imageUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 180,
            width: double.infinity,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          );
        },
      );
    } else {
      // Tenta carregar como File.image (para imagens da galeria/câmera salvas localmente)
      imageWidget = Image.file(
        File(recipe.imageUrl), // Cria um File a partir do caminho
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback se o arquivo não for encontrado ou corrompido
          return Container(
            height: 180,
            width: double.infinity,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          );
        },
      );
    }

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
              child: imageWidget, // Usar o widget de imagem determinado
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 16.0, color: Colors.grey),
                      const SizedBox(width: 4.0),
                      Text(
                        '${recipe.prepTimeMinutes} min',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        recipe.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: recipe.isFavorite ? Colors.red : Colors.grey,
                        size: 20.0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Categoria: ${recipe.category}',
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
