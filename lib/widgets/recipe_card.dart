// lib/widgets/recipe_card.dart
import 'package:flutter/material.dart';
import 'package:ki_fome/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap; // Usamos VoidCallback para o evento de clique

  const RecipeCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detecta gestos como toques
      onTap: onTap, // Chama a função onTap quando o card é clicado
      child: Card(
        elevation: 4.0, // Sombra para dar profundidade ao card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Bordas arredondadas
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Estica a imagem na largura
          children: [
            ClipRRect(
              // Arredonda as bordas da imagem para combinar com o card
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
              child: Image.asset(
                recipe.imageUrl,
                height: 180, // Altura fixa para as imagens
                fit:
                    BoxFit
                        .cover, // Preenche o espaço cortando a imagem se necessário
                errorBuilder: (context, error, stackTrace) {
                  // Caso a imagem não carregue, exibe um ícone
                  return Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2, // Limita o nome a duas linhas
                    overflow:
                        TextOverflow
                            .ellipsis, // Adiciona "..." se o texto for muito longo
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 16.0, color: Colors.grey),
                      const SizedBox(width: 4.0),
                      Text(
                        '${recipe.prepTimeMinutes} min',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
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
